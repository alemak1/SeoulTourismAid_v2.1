//
//  MKDirectionsRequest+HelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "MKDirectionsRequest+HelperMethods.h"
#import "UserLocationManager.h"

@implementation MKDirectionsRequest (HelperMethods)


+(MKDirectionsRequest*)getDirectionsRequestToDestinationWithCoordinate:(CLLocationCoordinate2D)destinationLocationCoordinate  andWithTransportationMode :(TRANSPORTATION_MODE)transportationMode{
    
    MKDirectionsRequest* routeRequest = [[MKDirectionsRequest alloc]init];
    
    
    switch (transportationMode) {
        case WALK:
            routeRequest.transportType = MKDirectionsTransportTypeWalking;
            break;
        case TRANSIT:
            routeRequest.transportType = MKDirectionsTransportTypeTransit;
            break;
        case CAR:
            routeRequest.transportType = MKDirectionsTransportTypeAutomobile;
            break;
        default:
            routeRequest.transportType = MKDirectionsTransportTypeAny;
            break;
    }
    
    /** Convert the user location into an MKMapItem **/
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.coordinate];
    
    MKMapItem* currentLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    currentLocation.name = @"Current Location";
    
    //Convert the hostel location into an MKMapItem
    
    
    MKPlacemark* destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationLocationCoordinate];
    
    MKMapItem* destinationLocation = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    //Set source and destination for the route requests
    
    [routeRequest setSource:currentLocation];
    
    [routeRequest setDestination:destinationLocation];
    
   
    
    return routeRequest;
}




+(MKDirectionsRequest*)getDirectionsRequestToHostelForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    MKDirectionsRequest* routeRequest = [[MKDirectionsRequest alloc]init];
    

    switch (transportationMode) {
        case WALK:
            routeRequest.transportType = MKDirectionsTransportTypeWalking;
            break;
        case TRANSIT:
            routeRequest.transportType = MKDirectionsTransportTypeTransit;
            break;
        case CAR:
            routeRequest.transportType = MKDirectionsTransportTypeAutomobile;
            break;
        default:
            routeRequest.transportType = MKDirectionsTransportTypeAny;
            break;
    }
    
    /** Convert the user location into an MKMapItem **/
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.coordinate];
    
    MKMapItem* currentLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    currentLocation.name = @"Current Location";
    
    //Convert the hostel location into an MKMapItem
    
    CLLocationCoordinate2D hostelLocationCoordinate = CLLocationCoordinate2DMake(37.541593, 126.952866);
    
    MKPlacemark* hostelPlacemark = [[MKPlacemark alloc] initWithCoordinate:hostelLocationCoordinate];
    
    MKMapItem* hostelLocation = [[MKMapItem alloc] initWithPlacemark:hostelPlacemark];
    
    //Set source and destination for the route requests
    
    [routeRequest setSource:currentLocation];
    
    [routeRequest setDestination:hostelLocation];
    
    //Set source and destination for the route requests
    
    [routeRequest setSource:currentLocation];
    
    [routeRequest setDestination:hostelLocation];
    
    return routeRequest;
}


+(MKDirectionsRequest*)getDirectionsRequestToDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate ForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    MKDirectionsRequest* routeRequest = [[MKDirectionsRequest alloc]init];
    
    
    switch (transportationMode) {
        case WALK:
            routeRequest.transportType = MKDirectionsTransportTypeWalking;
            break;
        case TRANSIT:
            routeRequest.transportType = MKDirectionsTransportTypeTransit;
            break;
        case CAR:
            routeRequest.transportType = MKDirectionsTransportTypeAutomobile;
            break;
        default:
            routeRequest.transportType = MKDirectionsTransportTypeAny;
            break;
    }
    
    /** Convert the user location into an MKMapItem **/
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.coordinate];
    
    MKMapItem* currentLocation = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    currentLocation.name = @"Current Location";
    
    //Convert the hostel location into an MKMapItem
    
    
    MKPlacemark* destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate];
    
    MKMapItem* destinationLocation = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    //Set source and destination for the route requests
    
    [routeRequest setSource:currentLocation];
    
    [routeRequest setDestination:destinationLocation];
    
    
    return routeRequest;
}



+(MKDirections*) getDirectionsToHostelForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    MKDirectionsRequest* routeRequest = [MKDirectionsRequest getDirectionsRequestToHostelForTransportationMode:transportationMode];
    
    
    MKDirections* routeDirections = [[MKDirections alloc] initWithRequest:routeRequest];
    
    return routeDirections;
}


+(MKDirections*)getDirectionsToDestinationForTransportMode:(TRANSPORTATION_MODE)transportationMode andWithDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate{
    
    MKDirectionsRequest* routeRequest = [MKDirectionsRequest getDirectionsRequestToDestinationWithCoordinate:destinationCoordinate andWithTransportationMode:transportationMode];
    
    MKDirections* routeDirections = [[MKDirections alloc] initWithRequest:routeRequest];
    
    return routeDirections;
    
}



+(void)handleDirectionsResponseForHostelDirectionsRequest:(void(^)(MKDirectionsResponse* routeResponse, NSError* routeError))handleDirectionsResponse forTransportationMode:(TRANSPORTATION_MODE)transportationMode{

    MKDirections* toHostelDirections = [MKDirectionsRequest getDirectionsToHostelForTransportationMode:transportationMode];
    
    [toHostelDirections calculateDirectionsWithCompletionHandler:handleDirectionsResponse];

}

+(MKDirectionsResponse*)getDirectionsResponseForHostelDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    
    __block MKDirectionsResponse* toHostelRouteResponse;
    
    MKDirections* toHostelDirections = [MKDirectionsRequest getDirectionsToHostelForTransportationMode:transportationMode];
    
    [toHostelDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse* routeResponse, NSError* routeError){
        
        if(routeError){
            toHostelRouteResponse = nil;
        } else {
            
            /** Store the direction response in stored property registered for KVO**/
            
            toHostelRouteResponse = routeResponse;
            
            
        }
        
    }];
    
    return toHostelRouteResponse;

}



+(MKDirectionsResponse*)getDirectionsResponseForSeoulStationDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    
    __block MKDirectionsResponse* toSeoulStationDirectionsRespone;
    
    MKDirections* toSeoulStationDirections = [MKDirectionsRequest getDirectionsToDestinationForTransportMode:transportationMode andWithDestinationCoordinate:CLLocationCoordinate2DMake(37.5552515,126.9684579)];
    
    
    [toSeoulStationDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse* routeResponse, NSError* routeError){
        
        if(routeError){
            toSeoulStationDirectionsRespone = nil;
        } else {
            
            /** Store the direction response in stored property registered for KVO**/
            
            toSeoulStationDirectionsRespone = routeResponse;
            
            
        }
        
    }];
    
    return toSeoulStationDirectionsRespone;
    
}

+(MKDirectionsResponse*)getDirectionsResponseForIncheonInternationalAirportDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode{
    
    
    __block MKDirectionsResponse* toIncheonInternationalAirportResponse;
    
    MKDirections* toAirportDirections = [MKDirectionsRequest getDirectionsToDestinationForTransportMode:transportationMode andWithDestinationCoordinate:CLLocationCoordinate2DMake(37.460195,126.438507)];
    
    [toAirportDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse* routeResponse, NSError* routeError){
        
        if(routeError){
            toIncheonInternationalAirportResponse = nil;
        } else {
            
            /** Store the direction response in stored property registered for KVO**/
            
            toIncheonInternationalAirportResponse = routeResponse;
            
            
        }
        
    }];
    
    return toIncheonInternationalAirportResponse;
    
}




@end
