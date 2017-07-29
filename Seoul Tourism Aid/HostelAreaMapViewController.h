//
//  HostelAreaMapViewController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef HostelAreaMapViewController_h
#define HostelAreaMapViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "OverlayConfiguration.h"

@interface HostelAreaMapViewController : UIViewController<MKMapViewDelegate>


@property MKCoordinateRegion mapRegion;
@property NSString* annotationSourceFilePath;


@end

#endif /* HostelAreaMapViewController_h */
