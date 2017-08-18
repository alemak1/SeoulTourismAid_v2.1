//
//  ProductSearchController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/5/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "ProductSearchController.h"
#import "UserLocationManager.h"
#import "NSString+CurrencyHelperMethods.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>
#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>

#import "Constants.h"

@interface ProductSearchController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;

@property (readonly) NSString* googleURLRequestString;
@end

@implementation ProductSearchController

@synthesize assortedProductCategory = _assortedProductCategory;

-(void)viewWillLayoutSubviews{
    
    [self.mainMapView setDelegate:self];
    
}

-(void)viewDidLoad{
    
    [self setMapRegionBasedOnCurrentUserLocation];
    
    if(!self.shouldPerformGoogleSearch){
        [self performGenericSearch];
    } else {
        [self performSearchViaGooglePlaces];
    }

}


-(void)setMapRegionBasedOnCurrentUserLocation{
    
    CLLocation* currentLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    CLLocationCoordinate2D centerCoordinate = currentLocation.coordinate;

    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpanMake(0.0001, 0.0001));
    
    
    [self.mainMapView setRegion:region];
    
}

-(void)performSearchViaGooglePlaces{
    
    [self makeRequestToGooglePlacesAPI];
    
}

-(void)performGenericSearch{
    /** The generic search will perform a search near the user's current location based on the keywords associated with a product category **/
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    

    request.naturalLanguageQuery = [NSString getSearchQueryAssociatedWithAssortedProductCategory:self.assortedProductCategory];
    
    CLLocation* currentLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    CLLocationCoordinate2D centerCoordinate = currentLocation.coordinate;
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpanMake(0.001, 0.001));
    
    request.region = region;
    
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
     }];

}





-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:view.annotation.coordinate andWithPlacemarkName:view.annotation.title];
    
    
}

-(void)setAssortedProductCategory:(AssortedProductCategory)assortedProductCategory{
    
    _assortedProductCategory = assortedProductCategory;
    
}


-(AssortedProductCategory)assortedProductCategory{
    return _assortedProductCategory;
}


-(NSString *)googleURLRequestString{
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager]getLastUpdatedUserLocation];
    
    CLLocationDegrees latCoord = userLocation.coordinate.latitude;
    CLLocationDegrees longCoord = userLocation.coordinate.longitude;
    NSInteger searchRadius = 50;
    
    NSString* placeType = [NSString getSearchQueryAssociatedWithAssortedProductCategory:self.assortedProductCategory];
    
    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?type=%@&location=%f,%f&radius=%ld&language=%@&key=%@",placeType,latCoord,longCoord,searchRadius,@"en",GOOGLE_API_KEY];
    
    return urlString;
}

-(void)makeRequestToGooglePlacesAPI{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    
    NSLog(@"The google URL request string is: %@",self.googleURLRequestString);
    
    NSURL* url = [NSURL URLWithString:self.googleURLRequestString];
    
    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    /** Set the HTTP Method as POST **/
    
    [request setHTTPMethod:@"GET"];
    
    
    /** Initialize fetcher object with an NSURL request **/
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Checks for an error.
        
        
        if(!data){
            NSLog(@"No data returned from search");
            return;
        }
     
        
        if(data){
            
            // Parses the JSON response.
            NSError *jsonError = nil;
            
            NSDictionary* jsonDict =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            // JSON error.
            if (jsonError) {
                NSLog(@"JSON decoding error %@", jsonError);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Perform any necessary updates on the main thread
                
            });
            
            // Success response!
            NSLog(@"Success: %@", jsonDict);
            
        }
       
        
    }];

}

@end
/**
 
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
 
 
 
 **/

