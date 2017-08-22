//
//  UserLocationManager.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "UserLocationManager.h"
#import "Constants.h"

/** Additional functionality: user can opt to monitor for notifications when close to a tourist area (a detail view for the iste can be presented); also, the user can be notified when within a given distance from the hostel **/


//TODO: when the presenting view controller changes to the TouristCategorySelectionController, the tourist regions are added to the store of monitored regions; when the presenting view controller changes to the HostelDirections controller (to be implemented) it monitors for closeness to hostel

//TODO: Use CLLocationManager to monitor for user location updates, not the MKMapItem class method (The ToHostelController will require this to get the route to the hostel).

@interface UserLocationManager () <CLLocationManagerDelegate>

+(NSArray<CLRegion*>*) hostelCircleRegions;

@property CLLocation* lastUpdatedUserLocation;

@property UIViewController* currentPresentingViewController;


@end

@implementation UserLocationManager

static UserLocationManager* mySharedLocationManager;

@synthesize lastUpdatedUserLocation = _lastUpdatedUserLocation;



-(void)setPresentingViewControllerTo:(UIViewController*)presentingViewController{
    
    self.currentPresentingViewController = presentingViewController;
    
}

+(UserLocationManager*) sharedLocationManager{
    
    if(mySharedLocationManager == nil){
        mySharedLocationManager = [[UserLocationManager alloc] init];
    }
    
    return mySharedLocationManager;
}




-(instancetype)init{
    
    self = [super init];
    
    if(self){
        
        
        [self setDelegate:self];
        [self setDistanceFilter:kCLLocationAccuracyHundredMeters];
        [self setDesiredAccuracy:kCLLocationAccuracyBest];
        
        UserLocationManager* __weak weakSelf = self;
        
        
        /** Register to receive notifications for when the app enter foreground or background so that the app can toggle between standard location monitoring (i.e. the foreground case) and significant location monitoring (i.e. the background case) **/
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
                // Stop normal location updates and start significant location change updates for battery efficiency.
                
                [weakSelf stopUpdatingLocation];
                [weakSelf startMonitoringSignificantLocationChanges];
            }
            else {
                NSLog(@"Significant location change monitoring is not available.");
            }
        }];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
                // Stop significant location updates and start normal location updates again since the app is in the forefront.
                [weakSelf stopMonitoringSignificantLocationChanges];
                [weakSelf startUpdatingLocation];
            }
            else {
                NSLog(@"Significant location change monitoring is not available.");
            }
            
            
            
        }];
        
    }
    
    
    return self;
}

-(void) requestAuthorizationAndStartUpdates{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // If status is not determined, then we should ask for authorization.
        [self requestAlwaysAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        // If authorization has been denied previously, inform the user.
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services" message:@"Location services were previously denied by the user. Please enable location services for this app in settings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self.currentPresentingViewController presentViewController:alert animated:YES completion:nil];
    } else { // We do have authorization.
        // Start the standard location service.
        [self startUpdatingLocation];
        [self setAllowsBackgroundLocationUpdates:YES];
    }
}




-(void)startMonitoringForRegions:(NSSet<CLRegion*>*)regions{
    
    for(CLRegion* region in regions){
        
        [region setNotifyOnExit:YES];
        [region setNotifyOnEntry:YES];
        
        [self startMonitoringForRegion:region];
    }
}

-(void)startMonitoringForSingleRegion:(CLRegion*)region{
    
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]){
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
            
            
            NSLog(@"App has started monitoring region %@",[region identifier]);
            
            [region setNotifyOnExit:YES];
            [region setNotifyOnEntry:YES];
            
            [self startMonitoringForRegion:region];
            
        } else {
            NSLog(@"Authorization has been denied for region monitoring");
            [self requestAlwaysAuthorization];
        }
        
    } else {
        NSLog(@"Your device hardware does not support region monitoring...");
    }
}

-(void)stopMonitoringForSingleRegion:(CLRegion*)region{
    
    [self stopMonitoringForRegion:region];
}


-(BOOL)isUnderRegionMonitoring:(NSString*)regionIdentifier{
    
    NSSet* monitoredRegions = [self monitoredRegions];
    
    for (CLRegion* region in monitoredRegions) {
        if([region.identifier isEqualToString:regionIdentifier]){
            return YES;
        }
    }
    
    return NO;
}

