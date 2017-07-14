//
//  GoogleURLGenerator.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GoogleURLGenerator_h
#define GoogleURLGenerator_h

#import "WayPointConfiguration.h"

@interface GoogleURLGenerator : NSObject


+(NSURL*)getURLFromUserLocationToDestination:(WayPointConfiguration*)destination;

+(NSURL*)getURLFromUserLocationtoDestination:(WayPointConfiguration*)destination andWithIntermediaryWaypoints:(NSArray<WayPointConfiguration*>*)wayPoints;



+(NSURL*)getURLFromOrigin:(WayPointConfiguration*)origin toDestination:(WayPointConfiguration*)destination;

+(NSURL*)getURLFromOrigin:(WayPointConfiguration*)origin toDestination:(WayPointConfiguration*)destination andWithIntermediaryWaypoints:(NSArray<WayPointConfiguration*>*)wayPoints;



@end

#endif /* GoogleURLGenerator_h */
