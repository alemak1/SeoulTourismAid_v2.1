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
#import <UserNotifications/UserNotifications.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface UserLocationManager : CLLocationManager <UNUserNotificationCenterDelegate>


+(UserLocationManager*) sharedLocationManager;

-(void) requestAuthorizationAndStartUpdates;
-(void)requestAuthorizationAndStartUpdatesWithCompletionHandler:(void(^)(NSNumber*authStatus))completion;

-(void)startMonitoringForRegions:(NSSet<CLRegion*>*)regions;
-(void)startMonitoringForSingleRegion:(CLRegion*)region withCompletionHandler:(void(^)(NSNumber*authStatus))completion;

-(void)stopMonitoringForRegions:(NSSet<CLRegion*>*)regions;

-(void)startMonitoringForSingleRegion:(CLRegion*)region;
-(void)stopMonitoringForSingleRegion:(CLRegion*)region;

-(CLAuthorizationStatus)getAuthorizationStatus;
-(void)checkAuthoriationStatusWithCompletionHandler:(void(^)(NSNumber*authorizationStatus))completion;

-(CLLocation*)getLastUpdatedUserLocation;

-(void)setPresentingViewControllerTo:(UIViewController*)presentingViewController;

-(BOOL)isUnderRegionMonitoring:(NSString*)regionIdentifier;
-(CLRegion*)getRegionWithIdentifier:(NSString*)regionIdentifier;

-(void)clearMonitoredRegions;

-(void)viewLocationInMapsTo:(CLLocationCoordinate2D)regionCenter andWithPlacemarkName:(NSString*)placemarkName;
-(void)viewLocationInMapsFromHostelTo:(CLLocationCoordinate2D)toLocationCoordinate;

@end

#endif /* UserLocationManager_h */
