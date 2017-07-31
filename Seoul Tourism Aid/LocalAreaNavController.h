//
//  HostelAreaNavigationController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef HostelAreaNavigationController_h
#define HostelAreaNavigationController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocalAreaNavController : UINavigationController

@property MKCoordinateRegion mapViewingRegion;
@property NSString* annotationSourceFileName;


@property NSMutableArray* selectedOptions;

@end

#endif /* HostelAreaNavigationController_h */
