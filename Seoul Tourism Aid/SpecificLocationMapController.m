//
//  SpecificLocationMapController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "SpecificLocationMapController.h"

#import "UserLocationManager.h"
#import "CLLocation+Constants.h"
#import "Constants.h"

@import GoogleMaps;

@interface SpecificLocationMapController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIView *googleMapView;

@property (readonly) NSDictionary* placeIDInfo;

@end



@implementation SpecificLocationMapController

NSDictionary* _placeIDInfo;


-(void)viewWillLayoutSubviews{

    /** Start getting user location information **/
    
    [[UserLocationManager sharedLocationManager] requestAuthorizationAndStartUpdates];

    CLLocation* lastUpdatedLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSLog(@"Last updated location is: Lat%f,Long%f",lastUpdatedLocation.coordinate.latitude,lastUpdatedLocation.coordinate.longitude);
    
    /** Load plist data with PlaceID information for a number of key tourist sites **/
   
}


-(void)viewDidLoad{
    
    
    
    CLLocation* airportLocation = [CLLocation incheonAirportLocation];
    
    CLLocationDegrees latitude = [airportLocation coordinate].latitude;
    CLLocationDegrees longitude = [airportLocation coordinate].longitude;
    
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:12.0];
    
  
    GMSMapView* googleMapView = [GMSMapView mapWithFrame:self.googleMapView.frame camera:camera];
    [googleMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:googleMapView];

    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:[[googleMapView topAnchor] constraintEqualToAnchor:[self.googleMapView topAnchor]],
        [[googleMapView leftAnchor] constraintEqualToAnchor:[self.googleMapView leftAnchor]],
        [[googleMapView rightAnchor] constraintEqualToAnchor:[self.googleMapView rightAnchor]],
        [[googleMapView bottomAnchor] constraintEqualToAnchor:[self.googleMapView bottomAnchor]],
        nil]];

    
    [self.locationLabel setText:@"Incheon Airport"];
    
    GMSMarker* marker = [GMSMarker markerWithPosition:airportLocation.coordinate];
    marker.title = @"Incheon International Airport";
    marker.map = googleMapView;
    marker.icon = [UIImage imageNamed:@"airportB"];
    
    
    
    __block CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    if(userLocation == nil){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6.00*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",[[self getURL] absoluteString]);
            NSLog(@"%@",[[self getURLWithPlaceIDForDestinationKey:@"World Cup Stadium"] absoluteString]);
            
            NSLog(@"The user location after 6.00 secondss is lat: %f, long: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        });
        
    }

    [[[NSURLSession sharedSession] dataTaskWithURL:[self getURLWithPlaceIDForDestinationKey:@"Itaewon"] completionHandler:^(NSData* data, NSURLResponse* response, NSError*error){
        
        if(error){
            
            NSLog(@"Error: failed to donwload JSON data with error %@",[error localizedDescription]);
        }
        
        
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            
            NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)response;
            
            if(urlResponse.statusCode != 200){
                NSLog(@"Error: received bad HTTP response; the requested API endpoint is not available, status code: %d",urlResponse.statusCode);
            }
        }
        
        
        if(!data){
            NSLog(@"JSON data unavailable");
        }
        
        
        NSError* jsonError;
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSLog(@"JSON Dict %@",[jsonDict description]);
        
        NSString* errorMessage = jsonDict[@"error_message"];
        NSString* status = jsonDict[@"status"];
        
        if([status isEqualToString:@"REQUEST_DENIED"]){
            NSLog(@"Your API requesst has been denied: %@",errorMessage);
        }
        
    }] resume];
    
}


-(NSURL*)getURL{
    
    /** Get the User Location from CoreLocation services to pass in the user's latitude and longitude values for the required query parameter 'origin' in the Google Maps URL String **/
    
    CLLocation* userLocation =  [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSString* originString = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,nil];
    
    
    /** Get the Destination Location from defined global constants for key locations **/
    
    CLLocation* destinationLocation = [CLLocation incheonAirportLocation];

    NSString* destinationString =[NSString stringWithFormat:@"%f,%f",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&api=%@",originString,destinationString,GOOGLE_API_KEY];
    
    
    return [NSURL URLWithString:urlString];
}


-(NSURL*)getURLWithPlaceIDForDestinationKey:(NSString*)destinationKey{
    
    /** Get the User Location from CoreLocation services to pass in the user's latitude and longitude values for the required query parameter 'origin' in the Google Maps URL String **/
    
    CLLocation* userLocation =  [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSString* originString = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,nil];
    
    
    /** Get the Destination Location from defined global constants for key locations **/
    
    NSString* destinationPlaceID = [self.placeIDInfo valueForKey:destinationKey];

    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=place_id:%@&key=%@",originString,destinationPlaceID,GOOGLE_API_KEY];
    
    return [NSURL URLWithString:urlString];
}

-(NSDictionary *)placeIDInfo{
    
    if(_placeIDInfo == nil){
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"PlaceIDInformation" ofType:@"plist"];
    
        _placeIDInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    
    }
    
    return _placeIDInfo;
}




@end
