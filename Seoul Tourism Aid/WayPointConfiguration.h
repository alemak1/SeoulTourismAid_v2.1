//
//  WaypointConfiguration.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WayPointConfiguration_h
#define WayPointConfiguration_h


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface WayPointConfiguration : NSObject

@property NSString* name;
@property CLLocation* location;
@property NSString* placeID;
@property NSString* address;

-(instancetype)initWithPlaceID:(NSString*)placeID andWithName:(NSString*)name;
-(instancetype)initWithAddress:(NSString*)address andWithName:(NSString*)name;
-(instancetype)initWithLocatino:(CLLocation*)location andWithName:(NSString*)name;

-(NSString*)getFormattedQueryParameter;

-(NSURL*)getDirectionsRequestURLFromUserLocationOrigin;

@end

#endif /* WaypointConfiguration_h */
