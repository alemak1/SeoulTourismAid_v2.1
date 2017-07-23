//
//  PolygonMapController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef PolygonMapController_h
#define PolygonMapController_h

#import "PolygonMapController.h"
#import "BoundaryOverlay.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PolygonMapController : UIViewController

@property BoundaryOverlay* polygonOverlay;


@end
#endif /* PolygonMapController_h */
