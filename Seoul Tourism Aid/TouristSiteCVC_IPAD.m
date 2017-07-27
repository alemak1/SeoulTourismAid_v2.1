//
//  TouristSiteCVC_IPAD.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteCVC_IPAD.h"
#import "TouristSiteCollectionViewCell.h"
#import "UIView+HelperMethods.h"
#import "TouristSiteManager.h"

#import "TouristSiteSectionHeaderCell.h"
#import "CloudKitHelper.h"

@interface TouristSiteCVC_IPAD ()


@property (readonly) CloudKitHelper* ckHelper;
@property (readonly) NSDictionary* dataSourceDict;


@property NSMutableArray<TouristSiteConfiguration*>* masterArray;

@property NSMutableArray<TouristSiteConfiguration*>* yangguSites;
@property NSMutableArray<TouristSiteConfiguration*>* naturalSites;
@property NSMutableArray<TouristSiteConfiguration*>* seoulTowerSites;
@property NSMutableArray<TouristSiteConfiguration*>* museumSites;
@property NSMutableArray<TouristSiteConfiguration*>* parkSites;
@property NSMutableArray<TouristSiteConfiguration*>* otherSites;
@property NSMutableArray<TouristSiteConfiguration*>* gwanghuamunSites;
@property NSMutableArray<TouristSiteConfiguration*>* shoppingSites;
@property NSMutableArray<TouristSiteConfiguration*>* templeSites;
@property NSMutableArray<TouristSiteConfiguration*>* monumentSites;

@property (readonly) NSOrderedSet* sectionKeyArray;
@property (readonly) NSArray<NSString*>* genericHeaderViewTitles;

@end


@implementation TouristSiteCVC_IPAD


 NSString* const kSeoulTowerKey  = @"Seoul Tower ";
 NSString* const kYangguKey = @"Yanggu County";
 NSString* const kNaturalSiteKey = @"Natural Sites";
 NSString* const kMuseumKey = @"Museums";
 NSString* const kParkSites = @"Parks";
 NSString* const kOtherSites = @"Other Sites of Interests";


 NSString* const kGwanghuamunSites = @"Gyeongbokgung Palace Area";
 NSString* const kShoppingSites = @"Malls and Other Shopping Areas";
 NSString* const kTempleSites = @"Temples";
 NSString* const kMonumentSites = @"Monuments and Other Cultural Sites";



static void* ObservedArrayContext = &ObservedArrayContext;

@synthesize ckHelper = _ckHelper;
@synthesize dataSourceDict = _dataSourceDict;



-(NSString*)getRandomGenericHeaderTitle{
    
    int totalGenericTitles = (int)[self.genericHeaderViewTitles count];
    
    int randomIndex = (int)arc4random_uniform(totalGenericTitles);
    
    return [self.genericHeaderViewTitles objectAtIndex:randomIndex];
}

-(NSArray<NSString *> *)genericHeaderViewTitles{
    return @[@"Don't miss out on these places...",@"Make sure to visit the sites below...",@"Check out the places below...",@"Be sure to include the sites below in your itinerary",@"If you go to Seoul, don't forget to see the sites below...",@"If you have time, be sure to see the places below.",@"The sites below are definitely worth a visit.",@"Try to make a trip to one of the sites below, you won't regret it!",@"Seoul is full of cool places to see, like these...",@"You haven't seen all of Seoul until you see the places below...",@"A trip to Seoul won't be complete until you check out the places below...",@"While you are in Seoul, try to pay a visit to the places below...."];
}

-(void)viewWillAppear:(BOOL)animated{
    
    /**  Alternative implementations for code below coud also involve filtering the TouristSiteManager from the parent view controller to generate a copy with only the objects that are true for the filtering condition **/
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:OTHER andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];

    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:PARK andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];

    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:NATURAL_SITE andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
        
        }];
        
        
        
    }];
    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:SEOUL_TOWER andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];
    
   

    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:SHOPPING_AREA andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];
    
    
    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:MUSUEM andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];
    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:TEMPLE andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];
    
    [self.ckHelper performLoopQueryWithTouristSiteCategory:YANGGU_COUNTY andWithBatchCompletionHandler:^(CKRecord*record){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self populateDataSourceArrayWithTouristSiteConfiguration:siteConfiguration];
            
            NSLog(@"Record info %@",[record description]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        
        
    }];
    
    
    
    
    
}
     
    
    





-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSString* sectionKeyString = [self.sectionKeyArray objectAtIndex:section];
    
    NSArray* array = [self.dataSourceDict valueForKey:sectionKeyString];
   
    return [array count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    

    return [self.sectionKeyArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Getting next tourist site configuration cell..");

    
    TouristSiteCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TouristCollectionViewCell" forIndexPath:indexPath];
    
    [self configureTouristCollectionCell:cell forIndexPath:indexPath];
    
    return cell;
    
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    TouristSiteSectionHeaderCell* view = nil;

    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
       
        view = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TouristSiteSectionHeaderCell" forIndexPath:indexPath];
                
        view.titleText = [self getRandomGenericHeaderTitle];
        
        
    }
    
    return view;

}