-(CLRegion*)getRegionWithIdentifier:(NSString*)regionIdentifier{
    
    NSSet* monitoredRegions = [self monitoredRegions];
    
    for (CLRegion* region in monitoredRegions) {
        if(region.identifier == regionIdentifier){
            return region;
        }
    }
    
    return nil;
}

-(void)stopMonitoringForRegions:(NSSet<CLRegion*>*)regions{
    
    for(CLRegion* region in regions){
        [self stopMonitoringForRegion:region];
    }
}


// When the user has granted authorization, start the standard location service.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        // Start the standard location service.
        [self startUpdatingLocation];
        
        
    }
    
    
}

// A core location error occurred.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError description: %@", [error localizedDescription]);
    NSLog(@"didFailWithError reason for failure: %@", [error localizedFailureReason]);

    [self startUpdatingLocation];
    
}

// The system delivered a new location.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    // Work around a bug in MapKit where user location is not initially zoomed to.
    if (oldLocation == nil && oldLocation != newLocation) {
        
       
        _lastUpdatedUserLocation = newLocation;

        
        
        
         NSLog(@"The newLocation is lat: %f, long: %f",_lastUpdatedUserLocation.coordinate.latitude,_lastUpdatedUserLocation.coordinate.longitude);
        
        
        NSDictionary* userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:newLocation,@"userLocation", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLocationDidUpdateNotification" object:nil userInfo:userInfoDict];
        
        // Zoom to the current user location.
        /**
         MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500.0, 1500.0);
         [self.regionsMapView setRegion:userLocation animated:YES];
         **/
    }
}

// The device entered a monitored region.
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
    
    NSString* siteName = [region identifier];
    
    CLCircularRegion* circularRegion = (CLCircularRegion*)region;
    
    CLLocationDistance distanceToRegionCenter = [self getDistanceToRegionCenter:circularRegion.center];
    
    NSString* alertTitle = [NSString stringWithFormat:@"You are very close to %@",siteName];
    NSString* alertMessage = [NSString stringWithFormat:@"The tourst site %@ is %f meters away. Do you want directions to get there?",siteName,distanceToRegionCenter];
    
    
    UIAlertController* alerController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Give me directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertAction){
        
        
        [self viewLocationInMapsTo:circularRegion.center andWithPlacemarkName:circularRegion.identifier];
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No thanks" style:UIAlertActionStyleDefault handler:nil];
    
    
    [alerController addAction:okayAction];
    [alerController addAction:cancelAction];
    
    
    /** Each time the user enters the region, the date is stored in an array, accessible via UserDefaults using a key corresponding to the region identifier **/
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:region.identifier];

    
    [self.currentPresentingViewController presentViewController:alerController animated:YES completion:nil];
    
    
    
}

// The device exited a monitored region.
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSString* siteName = [region identifier];
    
    CLCircularRegion* circularRegion = (CLCircularRegion*)region;
    
    CLLocationDistance distanceToRegionCenter = [self getDistanceToRegionCenter:circularRegion.center];
    
    NSString* alertTitle = [NSString stringWithFormat:@"You have just left the regino  %@",siteName];
    NSString* alertMessage = [NSString stringWithFormat:@"The tourst site %@ is %f meters away. Do you want directions to get there?",siteName,distanceToRegionCenter];
    
    
    UIAlertController* alerController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Give me directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertAction){
        
        [self viewLocationInMapsTo:circularRegion.center andWithPlacemarkName:circularRegion.identifier];
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No thanks" style:UIAlertActionStyleDefault handler:nil];
    
    
    [alerController addAction:okayAction];
    [alerController addAction:cancelAction];
    
    [self.currentPresentingViewController presentViewController:alerController animated:YES completion:nil];
    
    
    
}

// A monitoring error occurred for a region.
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, event);
    
}

-(CLLocation*)getLastUpdatedUserLocation{
    return self.lastUpdatedUserLocation;
}


