//
//  TouristSiteManager.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteManager.h"
#import "CloudKitHelper.h"

@interface TouristSiteManager ()


@property NSMutableArray<TouristSiteConfiguration*>* configurationArray;

@property (nonatomic) CloudKitHelper* ckHelper;

@end


@implementation TouristSiteManager

@synthesize ckHelper = _ckHelper;


-(instancetype)initFromCloudWithAllTouristSiteCategoryAndWithBatchCompletionHandler:(void(^)(void))completionHandler{
    
    self = [super init];
    
    
    [self.ckHelper performLoopQueryForAllTouristSitesandWithBatchCompletionHandler:^(CKRecord*record){
        
        if(!record){
            NSLog(@"Error: no results available for the download");
        }
        
        
        self.configurationArray = [[NSMutableArray alloc] init];

        TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
        
        [self.configurationArray addObject:siteConfiguration];
        
        
        completionHandler();
        
    }];
    
    
    
    
    return self;
    
}


-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(void))completionHandler{
    
    self = [super init];

    self.configurationArray = [[NSMutableArray alloc] init];

    [self.ckHelper performLoopQueryWithTouristSiteCategory:category andWithBatchCompletionHandler:^(CKRecord*record){
    
    if(!record){
        NSLog(@"Error: no results available for the download");
    }
    
        
    TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
        
    [self.configurationArray addObject:siteConfiguration];
        

    completionHandler();
    
    }];




    return self;

}


-(instancetype)initFromCloudWithAllTouristSitesandWithCompletionHandler:(void(^)(void))completionHandler{
    
    self = [super init];
    
    [self.ckHelper performAnnotationQueryForAllTouristSitesWithCompletionHandler:^(NSArray<CKRecord*>*results,NSError*error){
        
        
        if(error){
            NSLog(@"An error occurred while downloading the results: %@",[error localizedDescription]);
        }
        
        if(!results){
            NSLog(@"Error: no results available for the download");
        }
        
        self.configurationArray = [[NSMutableArray alloc] init];
        
        for(CKRecord*record in results){
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [self.configurationArray addObject:siteConfiguration];
            
        }
                
        
        completionHandler();
        
    }];
    
    
    
    
    return self;
    
}

-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category andWithCompletionHandler:(void(^)(void))completionHandler{
    
    self = [super init];
    
    [self.ckHelper performAnnotationQueryWithTouristSiteCategory:category andWithCompletionHandler:^(NSArray<CKRecord*>*results,NSError*error){
        
        
        if(error){
            NSLog(@"An error occurred while downloading the results: %@",[error localizedDescription]);
        }
        
        if(!results){
            NSLog(@"Error: no results available for the download");
        }
        
        NSMutableArray<TouristSiteConfiguration*>* touristSiteArray = [[NSMutableArray alloc] init];
        
        for(CKRecord*record in results){
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
            
            [touristSiteArray addObject:siteConfiguration];
            
        }
        
        self.configurationArray = touristSiteArray;
        
        completionHandler();
        
    }];
    
    

    
    return self;
    
}

-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category{
    
    self = [super init];
    
    if(self){
    
        
        [self.ckHelper performAnnotationQueryWithTouristSiteCategory:category andWithCompletionHandler:^(NSArray<CKRecord*>*results,NSError*error){
        
            
            if(error){
                NSLog(@"An error occurred while downloading the results: %@",[error localizedDescription]);
            }
            
            if(!results){
                NSLog(@"Error: no results available for the download");
            }
            
            
            NSMutableArray<TouristSiteConfiguration*>* touristSiteArray = [[NSMutableArray alloc] init];
            
            for(CKRecord*record in results){
                
                TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initWithCKRecord:record];
                
                [touristSiteArray addObject:siteConfiguration];
            
            }
            
            self.configurationArray = touristSiteArray;
            
        
        }];
        
        
    }
    
    
    return self;
    
}

-(CloudKitHelper *)ckHelper{
    
    if(_ckHelper == nil){
        
        _ckHelper = [[CloudKitHelper alloc] init];
        
    }
    
    return _ckHelper;
}



#pragma mark COLLECTION VIEW DATA SOURCE METHODS

-(NSInteger)totalNumberOfTouristSitesInMasterArray{
    
    if(self.configurationArray){
        
        return [self.configurationArray count];
    } else {
        
        return 0;

    }
    
}

-(NSInteger)totalNumberOfTouristSitesForCategory:(TouristSiteCategory)
category{
    
    
    NSLog(@"Calculatnig the total number of tourist sites for section: %d",category);
    
    NSArray<TouristSiteConfiguration*>* filteredArray = [self.configurationArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TouristSiteConfiguration*configuration,NSDictionary*bindings){
    
    
        return configuration.touristSiteCategory == category;
    }]];
    
    if(filteredArray){
        return [filteredArray count];
    }
    
    return 0;
}

-(TouristSiteConfiguration*)getTouristSiteConfigurationForIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"Getting tourist site configuration for indexPath: %@",[indexPath description]);
    
    TouristSiteCategory indexPathCategory = (int)indexPath.section;
    
    NSArray<TouristSiteConfiguration*>* filteredArray = [self.configurationArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TouristSiteConfiguration*configuration,NSDictionary*bindings){
        
        
        return configuration.touristSiteCategory == indexPathCategory;
    }]];
    
    return [filteredArray objectAtIndex:indexPath.row];
    
}


-(TouristSiteConfiguration*)getConfigurationObjectFromConfigurationArray:(NSInteger)index{
    
    if(index >= [self.configurationArray count]){
        return nil;
    }
    
    return [self.configurationArray objectAtIndex:index];
}


#pragma mark DEBUG HELPER METHODS

-(void) showSiteManagerDebugInfo{
    
    for (TouristSiteConfiguration*siteConfiguration in self.configurationArray) {
        
        [siteConfiguration showTouristSiteDebugInfo];
        
    }
}


@end
