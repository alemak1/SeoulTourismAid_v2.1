//
//  SeoulFlickrSearchController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "SeoulFlickrSearchController.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoCell.h"
#import "UIColor+HelperMethods.h"

@interface SeoulFlickSearchController () <UICollectionViewDelegateFlowLayout>




- (IBAction)dismissViewController:(UIButton *)sender;


@end

@implementation SeoulFlickSearchController



-(void)viewWillLayoutSubviews{
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    

 
}




-(FlickrPhoto*)photoForIndexPath:(NSIndexPath*)indexPath{
    
    return [self.searchResults.searchResults objectAtIndex:indexPath.row];
}


#pragma mark COLLECTIONVIEW DATASOURCE METHODS

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.searchResults.searchResults count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Getting cell for collection view...");
    
    FlickrPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrPhotoCell" forIndexPath:indexPath];
    
    FlickrPhoto* flickrPhoto = [self photoForIndexPath:indexPath];
    
    
    
    cell.outletImageView.image = flickrPhoto.thumbnail;
    
    cell.backgroundColor = [UIColor skyBlueColor];
    
    
    
    
    return cell;
}


#pragma mark COLLECTIONVIEW DELEGATE METHODS

/**
 -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
 return CGSizeMake(200, 300);
 }
 -(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
 
 return 30;
 }
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
 
 return UIEdgeInsetsMake(10, 20, 20, 10);
 }
 **/


- (IBAction)dismissViewController:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];


}


@end


/**
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
 
 [self.flickrHelper searchFlickrForTerm:@"kimchi" andWithCompletionHandler:^(FlickSearchResults* results, NSError*error){
 
 if(error){
 NSLog(@"An error occured while performing the search %@",error);
 }
 
 if(!results){
 NSLog(@"No results obtained from search");
 }
 
 NSLog(@"Flickr search results info %@",[results description]);
 
 [self.searches addObject:results];
 
 
 NSInteger numberOfSections = [self.searches count];
 
 NSInteger numberOfRowsInSection1 = [[self.searches objectAtIndex:0].searchResults count];
 
 NSLog(@"Number of Sections %d, Number of rows in section 1 is %d",numberOfSections,numberOfRowsInSection1);
 
 }];
 
 
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 NSLog(@"Reloading collection view...");
 [self.collectionView reloadData];
 
 });
 
 });
 **/

/**
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
 
 NSLog(@"Reloading collection view...");
 
 [self.collectionView reloadData];
 
 for (FlickSearchResults*searchResults in self.searches) {
 
 for(FlickrPhoto*photo in searchResults.searchResults){
 NSLog(@"Flickr photo info %@",[photo description]);
 
 NSURL*photoURL = [photo getFlickrImageURLWithSize:@"m"];
 
 NSLog(@"The URL for this photo is %@",[photoURL absoluteString]);
 
 
 }
 }
 });

**/