-(CLLocationDistance)getDistanceToRegionCenter:(CLLocationCoordinate2D)regionCenter{
    /** Initialize a MapItem with user's current location **/
    
    CLLocationDistance distanceBetweenEndpoints = [self.lastUpdatedUserLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:regionCenter.latitude longitude:regionCenter.longitude]];
    
    return distanceBetweenEndpoints;
    
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    if(state == CLRegionStateInside){
        NSString* siteName = [region identifier];
        
        
        NSString* alertTitle = [NSString stringWithFormat:@"You are currently inside the region  %@",siteName];
        
        
        
        UIAlertController* alerController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Give me directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertAction){
            
            
        }];
        
        
        [alerController addAction:okayAction];
        
        [self.currentPresentingViewController presentViewController:alerController animated:YES completion:nil];
        
        
    } else {
        NSString* siteName = [region identifier];
        
        
        NSString* alertTitle = [NSString stringWithFormat:@"You are currently NOT inside the region  %@",siteName];
        
        
        
        UIAlertController* alerController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Give me directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertAction){
            
            
        }];
        
        
        [alerController addAction:okayAction];
        
        [self.currentPresentingViewController presentViewController:alerController animated:YES completion:nil];
    }
}

-(void)viewLocationInMapsFromHostelTo:(CLLocationCoordinate2D)toLocationCoordinate{
    
    
    /** Initialize a MapItem with user's current location **/
    
    CLLocationCoordinate2D hostelLocation = CLLocationCoordinate2DMake(37.5394623, 126.9461431);
    
    MKPlacemark* hostelLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:hostelLocation];
    
    MKMapItem* fromLocation = [[MKMapItem alloc] initWithPlacemark:hostelLocationPlacemark];
    
    
    
    /** Initialize a MapItem with the center coordinate of the region that the user has just entered **/
    MKPlacemark* toLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:toLocationCoordinate];
    
    MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:toLocationPlacemark];
    
    
    
    CLLocationDistance distanceBetweenEndpoints = [self.lastUpdatedUserLocation distanceFromLocation:toLocationPlacemark.location];
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(hostelLocation, distanceBetweenEndpoints*1.5, distanceBetweenEndpoints*1.5);
    
    
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation,toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey,
                                  MKLaunchOptionsDirectionsModeDefault,MKLaunchOptionsDirectionsModeKey, nil]];
    
}

-(void)viewLocationInMapsTo:(CLLocationCoordinate2D)regionCenter andWithPlacemarkName:(NSString*)placemarkName{
    
    /** Initialize a MapItem with user's current location **/
    CLLocationCoordinate2D userLocation = self.lastUpdatedUserLocation.coordinate;
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation];
    MKMapItem* fromLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    fromLocation.name = @"Current Location";
    
    
    /** Initialize a MapItem with the center coordinate of the region that the user has just entered **/
    
    MKPlacemark* regionPlacemark = [[MKPlacemark alloc] initWithCoordinate:regionCenter];
    
    MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:regionPlacemark];
    toLocation.name = placemarkName;
    
    
    CLLocationDistance distanceBetweenEndpoints = [self.lastUpdatedUserLocation distanceFromLocation:regionPlacemark.location];
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, distanceBetweenEndpoints*1.5, distanceBetweenEndpoints*1.5);
    
    
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation,toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey,
                                  MKLaunchOptionsDirectionsModeDefault,MKLaunchOptionsDirectionsModeKey, nil]];
}

-(CLLocation *)lastUpdatedUserLocation{
    
   
    return _lastUpdatedUserLocation;
}

-(void)setLastUpdatedUserLocation:(CLLocation *)lastUpdatedUserLocation{
    
    _lastUpdatedUserLocation = lastUpdatedUserLocation;
    
}


@end


/** 
 
 
 +(NSArray<CLRegion *> *)hostelCircleRegions{
 
 
 CLLocationCoordinate2D hostelCenterCoordinate = CLLocationCoordinate2DMake(37.5416235, 126.950725);
 
 NSMutableArray<CLRegion*>* hostelCircleRegions = [[NSMutableArray alloc] initWithCapacity:20];
 
 for(int i = 1; i < 21; i++){
 CLCircularRegion* hostelRegion = [[CLCircularRegion alloc] initWithCenter:hostelCenterCoordinate radius:20.00 identifier:[NSString stringWithFormat:@"hostelCircle-%d",i]];
 
 [hostelCircleRegions addObject:hostelRegion];
 
 }
 
 
 return [NSArray arrayWithArray:hostelCircleRegions];
 
 
 }
 
 **/
