//
//  LocationSearchController.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationSearchController.h"
#import "UserLocationManager.h"
#import "OverlayConfiguration.h"
#import "AnnotationMapViewController.h"

#import "AuthorizationController.h"
#import "Constants.h"
#import "AppDelegate.h"



@interface LocationSearchController () <GMSPlacePickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;

@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;



@property MKMapItem* selectedLocation;


- (IBAction)dismissViewController:(id)sender;

- (IBAction)getDirectionsInMaps:(UIButton *)sender;

- (IBAction)getDirectionsInGoogleMaps:(UIButton *)sender;

- (IBAction)searchLocationsInGoogleMaps:(UIButton *)sender;

@property (readonly) CGRect mapViewFrame;

@end

@implementation LocationSearchController

@synthesize mapViewFrame = _mapViewFrame;

-(void)viewWillLayoutSubviews{
    [self.mainMapView setDelegate:self];

    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];

    [self.mainMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))];


}

-(void)viewWillAppear:(BOOL)animated{
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    

    _mapViewFrame = self.mainMapView.frame;
    
    
    [self.mainMapView setDelegate:self];
    [self.locationSearchBar setDelegate:self];
    
    
    //Configure the map view so that it's coordinate region is centered on GDJ hostel
    
    [self.mainMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))];
    
}

-(void)viewDidLoad{
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    

    if(self.selectedPlace){
        OverlayConfiguration* annotation = [[OverlayConfiguration alloc] initWithCoordinate:self.selectedPlace.coordinate andWithName:self.selectedPlace.name];
        
        [self.mainMapView removeAnnotations:self.mainMapView.annotations];
        [self.mainMapView addAnnotation:annotation];
        
        [self.mainMapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.01, 0.01))];

        
    } else {
        [self.mainMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))];

    }
    
    /** If the user is not currently authorized to call Google APIs, an auhtorization view controller will be shown to obtain user consent. A notification is sent when this authorization controller is dismissed **/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetMapViewWithGooglePlace:) name:DID_SELECT_GOOGLE_PLACE_FROM_PLACEPICKER object:nil];
}


-(void)resetMapViewWithGooglePlace:(NSNotification*)notification{
    
    NSDictionary* userInfo = [notification userInfo];
    
    GMSPlace* googlePlace = userInfo[@"googlePlace"];
    
    self.selectedPlace = googlePlace;
    
    self.selectedLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(googlePlace.coordinate.latitude, googlePlace.coordinate.longitude)]];

    OverlayConfiguration* annotation = [[OverlayConfiguration alloc] initWithCoordinate:self.selectedPlace.coordinate andWithName:self.selectedPlace.name];
    
    [self.mainMapView removeAnnotations:self.mainMapView.annotations];
    [self.mainMapView addAnnotation:annotation];
    
    [self.mainMapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.01, 0.01))];

}

- (IBAction)dismissViewController:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getDirectionsInMaps:(UIButton *)sender {
    
    
    if(!self.selectedLocation){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No Location Selected" message:@"Select a location on the map to get directions in the Apple Maps App" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okayAction];
        
        [self showViewController:alertController sender:nil];
        
        return;
    }
    
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.coordinate];
    
    MKMapItem* fromLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    fromLocation.name = @"Current Location";
    
    CLLocationCoordinate2D fromLocationCoordinate = fromLocation.placemark.coordinate;
    
    MKMapItem* toLocation = self.selectedLocation;

    CLLocationDistance distanceBetweenEndpoints = [fromLocation.placemark.location distanceFromLocation:self.selectedLocation.placemark.location];
    
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

- (IBAction)showGooglePlacePicker:(UIButton *)sender {
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    GMSPlacePickerViewController *placePicker =
    [[GMSPlacePickerViewController alloc] initWithConfig:config];
    placePicker.delegate = self;
    
    [self presentViewController:placePicker animated:YES completion:nil];
}




-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // Create and initialize a search request object.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = [self.locationSearchBar text];
    
    request.region = [self.mainMapView region];
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
    {
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        
        [self.mainMapView removeAnnotations:[self.mainMapView annotations]];
        [self.mainMapView showAnnotations:placemarks animated:NO];
    }
     
     ];
    
    [self.locationSearchBar resignFirstResponder];
}



-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"Selected annotation view: %@", [view description]);
    
    CLLocationDegrees latitude = view.annotation.coordinate.latitude;
    CLLocationDegrees longitude = view.annotation.coordinate.longitude;

    if([view.annotation isKindOfClass:[OverlayConfiguration class]]){
        
        OverlayConfiguration* overlayConfiguration = (OverlayConfiguration*)view.annotation;
        
        self.selectedLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)]];
        
        self.selectedLocation.name = overlayConfiguration.name;
        
        
    } else {
        
        self.selectedLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)]];
        
        self.selectedLocation.name = view.annotation.title;
    }
    
   
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    self.selectedLocation = nil;
}

-(CGRect)mapViewFrame{
    return _mapViewFrame;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showAnnotationDetailView"]){
        
        AnnotationMapViewController* destVC = segue.destinationViewController;
        
        CLLocationCoordinate2D selectedCoordinate = self.selectedLocation.placemark.coordinate;
        
        NSString* locStr = [NSString stringWithFormat:@"{%f,%f}",selectedCoordinate.latitude,selectedCoordinate.longitude];
        
        NSDictionary* configurationDict = @{
                                            
                @"location":locStr,
                @"title":self.selectedLocation.placemark.title,
                @"subtitle":self.selectedLocation.placemark.subtitle,
                @"address":self.selectedLocation.placemark.postalCode,
                @"imagefilepath":@"city3",
                @"type": [NSNumber numberWithInt:0]
                };
        
        destVC.annotation = [[SeoulLocationAnnotation alloc] initWithDict:configurationDict];
        
    }
}



- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    
    [self.mainMapView removeAnnotations:self.mainMapView.annotations];
    
    OverlayConfiguration* placeAnnotation = [[OverlayConfiguration alloc] initWithCoordinate:CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude) andWithName:place.name];
    
    MKPlacemark* selectedPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)];
    
    self.selectedLocation = [[MKMapItem alloc] initWithPlacemark:selectedPlacemark];
    
    [self.mainMapView addAnnotation:placeAnnotation];
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No place selected");
}





-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
