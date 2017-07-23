//
//  ToHostelDirectionsController.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "ToHostelDirectionsController.h"
#import "TransportationMode.h"
#import "UserLocationManager.h"
#import "MKDirectionsRequest+HelperMethods.h"
#import "NSString+HelperMethods.h"
#import "UIViewController+HelperMethods.h"

@interface ToHostelDirectionsController ()





/** Primary MapView, which will show the route to the hostel from the user's starting location **/

@property (weak, nonatomic) IBOutlet MKMapView *routeDisplayMap;



@property (weak,nonatomic) MKRoute* toHostelRoute;

/** Additional labels which indicate the distance and time to the hostel from the user's current location **/

@property (weak, nonatomic) IBOutlet UILabel *distanceToHostelIndicator;
@property (weak, nonatomic) IBOutlet UILabel *travelTimeIndicator;

/** A segmented control allows the user to make directions requests for different transportation types **/

@property (weak, nonatomic) IBOutlet UISegmentedControl *transportationMode;




/** Callback for responding to the user selection of a new transportation type **/

- (IBAction)makeRequestForNewTransportationType:(UISegmentedControl *)sender;


/** NumberFormatters for the distance and type to the hostel are preconfigured, lazily loaded **/

@property (readonly) NSNumberFormatter* travelTimeNumberFormatter;
@property (readonly) NSNumberFormatter* distanceNumberFormatter;
@property (readonly) NSString* selectedTransportationMode;

- (IBAction)dismissCurrentViewController:(UIButton *)sender;


/** Read-only Properties **/

@property (readonly) CLLocationCoordinate2D incheonAirportCoordinate;
@property (readonly) CLLocationCoordinate2D seoulStationCoordinate;


@end

@implementation ToHostelDirectionsController



CLLocation* _userLocation;

-(void)viewWillLayoutSubviews{
    
    _userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    [[self routeDisplayMap] setDelegate:self];
    
    
    
    [self setMapRegionToUserLocation];
    
    if(self.directionsResponse == nil){
        
        [self makeDirectionsRequestsToHostelWithAnyTransportationType];
        
        [self updateHostelDirectionsInterface];
        
    }
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    


}


-(void)viewDidLoad{
    
    
    
}



- (void) setMapRegionToUserLocation{
    CLLocationCoordinate2D fromLocationCoordinate = _userLocation.coordinate;
    
    [self.routeDisplayMap setRegion:MKCoordinateRegionMake(fromLocationCoordinate, MKCoordinateSpanMake(0.01, 0.01))];
    
    
}

/** When the user changes the selected transportation type, a directions request is made with any transportation type option set to user's selected transportation mode; if an error occurs or the server is unavailable, the current viewcontroller is dismissed and the Maps App is launched instead **/

- (IBAction)makeRequestForNewTransportationType:(UISegmentedControl *)sender{
    
    //Remove overlays from previous directions request
    
    NSLog(@"Making route request based on new transportation mode...");
    
    TRANSPORTATION_MODE selected_transportation_mode = (int)[[self transportationMode] selectedSegmentIndex];
    
    MKDirections* directions;
    CLLocationCoordinate2D destinationCoordinate;
    
    switch (self.destinationCategory) {
        case SEOUL_STATION:
            directions = [MKDirectionsRequest getDirectionsToDestinationForTransportMode:selected_transportation_mode andWithDestinationCoordinate:self.seoulStationCoordinate];
            destinationCoordinate = self.seoulStationCoordinate;
            break;
        case INCHEON_AIRPORT:
             directions = [MKDirectionsRequest getDirectionsToDestinationForTransportMode:selected_transportation_mode andWithDestinationCoordinate:self.incheonAirportCoordinate];
            destinationCoordinate = self.incheonAirportCoordinate;
            break;
        default:
            break;
    }
    
    
    
    
    [self.travelTimeIndicator setText:@"Getting travel time..."];
    [self.distanceToHostelIndicator setText:@"Getting distance..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse* directionsResponse, NSError* routingError){
            
            
            if(routingError){
                NSLog(@"Error: failed to directions to hostel from server(from IBAction function)");
                [self dismissViewControllerAnimated:NO completion:^{
                    [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:destinationCoordinate];
                    
                }];
            }
            
            self.directionsResponse = directionsResponse;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateHostelDirectionsInterface];
                
            });
            
        }];
    
    
    });
   

    
}

