//
//  ToHostelDirectionsController.h
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ToHostelDirectionsController_h
#define ToHostelDirectionsController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DestinationCategory.h"

@interface ToHostelDirectionsController : UIViewController<MKMapViewDelegate>


@property MKDirectionsResponse* directionsResponse;

/** Outlets for Labels **/

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property DestinationCategory destinationCategory;

@end

#endif /* ToHostelDirectionsController_h */
