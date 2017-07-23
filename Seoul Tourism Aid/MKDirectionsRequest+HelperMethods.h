//
//  MKDirectionsRequest+HelperMethods.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TransportationMode.h"

@interface MKDirectionsRequest (HelperMethods)


/** General static methods for obtain directions request, directions to a generic location for a given transportatino mode **/

+(MKDirectionsRequest*)getDirectionsRequestToDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate ForTransportationMode:(TRANSPORTATION_MODE)transportationMode;

+(MKDirectionsRequest*)getDirectionsRequestToDestinationWithCoordinate:(CLLocationCoordinate2D)destinationLocationCoordinate  andWithTransportationMode :(TRANSPORTATION_MODE)transportationMode;

+(MKDirections*)getDirectionsToDestinationForTransportMode:(TRANSPORTATION_MODE)transportationMode andWithDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate;

+(MKDirectionsResponse*)getDirectionsResponseForSeoulStationDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode;

+(MKDirectionsResponse*)getDirectionsResponseForIncheonInternationalAirportDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode;


/** Specific, utility methods for getting directions request and directions to GDJ Hostel **/

+(MKDirectionsRequest*)getDirectionsRequestToHostelForTransportationMode:(TRANSPORTATION_MODE)transportationMode;


+(MKDirections*) getDirectionsToHostelForTransportationMode:(TRANSPORTATION_MODE)transportationMode;


+(void)handleDirectionsResponseForHostelDirectionsRequest:(void(^)(MKDirectionsResponse* routeResponse, NSError* routeError))handleDirectionsResponse forTransportationMode:(TRANSPORTATION_MODE)transportationMode;

+(MKDirectionsResponse*)getDirectionsResponseForHostelDirectionsRequestForTransportationMode:(TRANSPORTATION_MODE)transportationMode;




@end
