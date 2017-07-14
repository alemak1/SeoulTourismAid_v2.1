//
//  CLLocation+Constants.m
//  Alphabet Pilot Flies to Seoul
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "CLLocation+Constants.h"
#import <MapKit/MapKit.h>

@implementation CLLocation (Constants)


+(CLLocation*)seoulStationLocation{
    
    return [[CLLocation alloc] initWithLatitude:37.5547125 longitude:126.9685991];
}


+(CLLocationCoordinate2D)seoulStationCoordinate2DLocation{
    
    return CLLocationCoordinate2DMake(37.5547125, 126.9685991);
}



+(CLLocation*)incheonAirportLocation{
    
    return [[CLLocation alloc] initWithLatitude:37.4601908 longitude:126.4231862];
}

+(CLLocationCoordinate2D)incheonAirportCoordinateLocation2D{
    
    return CLLocationCoordinate2DMake(37.4601908, 126.4231862);
    
}

+(CLLocation*)gimpoInternationalAirport{
    
    return [[CLLocation alloc] initWithLatitude:37.5586545 longitude:126.7922852];
}

+(CLLocationCoordinate2D)gimpoInternationalAirportCoordinateLocation2D{
    
    return CLLocationCoordinate2DMake(37.5586545, 126.7922852);

}



@end
