//
//  GoogleLocationSearchController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "GoogleLocationSearchController.h"
#import "UserLocationManager.h"
#import "Constants.h"

@interface GoogleLocationSearchController () <GMSPlacePickerViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *googleMapViewContainer;


@property GMSMapView* googleMapView;

- (IBAction)searchForLocationsInGoogleMaps:(UIButton *)sender;

- (IBAction)searchForLocationsInAppleMaps:(UIButton *)sender;

- (IBAction)dismissCurrentViewController:(UIButton *)sender;

- (IBAction)showGooglePlacePicker:(UIButton *)sender;

@end

@implementation GoogleLocationSearchController


-(void)viewWillLayoutSubviews{
    
    GMSCameraPosition* initialCameraPosition = [self getInitialCameraPosition];
    
    self.googleMapView = [GMSMapView mapWithFrame:self.googleMapViewContainer.frame camera:initialCameraPosition];
    
    [self.googleMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.googleMapView];
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:[[self.googleMapView topAnchor] constraintEqualToAnchor:[self.googleMapViewContainer topAnchor]],
                                             [[self.googleMapView leftAnchor] constraintEqualToAnchor:[self.googleMapViewContainer leftAnchor]],
                                             [[self.googleMapView rightAnchor] constraintEqualToAnchor:[self.googleMapViewContainer rightAnchor]],
                                             [[self.googleMapView bottomAnchor] constraintEqualToAnchor:[self.googleMapViewContainer bottomAnchor]],
                                             nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [self updateUIWithInitialCameraAndMarkerPosition];

}

-(void)viewDidLoad{
    
    [self updateUIWithInitialCameraAndMarkerPosition];
   
    
    
  
    
    
    
}


-(GMSCameraPosition*)getInitialCameraPosition{
    
    GMSCameraPosition* camera;
    
    if(self.selectedPlace == nil){
        
        
        CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
        
        camera = [GMSCameraPosition cameraWithTarget:userLocation.coordinate zoom:15.0];
        
    } else {
        
        camera = [GMSCameraPosition cameraWithTarget:self.selectedPlace.coordinate zoom:15.0];
        
    }
    
    return camera;

}

-(void)updateUIWithInitialCameraAndMarkerPosition{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        GMSCameraPosition* camera;
        GMSMarker* marker;
        
        if(self.selectedPlace == nil){
            
            
            CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
            
            camera = [GMSCameraPosition cameraWithTarget:userLocation.coordinate zoom:15.0];
            
            marker = [GMSMarker markerWithPosition:userLocation.coordinate];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                marker.title = self.selectedPlace != nil ? self.selectedPlace.name : @"Current Location";
                marker.map = self.googleMapView;
                
                [self.googleMapView animateToCameraPosition:camera];
                
            });
            

        } else {
            
            camera = [GMSCameraPosition cameraWithTarget:self.selectedPlace.coordinate zoom:15.0];
            
            marker = [GMSMarker markerWithPosition:self.selectedPlace.coordinate];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                marker.title = self.selectedPlace != nil ? self.selectedPlace.name : @"Current Location";
                marker.map = self.googleMapView;
                
                [self.googleMapView animateToCameraPosition:camera];
            });
            
        }
        

        
    });
}



- (IBAction)searchForLocationsInGoogleMaps:(UIButton *)sender {
    
    /** Get directions in Google Maps **/
    
    
    
}


- (IBAction)searchForLocationsInAppleMaps:(UIButton *)sender {
    
    
    if(!self.selectedPlace){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No Location Selected" message:@"Select a location on the map to get directions in the Apple Maps App" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okayAction];
        
        [self showViewController:alertController sender:nil];
        
        return;
    }
    
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.coordinate];
    
    MKMapItem* fromLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    
    CLLocationCoordinate2D fromLocationCoordinate = fromLocation.placemark.coordinate;
    
    
    MKPlacemark* toLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.selectedPlace.coordinate];
    
    MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:toLocationPlacemark];
    
    if(self.selectedPlace){
        toLocation.name = self.selectedPlace.name;
    } else {
        toLocation.name = @"Selected Destination";
    }
    
    CLLocation* toLocationCL = [[CLLocation alloc] initWithLatitude:self.selectedPlace.coordinate.latitude longitude:self.selectedPlace.coordinate.longitude];
    
    CLLocationDistance distanceBetweenEndpoints = [fromLocation.placemark.location distanceFromLocation: toLocationCL];
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocationCoordinate, distanceBetweenEndpoints*1.5, distanceBetweenEndpoints*1.5);
    
    
    NSLog(@"Current location: %@",[fromLocation description]);
    NSLog(@"Destination location: %@",[toLocation description]);
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation,toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey,
                                  MKLaunchOptionsDirectionsModeDefault,MKLaunchOptionsDirectionsModeKey, nil]];
    
    
}

- (IBAction)dismissCurrentViewController:(UIButton *)sender {
}

- (IBAction)showGooglePlacePicker:(UIButton *)sender {
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    GMSPlacePickerViewController *placePicker =
    [[GMSPlacePickerViewController alloc] initWithConfig:config];
    placePicker.delegate = self;
    
    [self presentViewController:placePicker animated:YES completion:^{
    
    
        NSDictionary* userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedPlace,@"googlePlace", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_SELECT_GOOGLE_PLACE_FROM_PLACEPICKER object:nil userInfo: userInfoDict];
        
    
    }];
}



- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];

    [self.googleMapView clear];
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:15.0];
    
    [self.googleMapView setCamera:camera];
    
    GMSMarker* marker = [[GMSMarker alloc] init];
    marker.map = self.googleMapView;
    marker.position = place.coordinate;
    marker.title = place.name;
    
    self.selectedPlace = place;
    
   
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No place selected");
}



@end