/**

- (IBAction)viewDirectionsInGoogleMaps:(UIButton *)sender {
    
    CLLocationDegrees latitude = _userLocation.coordinate.latitude;
    CLLocationDegrees longitude = _userLocation.coordinate.longitude;


    [self loadWebsiteWithURLAddress:[NSString stringWithFormat:@"https://www.google.co.kr/maps/dir/%f,%f/@37.5401193,126.9466391",latitude,longitude]];
    
    
}
**/

/** When the view controller loads, a directions request is made with any transportation type option set to TransportTypeAny; if an error occurs or the server is unavailable, the current viewcontroller is dismissed and the Maps App is launched instead **/

-(void) makeDirectionsRequestsToHostelWithAnyTransportationType{
    
    CLLocationCoordinate2D destinationCoordinate;
    
    switch (self.destinationCategory) {
        case INCHEON_AIRPORT:
            destinationCoordinate = self.incheonAirportCoordinate;
            break;
        case SEOUL_STATION:
            destinationCoordinate = self.seoulStationCoordinate;
            break;
        default:
            break;
    }
    
    MKDirectionsRequest* directionsRequest = [MKDirectionsRequest getDirectionsRequestToDestinationCoordinate:destinationCoordinate ForTransportationMode:5];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAny;
    
    MKDirections* toHostelDirections = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [toHostelDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse* directionsResponse, NSError* routingError){
    
        
        if(routingError){
            [self dismissViewControllerAnimated:NO completion:^{
                [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:destinationCoordinate];
                
            }];
        }
        
        self.directionsResponse = directionsResponse;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self updateHostelDirectionsInterface];
            
            
        });
        
    }];
    
}


-(void) updateHostelDirectionsInterface{
    
    MKRoute* route = self.directionsResponse.routes[0];
    
    NSTimeInterval expectedTravelTime = route.expectedTravelTime;
    CLLocationDistance expectedTravelDistance = route.distance;
    
    
    [self showDirections:self.directionsResponse];
    
    [self setTravelDistanceWith:expectedTravelDistance];
    [self setTravelTimeWith:expectedTravelTime];
}


