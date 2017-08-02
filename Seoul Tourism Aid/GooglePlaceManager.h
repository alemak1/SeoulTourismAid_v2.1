//
//  GooglePlaceManager.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GooglePlaceManager_h
#define GooglePlaceManager_h

#import <Foundation/Foundation.h>
#import "GooglePlace.h"

@import GooglePlaces;

@interface GooglePlaceManager : NSObject


+(GooglePlaceManager*)sharedManager;

-(void)loadCategoryArrayWithUserDefinedCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory andWithSinglePlaceItemCompletionHandler:(void(^)(void))completion;
-(void)loadGooglePlaceCategoryArrays;

-(GooglePlace*)getGooglePlaceForIndexPath:(NSIndexPath*)indexPath;
-(GooglePlace*)getGooglePlaceForPlaceCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory andForRow:(NSInteger)row;

-(NSInteger)getNumberOfPlacesForCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory;


/** Debug Helper Function for All Category Data Sources **/

-(void)showDebugInfoForCategoryArrays;

/** Debug Helper Functions for Specific Category Data Sources **/

-(void)showDebugInfoForMuseums;
-(void)showDebugInfoForParks;
-(void)showDebugInfoForTemples;
-(void) showDebugInfoForNaturalSites;
-(void)showDebugInfoForOtherSites;
-(void)showDebugInfoForMonuments;
-(void)showDebugInfoForNamsanSites;
-(void)showDebugInforForYangguSites;
-(void)showDebugInfoForShoppingCenters;


@end

#endif /* GooglePlaceManager_h */
