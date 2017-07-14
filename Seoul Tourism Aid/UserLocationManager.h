//
//  UserLocationManager.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef UserLocationManager_h
#define UserLocationManager_h

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface UserLocationManager : CLLocationManager


+(UserLocationManager*) sharedLocationManager;


-(void) requestAuthorizationAndStartUpdates;

-(void)startMonitoringForRegions:(NSSet<CLRegion*>*)regions;
-(void)stopMonitoringForRegions:(NSSet<CLRegion*>*)regions;

-(void)startMonitoringForSingleRegion:(CLRegion*)region;
-(void)stopMonitoringForSingleRegion:(CLRegion*)region;



-(CLLocation*)getLastUpdatedUserLocation;

-(void)setPresentingViewControllerTo:(UIViewController*)presentingViewController;

-(BOOL)isBeingRegionMonitored:(NSString*)regionIdentifier;
-(CLRegion*)getRegionWithIdentifier:(NSString*)regionIdentifier;


-(void)viewLocationInMapsTo:(CLLocationCoordinate2D)regionCenter;
-(void)viewLocationInMapsFromHostelTo:(CLLocationCoordinate2D)toLocationCoordinate;

@end

#endif /* UserLocationManager_h */
