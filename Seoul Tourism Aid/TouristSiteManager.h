//
//  TouristSiteManager.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteManager_h
#define TouristSiteManager_h

#import <Foundation/Foundation.h>
#import "TouristSiteConfiguration.h"


@interface TouristSiteManager : NSObject

-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category;
-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category andWithCompletionHandler:(void(^)(void))completionHandler;
-(instancetype)initFromCloudWithAllTouristSitesandWithCompletionHandler:(void(^)(void))completionHandler;


-(instancetype)initFromCloudWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(void))completionHandler;

-(NSInteger)totalNumberOfTouristSitesInMasterArray;
-(TouristSiteConfiguration*)getConfigurationObjectFromConfigurationArray:(NSInteger)index;


@end

#endif /* TouristSiteManager_h */
