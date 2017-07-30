//
//  TouristSiteCollectionViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteCollectionViewController.h"
#import "TouristSiteCollectionViewCell.h"
#import "UIView+HelperMethods.h"
#import "TouristSiteManager.h"

@interface TouristSiteCollectionViewController ()

@property TouristSiteManager* siteManager;

@end


@implementation TouristSiteCollectionViewController




-(void)viewWillAppear:(BOOL)animated{
    
  
    
    self.siteManager = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:self.category andWithBatchCompletionHandler:^{
    
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
        
        
            });
    
    }];
    
   
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
    
}



-(void)viewDidLoad{
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    
    return [self.siteManager totalNumberOfTouristSitesInMasterArray];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

  
    return 1;

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TouristSiteCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TouristCollectionViewCell" forIndexPath:indexPath];

    TouristSiteConfiguration* configurationObject = [self.siteManager getConfigurationObjectFromConfigurationArray:indexPath.row];
    
    
    cell.siteImage = [configurationObject largeImage];
    
    cell.titleText = [configurationObject siteTitle];
    
    cell.isOpenStatusText = [configurationObject isOpen] ? @"Open" : @"Closed";
    
    cell.distanceToSiteText = [configurationObject distanceFromUserString];
    
    cell.touristSiteConfigurationObject = configurationObject;

    return cell;
    
}


-(void)configureTouristCollectionCell:(TouristSiteCollectionViewCell*)cell forIndexPath:(NSIndexPath*)indexPath{
    
    TouristSiteConfiguration* configurationObject = [self.siteManager getConfigurationObjectFromConfigurationArray:indexPath.row];
    
   
    cell.siteImage = [configurationObject largeImage];
    
    cell.titleText = [configurationObject siteTitle];
    
    cell.isOpenStatusText = [configurationObject isOpen] ? @"Open" : @"Closed";
    
    
    cell.distanceToSiteText = [configurationObject distanceFromUserString];
    
    cell.touristSiteConfigurationObject = configurationObject;
}

/**
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(300, 200);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20.0;
}

 **/


@end



/** For future iOS tutorials:
 
 
 -(instancetype)initWithTitleText:(NSString*)titleText{
 
 self = [self init];
 
 if(self){
 
 CGRect titleLabeFrame = [self.view getFrameAdjustedRelativeToContentViewWithXCoordOffset:0.0 andWithYCoordOffset:0.0 andWithWidthMultiplier:1.00 andWithHeightMultiplier:0.10];
 
 UILabel* titleLabel = [[UILabel alloc] initWithFrame:titleLabeFrame];
 
 [self setTitleLabel:titleLabel];
 
 [self.titleLabel setText:titleText];
 
 
 CGRect collectionViewFrame = [self.view getFrameAdjustedRelativeToContentViewWithXCoordOffset:0.00 andWithYCoordOffset:0.10 andWithWidthMultiplier:1.00 andWithHeightMultiplier:1.00];
 
 UICollectionViewFlowLayout* flowLayoutObject = [[UICollectionViewFlowLayout alloc] init];
 
 [flowLayoutObject setScrollDirection:UICollectionViewScrollDirectionHorizontal];
 [flowLayoutObject setItemSize:CGSizeMake(200, 100)];
 [flowLayoutObject setMinimumLineSpacing:20.0];
 [flowLayoutObject setMinimumInteritemSpacing:30.0];
 
 UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayoutObject];
 
 [self setCollectionView:collectionView];
 
 [self.view addSubview:self.titleLabel];
 [self.view addSubview:self.collectionView];
 
 [self.view setBackgroundColor:[UIColor yellowColor]];
 [self.collectionView setBackgroundColor:[UIColor blueColor]];
 
 
 }
 
 return self;
 }
 **/

