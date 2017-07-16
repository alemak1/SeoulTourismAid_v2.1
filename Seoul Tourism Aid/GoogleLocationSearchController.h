//
//  GoogleLocationSearchController.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GoogleLocationSearchController_h
#define GoogleLocationSearchController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import GooglePlaces;
@import GoogleMaps;
@import GooglePlacePicker;



@interface GoogleLocationSearchController : UIViewController

@property GMSPlace* selectedPlace;


@end


#endif /* GoogleLocationSearchController_h */
