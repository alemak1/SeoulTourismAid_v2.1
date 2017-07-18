//
//  FlickrProgressControllerIPAD.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "FlickrProgressControllerIPAD.h"

#import "SeoulFlickrSearchController.h"
#import "FlickrSearchResults.h"
#import "FlickrHelper.h"
#import "UIColor+HelperMethods.h"
#import "FlickrPhotoCell.h"


@interface FlickrProgressControllerIPAD () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


typedef enum SectionKey{
    K_POP_BANDS,
    K_POP_STARS,
    FOOD,
    NUMBER_OF_SECTIONS_FOR_KOREAN_SEARCH_TERMS
}SectionKey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property FlickrSearchResults* searchResults;

@property (readonly) FlickrHelper* flickrHelper;

@property NSDictionary* flickrSearchTermsDictionary;
@property NSString* selectedSearchTerm;

- (IBAction)performSearch:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/** For iPads, a collection view will display the results in an embedded collection view controller **/
@property IBOutlet UICollectionView *collectionView;


- (IBAction)dismissCurrentViewController:(UIBarButtonItem *)sender;

- (IBAction)dismissCurrentViewController_iPad:(UIButton *)sender;

@end




@implementation FlickrProgressControllerIPAD

FlickrHelper* _mainFlickrHelper;

BOOL _isLoadingActivityIndicator = false;

-(void)viewWillAppear:(BOOL)animated{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"FlickrSearchTerms" ofType:@"plist"];
    
    self.flickrSearchTermsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    
}


-(void)viewDidLoad{
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.collectionView setHidden:NO];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    [self.tableView reloadData];
}



-(FlickrHelper *)flickrHelper{
    
    if(_mainFlickrHelper == nil){
        _mainFlickrHelper = [[FlickrHelper alloc] init];
    }
    
    return _mainFlickrHelper;
}


- (IBAction)performSearch:(UIButton *)sender {
    
    NSLog(@"Preparing to search flickr for terms...");
    
    _isLoadingActivityIndicator = true;
    
    
    NSLog(@"The selected search term is: %@",self.selectedSearchTerm);
    
    if(self.selectedSearchTerm == nil){
        
        NSLog(@"Can't perform search. No  search term selected");
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No item selected!" message:@"Select a search item in order to view the image gallery!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okay];
        
        [self showViewController:alertController sender:nil];
        
        return;
    }
    
    
    
    NSLog(@"About to perform search....");
    
   
    NSLog(@"About to activate activity indicator and hide container view....");
        
    [self.collectionView setHidden:YES];
    [self.activityIndicator setHidden:NO];
    
    
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        [self.flickrHelper searchFlickrWithDataTaskForTerm:self.selectedSearchTerm andWithCompletionHandler:^(FlickrSearchResults* results, NSError*error){
            
            if(error){
                NSLog(@"Error: an error occured while performing the search %@",[error localizedDescription]);
            }
            
            if(!results){
                NSLog(@"Error: no results obtained from search");
            }
            
            
            self.searchResults = results;
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                    NSLog(@"Updating the UI on the main thread...");
        
                    NSLog(@"Performing UI update for iPad");
                    NSLog(@"CollectionView Info: %@",[self.collectionView description]);
                    
                    [self.collectionView setHidden:NO];
                    [self.activityIndicator setHidden:YES];
    
                    
                    [self.collectionView reloadData];
                    
                    

                [self.activityIndicator stopAnimating];
                
                _isLoadingActivityIndicator = false;
                
                self.selectedSearchTerm = nil;
                
            });
            
            
        }];
        
        
        
        
    });
    
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return NUMBER_OF_SECTIONS_FOR_KOREAN_SEARCH_TERMS;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"The selected search term is: %@",[self getSearchTermForIndexPath:indexPath]);
    
    self.selectedSearchTerm = [self getSearchTermForIndexPath:indexPath];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString* sectionKeyPath = [self getSectionKeyPathForSectionKey:(int)section];
    
    NSArray* searchTermsArray = [self.flickrSearchTermsDictionary valueForKey:sectionKeyPath];
    
    return [searchTermsArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    NSString* searchTerm = [self getSearchTermForIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor skyBlueColor]];
    
    
    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:15.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:searchTerm attributes:attributesDict];
    
    
    
    [cell.textLabel setAttributedText:attributedTitle];
    
    
    return cell;
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel* labelView = [[UILabel alloc] init];
    
    NSString* titleString = [self getSectionKeyPathForSectionKey:section];
    
    
    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Bold" size:25.0],NSFontAttributeName,[UIColor koreanRed],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
    
    [labelView setBackgroundColor:[UIColor skyBlueColor]];
    
    [labelView setAttributedText:attributedTitle];
    
    return labelView;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString* titleString = [self getSectionKeyPathForSectionKey:section];
    
    return titleString;
    
}

-(NSString*)getSearchTermForIndexPath:(NSIndexPath*)indexPath{
    
    NSString* sectionKeyPath = [self getSectionKeyPathForSectionKey:(int)indexPath.section];
    
    NSArray* searchTermsArray = [self.flickrSearchTermsDictionary valueForKey:sectionKeyPath];
    
    return [searchTermsArray objectAtIndex:indexPath.row];
}


-(NSString*)getSectionKeyPathForSectionKey:(SectionKey)sectionKey{
    switch (sectionKey) {
        case K_POP_BANDS:
            return @"K-Pop Groups";
        case K_POP_STARS:
            return @"K-Pop Stars";
        case FOOD:
            return @"Food";
        default:
            return nil;
    }
    
    return nil;
}





#pragma mark COLLECTIONVIEW DATASOURCE METHODS


-(FlickrPhoto*)photoForIndexPath:(NSIndexPath*)indexPath{
    return [self.searchResults.searchResults objectAtIndex:indexPath.row];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.searchResults.searchResults count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Getting cell for collection view...");
    
    FlickrPhotoCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrPhotoCell" forIndexPath:indexPath];
    
    FlickrPhoto* flickrPhoto = [self photoForIndexPath:indexPath];
    
    NSLog(@"The FLickrPhoto for this cell is: %@",[flickrPhoto description]);
    
    cell.outletImageView.image = flickrPhoto.thumbnail;
    
    
    return cell;
}


- (IBAction)dismissCurrentViewController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissCurrentViewController_iPad:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
