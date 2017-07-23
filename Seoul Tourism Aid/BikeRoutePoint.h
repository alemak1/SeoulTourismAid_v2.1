//
//  BikeRoutePoint.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/4/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef BikeRoutePoint_h
#define BikeRoutePoint_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BikeRoutePoint : NSObject<MKAnnotation>


@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;



@end

#endif /* BikeRoutePoint_h */
