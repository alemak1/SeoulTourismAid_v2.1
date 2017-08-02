//
//  GooglePlaceCollectionViewController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "GooglePlaceCollectionViewController.h"
#import "GooglePlaceCell.h"

@implementation GooglePlaceCollectionViewController

-(void)viewWillLayoutSubviews{
    
    [[GooglePlaceManager sharedManager] loadGooglePlaceCategoryArrays];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.00 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
        
    });
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[GooglePlaceManager sharedManager] getNumberOfPlacesForCategory:self.placeCategory];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GooglePlaceCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GooglePlaceCell" forIndexPath:indexPath];
    
    GooglePlace* googlePlace = [[GooglePlaceManager sharedManager] getGooglePlaceForPlaceCategory:self.placeCategory andForRow:indexPath.row];
    
    NSLog(@"Google place obtained for indexPath section %ld,row %ld, with debug summary:",indexPath.section,indexPath.row);
    
    [googlePlace showDebugSummary];
    
    if(googlePlace){
        cell.googlePlace = googlePlace;
    }
    
    return cell;
}

@end
