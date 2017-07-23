//
//  BikeRouteMapController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef BikeRouteMapController_h
#define BikeRouteMapController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BikeRouteMapController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *bikeRouteMapView;

@property MKPolyline* bikeRoute;

@property NSString* routeName;

@end

#endif /* BikeRouteMapController_h */