-(void)configureTouristCollectionCell:(TouristSiteCollectionViewCell*)cell forIndexPath:(NSIndexPath*)indexPath{
    

    NSLog(@"Getting next tourist site configuration cell..");
    
    NSString* sectionKeyString = [self.sectionKeyArray objectAtIndex:indexPath.section];
    
    NSArray* array = [self.dataSourceDict valueForKey:sectionKeyString];
    
   

    
    TouristSiteConfiguration* configurationObject = [array objectAtIndex:indexPath.row];
    

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


-(void)populateDataSourceArrayWithTouristSiteConfiguration:(TouristSiteConfiguration*)siteConfiguration{
    
    
    if(siteConfiguration.touristSiteCategory == SHOPPING_AREA){
        NSLog(@"Adding a GWANGHUAMUN tourist site configuration...");
        [self.shoppingSites addObject:siteConfiguration];
    }
    
    
    if(siteConfiguration.touristSiteCategory == TEMPLE){
        NSLog(@"Adding a GWANGHUAMUN tourist site configuration...");
        [self.templeSites addObject:siteConfiguration];
    }
    
   
    if(siteConfiguration.touristSiteCategory == PARK){
        NSLog(@"Adding a PARK tourist site configuration...");
        [self.parkSites addObject:siteConfiguration];
    }
    
    if(siteConfiguration.touristSiteCategory == MUSUEM){
        NSLog(@"Adding a MUSEUM tourist site configuration...");
        [self.museumSites addObject:siteConfiguration];
    }
    
    if(siteConfiguration.touristSiteCategory == YANGGU_COUNTY){
        NSLog(@"Adding a YANGGU COUNTY tourist site configuration...");
        
        [self.yangguSites addObject:siteConfiguration];
        
    }
    
    if(siteConfiguration.touristSiteCategory == SEOUL_TOWER){
        NSLog(@"Adding a SEOUL TOWER tourist site configuration...");
        
        [self.seoulTowerSites addObject:siteConfiguration];
        
        
    }
    
    if(siteConfiguration.touristSiteCategory == NATURAL_SITE){
        NSLog(@"Adding a NATURAL SITE tourist site configuration...");
        
        [self.naturalSites addObject:siteConfiguration];
        
        
    }
    
    if(siteConfiguration.touristSiteCategory == OTHER){
        NSLog(@"Adding a OTHER SITE tourist site configuration...");
        
        [self.otherSites addObject:siteConfiguration];
        
        
    }

}

/** Helper methods for implementing the collection view data source methods **/

-(NSDictionary *)dataSourceDict{
    if(_dataSourceDict == nil){
        
        _dataSourceDict = @{
                            
            kMuseumKey:self.museumSites,
            kYangguKey:self.yangguSites,
            kNaturalSiteKey:self.naturalSites,
            kSeoulTowerKey:self.seoulTowerSites,
            kParkSites:self.parkSites,
            kOtherSites:self.otherSites,
            kShoppingSites:self.shoppingSites,
            kTempleSites:self.templeSites
            
                            
                };
       
    }
    
    return _dataSourceDict;
}


-(CloudKitHelper *)ckHelper{
    if(_ckHelper == nil){
        
        _ckHelper = [[CloudKitHelper alloc] init];
    }
    
    return _ckHelper;
}


-(NSOrderedSet*) sectionKeyArray{
    
    return [NSOrderedSet orderedSetWithObjects:kMuseumKey,kTempleSites,kShoppingSites,kNaturalSiteKey,kParkSites,kOtherSites,kSeoulTowerKey,kYangguKey, nil];
}





/** Section Arrays (provides data source for each section) **/

-(NSMutableArray<TouristSiteConfiguration *> *)gwanghuamunSites{
    if(_gwanghuamunSites == nil){
        _gwanghuamunSites = [[NSMutableArray alloc] init];
    }
    
    return _gwanghuamunSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)shoppingSites{
    if(_shoppingSites == nil){
        _shoppingSites = [[NSMutableArray alloc] init];
    }
    
    return _shoppingSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)templeSites{
    if(_templeSites == nil){
        _templeSites = [[NSMutableArray alloc] init];
    }
    
    return _templeSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)monumentSites{
    if(_monumentSites == nil){
        _monumentSites = [[NSMutableArray alloc] init];
    }
    
    return _monumentSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)otherSites{
    if(_otherSites == nil){
        _otherSites = [[NSMutableArray alloc] init];
    }
    
    return _otherSites;
}


-(NSMutableArray<TouristSiteConfiguration *> *)parkSites{
    if(_parkSites == nil){
        _parkSites = [[NSMutableArray alloc] init];
    }
    
    return _parkSites;
}


-(NSMutableArray<TouristSiteConfiguration *> *)yangguSites{
    if(_yangguSites == nil){
        _yangguSites = [[NSMutableArray alloc] init];
    }
    
    return _yangguSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)museumSites{
    if(_museumSites == nil){
        _museumSites = [[NSMutableArray alloc] init];
    }
    
    return _museumSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)naturalSites{
    if(_naturalSites == nil){
        _naturalSites = [[NSMutableArray alloc] init];
    }
    
    return _naturalSites;
}

-(NSMutableArray<TouristSiteConfiguration *> *)seoulTowerSites{
    if(_seoulTowerSites == nil){
        _seoulTowerSites = [[NSMutableArray alloc] init];
    }
    
    return _seoulTowerSites;
}




@end