- (void) showDirections:(MKDirectionsResponse*) response{
    
    if([self.routeDisplayMap.overlays count] > 0){
        
        [self.routeDisplayMap removeOverlays:self.routeDisplayMap.overlays];

    }
    
    for(MKRoute* route in response.routes){
        [[self routeDisplayMap] addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

/** TODO: Consider using generics **/

- (void) setTravelTimeWith:(double)travelTime{
    
    NSString* timeString = [NSString timeHHMMSSFormattedStringFromTotalSeconds:(int)travelTime];
    
    [self.travelTimeIndicator setAdjustsFontSizeToFitWidth:YES];
    [self.travelTimeIndicator setMinimumScaleFactor:0.25];
    
    [self.travelTimeIndicator setText:[NSString stringWithFormat:@"%@ Hours:Min:Sec ",timeString]];
}

/** TODO: Consider using generics **/

- (void) setTravelDistanceWith:(double)distance{
    
    NSNumber* distanceNumber = [NSNumber numberWithDouble:distance];
    
    NSString* distanceString = [[self distanceNumberFormatter] stringFromNumber:distanceNumber];;
    
    [[self distanceToHostelIndicator] setText:[NSString stringWithFormat:@"%@ meters", distanceString]];
    
}



-(NSNumberFormatter *)travelTimeNumberFormatter{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    
    return numberFormatter;
}

-(NSNumberFormatter *)distanceNumberFormatter{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    return numberFormatter;
}

-(NSString *)selectedTransportationMode{
    
    TRANSPORTATION_MODE selectedTransportationMode = (int)[[self transportationMode] selectedSegmentIndex];
    
    switch (selectedTransportationMode) {
        case WALK:
            return @"WALKING";
        case TRANSIT:
            return @"TRANSIT";
        case CAR:
            return @"CAR";
        default:
            return @"ANY TRANSIT";
    }
    
}

- (IBAction)dismissCurrentViewController:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewDirectionsToHostelWithMapsApp:(UIButton *)sender {
    
    CLLocationCoordinate2D destinationCoordinate;
    
    switch (self.destinationCategory) {
        case INCHEON_AIRPORT:
            destinationCoordinate = self.incheonAirportCoordinate;
            break;
        case SEOUL_STATION:
            destinationCoordinate = self.seoulStationCoordinate;
            break;
        default:
            break;
    }
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:destinationCoordinate];

}




-(CLLocationCoordinate2D)seoulStationCoordinate{
    return CLLocationCoordinate2DMake(37.5552515,126.9684579);
}

-(CLLocationCoordinate2D)incheonAirportCoordinate{
    return CLLocationCoordinate2DMake(37.460195,126.438507);
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        lineView.strokeColor = [UIColor greenColor];
        
        return lineView;
    }
    
    return nil;
}


@end






/** For generating constraints programmatically:
 
 
 @property MKMapView* routingMap;
 
 @property UILabel* distanceToHostelLabel;
 @property UILabel* travelTimeToHostelLabel;
 
 @property UILabel* distanceToHostel;
 @property UILabel* travelTimeToHostel;
 
 
 //Constraints
 
 typedef NSArray<NSLayoutConstraint*>* LayoutConstraintsArray;
 typedef LayoutConstraintsArray(^ConstraintGenerator)(void);
 
 @property (readonly) LayoutConstraintsArray routingMapConstraints;
 @property (readonly) LayoutConstraintsArray distanceToHostelLabelConstraints;
 @property (readonly) LayoutConstraintsArray distanceToHostelConstraints;
 @property (readonly) LayoutConstraintsArray travelTimeToHostelLabelConstraints;
 @property (readonly) LayoutConstraintsArray travelTimeToHostelConstraints;

 
 //Execute in willLayoutSubview
 
 [self.view setBackgroundColor:[UIColor orangeColor]];
 
 _routingMap = [[MKMapView alloc] init];
 [self.view addSubview:[self routingMap]];
 [self.routingMap setDelegate:self];
 
 [NSLayoutConstraint activateConstraints:[self routingMapConstraints]];


 -(LayoutConstraintsArray)routingMapConstraints{
 
 LayoutConstraintsArray cwchConstraints = [NSArray arrayWithObjects:[
 [[self routingMap] leftAnchor] constraintEqualToAnchor:[self.view leftAnchor] constant:0.00],
 [[[self routingMap] topAnchor] constraintEqualToAnchor:[self.view topAnchor] constant:0.00],
 [[[self routingMap] bottomAnchor] constraintEqualToAnchor:[self.view bottomAnchor] constant:0.00],
 [[[self routingMap] widthAnchor] constraintEqualToAnchor:[self.view widthAnchor] multiplier:0.50],
 nil];
 
 LayoutConstraintsArray cwrhConstraints = [NSArray arrayWithObjects:[
 [[self routingMap] leftAnchor] constraintEqualToAnchor:[self.view leftAnchor] constant:0.00],
 [[[self routingMap] topAnchor] constraintEqualToAnchor:[self.view topAnchor] constant:0.00],
 [[[self routingMap] rightAnchor] constraintEqualToAnchor:[self.view rightAnchor] constant:0.00],
 [[[self routingMap] heightAnchor] constraintEqualToAnchor:[self.view widthAnchor] multiplier:0.50],
 nil];
 
 
 LayoutConstraintsArray rwchConstraints = [NSArray arrayWithObjects:nil, nil];
 
 LayoutConstraintsArray rwrhConstraints = [NSArray arrayWithObjects:nil, nil];
 
 
 
 ConstraintGenerator routingMapConstraintsGenerator = [self getConstraintGeneratorForCWCH: cwchConstraints
 
 andForCWRH:cwrhConstraints
 
 andForRWCH:rwchConstraints
 
 andForRWRH:rwrhConstraints];
 
 return routingMapConstraintsGenerator();
 }
 
 -(LayoutConstraintsArray)distanceToHostelConstraints{
 
 ConstraintGenerator distanceToHostelConstraintsGenerator = [self getConstraintGeneratorForCWCH:[NSArray arrayWithObjects:nil, nil] andForCWRH:[NSArray arrayWithObjects:nil, nil] andForRWCH:[NSArray arrayWithObjects:nil, nil] andForRWRH:[NSArray arrayWithObjects:nil, nil]];
 
 return distanceToHostelConstraintsGenerator();
 }
 
 
 -(LayoutConstraintsArray)distanceToHostelLabelConstraints{
 
 ConstraintGenerator distanceToHostelLabelConstraintsGenerator = [self getConstraintGeneratorForCWCH:[NSArray arrayWithObjects:nil, nil] andForCWRH:[NSArray arrayWithObjects:nil, nil] andForRWCH:[NSArray arrayWithObjects:nil, nil] andForRWRH:[NSArray arrayWithObjects:nil, nil]];
 
 return distanceToHostelLabelConstraintsGenerator();
 }
 
 -(LayoutConstraintsArray)travelTimeToHostelConstraints{
 
 ConstraintGenerator travelTimeToHostelConstraintsGenerator = [self getConstraintGeneratorForCWCH:[NSArray arrayWithObjects:nil, nil] andForCWRH:[NSArray arrayWithObjects:nil, nil] andForRWCH:[NSArray arrayWithObjects:nil, nil] andForRWRH:[NSArray arrayWithObjects:nil, nil]];
 
 return travelTimeToHostelConstraintsGenerator();
 }
 
 -(LayoutConstraintsArray)travelTimeToHostelLabelConstraints{
 
 ConstraintGenerator travelTimeToHostelLabelConstraintsGenerator = [self getConstraintGeneratorForCWCH:[NSArray arrayWithObjects:nil, nil] andForCWRH:[NSArray arrayWithObjects:nil, nil] andForRWCH:[NSArray arrayWithObjects:nil, nil] andForRWRH:[NSArray arrayWithObjects:nil, nil]];
 
 return travelTimeToHostelLabelConstraintsGenerator();
 }
 
 
 
 
 -(ConstraintGenerator) getConstraintGeneratorForCWCH:(LayoutConstraintsArray)cwchConstraintGenerator andForCWRH:(LayoutConstraintsArray)cwrhConstraintGenerator andForRWCH:(LayoutConstraintsArray)rwchConstraintGenerator andForRWRH:(LayoutConstraintsArray)rwrhConstraintGenerator{
 
 return ^{
 
 UITraitCollection* currentTraitCollection = [self traitCollection];
 UIUserInterfaceSizeClass currentHorizontalClass = [currentTraitCollection horizontalSizeClass];
 UIUserInterfaceSizeClass currentVerticalClass = [currentTraitCollection verticalSizeClass];
 
 BOOL CompactWidth_CompactHeight = (currentVerticalClass == UIUserInterfaceSizeClassCompact && currentHorizontalClass == UIUserInterfaceSizeClassCompact);
 
 BOOL CompactWidth_RegularHeight = (currentVerticalClass == UIUserInterfaceSizeClassRegular && currentHorizontalClass == UIUserInterfaceSizeClassCompact);
 
 BOOL RegularWidth_CompactHeight = (currentVerticalClass == UIUserInterfaceSizeClassCompact && currentHorizontalClass == UIUserInterfaceSizeClassRegular);
 
 BOOL RegularWidth_RegularHeight = (currentVerticalClass == UIUserInterfaceSizeClassRegular && currentHorizontalClass == UIUserInterfaceSizeClassRegular);
 
 
 if(CompactWidth_CompactHeight){
 return cwchConstraintGenerator;
 }
 
 if(CompactWidth_RegularHeight){
 return cwrhConstraintGenerator;
 }
 
 if(RegularWidth_CompactHeight){
 return rwchConstraintGenerator;
 }
 
 if(RegularWidth_RegularHeight){
 return rwrhConstraintGenerator;
 
 }
 
 return [[NSArray<NSLayoutConstraint*> alloc] init];
 };
 
 }
 **/


