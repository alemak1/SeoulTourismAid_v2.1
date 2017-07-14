//
//  CLLocation+Constants.h
//  Alphabet Pilot Flies to Seoul
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Constants)


+(CLLocation*)seoulStationLocation;
+(CLLocationCoordinate2D)seoulStationCoordinate2DLocation;


+(CLLocation*)incheonAirportLocation;
+(CLLocationCoordinate2D)incheonAirportCoordinateLocation2D;


+(CLLocation*)gimpoInternationalAirport;
+(CLLocationCoordinate2D)gimpoInternationalAirportCoordinateLocation2D;


@end
