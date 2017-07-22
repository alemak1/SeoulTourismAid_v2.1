//
//  FlickrProgressController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrProgressController.h"
#import "SeoulFlickrSearchController.h"
#import "FlickrSearchResults.h"
#import "FlickrHelper.h"
#import "UIColor+HelperMethods.h"
#import "FlickrPhotoCell.h"


@interface FlickrProgressController () <UITableViewDelegate,UITableViewDataSource>


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



- (IBAction)dismissCurrentViewController:(UIBarButtonItem *)sender;
@end




@implementation FlickrProgressController

FlickrHelper* _flickrHelper;

BOOL isLoading = false;

-(void)viewWillAppear:(BOOL)animated{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"FlickrSearchTerms" ofType:@"plist"];
    
    self.flickrSearchTermsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    
}


-(void)viewDidLoad{
 
   
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setHidesWhenStopped:YES];
    
   
    
    
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"Preparng to perform segue for Flickr search results...");
    
    
    if([segue.identifier isEqualToString:@"showFlickrPhotosSegue"]){
        
    
        SeoulFlickSearchController* seoulFlickrSearchController = (SeoulFlickSearchController*)segue.destinationViewController;
        
        NSLog(@"Segue idenetifier matched.  Preparing for segue to SeoulFlickrSearchController....");
        
        
        NSLog(@"The search results stored in the FlickProgressController is %@",[self.searchResults description]);
        
        seoulFlickrSearchController.searchResults = self.searchResults;
        
        [self.tableView setHidden:NO];
        
        
    }
    
  
    
    
    
}



-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString:@"showFlickrPhotosSegue"]){
     
        
        if(isLoading){
            return NO;
        }
        
        if(self.searchResults == nil){
            return NO;
        }
    }
    
    return YES;
}

-(FlickrHelper *)flickrHelper{
    
    if(_flickrHelper == nil){
        _flickrHelper = [[FlickrHelper alloc] init];
    }
    
    return _flickrHelper;
}


- (IBAction)performSearch:(UIButton *)sender {
    
    NSLog(@"Preparing to search flickr for terms...");
    
    isLoading = true;


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
    

        [self.tableView setHidden:YES];
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
                
                NSLog(@"Performing Flickr search for iPhone");

                    
                [self performSegueWithIdentifier:@"showFlickrPhotosSegue" sender:nil];

                [self.activityIndicator stopAnimating];
                
                isLoading = false;
                
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



- (IBAction)dismissCurrentViewController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
