//
//  HostelAreaContainerController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef HostelAreaContainerController_h
#define HostelAreaContainerController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HostelAreaContainerController : UIViewController

@property MKCoordinateRegion mapRegion;
@property NSString* annotationSourceFilePath;

@end

#endif /* HostelAreaContainerController_h */
