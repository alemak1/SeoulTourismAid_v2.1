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

@interface GoogleLocationSearchController () <GMSPlacePickerViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *googleMapViewContainer;


@property GMSMapView* googleMapView;

- (IBAction)searchForLocationsInGoogleMaps:(UIButton *)sender;

- (IBAction)searchForLocationsInAppleMaps:(UIButton *)sender;

- (IBAction)dismissCurrentViewController:(UIButton *)sender;

@end

@implementation GoogleLocationSearchController


-(void)viewDidLoad{
    
    
    GMSCameraPosition* camera;
    GMSMarker* marker;
    
    if(self.selectedPlace == nil){
        
        
        CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
        
        camera = [GMSCameraPosition cameraWithTarget:userLocation.coordinate zoom:12.0];
        
        marker = [GMSMarker markerWithPosition:userLocation.coordinate];
    } else {
        
        camera = [GMSCameraPosition cameraWithTarget:self.selectedPlace.coordinate zoom:12.0];
        
        marker = [GMSMarker markerWithPosition:self.selectedPlace.coordinate];
    }
  
    
    self.googleMapView = [GMSMapView mapWithFrame:self.googleMapViewContainer.frame camera:camera];
    
    [self.googleMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.googleMapView];
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:[[self.googleMapView topAnchor] constraintEqualToAnchor:[self.googleMapViewContainer topAnchor]],
        [[self.googleMapView leftAnchor] constraintEqualToAnchor:[self.googleMapViewContainer leftAnchor]],
        [[self.googleMapView rightAnchor] constraintEqualToAnchor:[self.googleMapViewContainer rightAnchor]],
        [[self.googleMapView bottomAnchor] constraintEqualToAnchor:[self.googleMapViewContainer bottomAnchor]],
        nil]];
    
    
    
    marker.title = self.selectedPlace != nil ? self.selectedPlace.name : @"Current Location";
    marker.map = self.googleMapView;
    

    
    
}




- (IBAction)searchForLocationsInGoogleMaps:(UIButton *)sender {
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    GMSPlacePickerViewController *placePicker =
    [[GMSPlacePickerViewController alloc] initWithConfig:config];
    placePicker.delegate = self;
    
    [self presentViewController:placePicker animated:YES completion:nil];
}

- (IBAction)searchForLocationsInAppleMaps:(UIButton *)sender {
}

- (IBAction)dismissCurrentViewController:(UIButton *)sender {
}



- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];

    [self.googleMapView clear];
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:12.0];
    
    [self.googleMapView setCamera:camera];
    
    GMSMarker* marker = [[GMSMarker alloc] init];
    marker.map = self.googleMapView;
    marker.position = place.coordinate;
    marker.title = place.name;
    
    /**
     [self.mainMapView addAnnotation:pickedPlace];
     
     [self.mainMapView setRegion:MKCoordinateRegionMake(place.coordinate, MKCoordinateSpanMake(0.001, 0.001))];
     **/
    
    
    
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

