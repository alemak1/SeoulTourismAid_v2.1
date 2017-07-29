//
//  AnnotationMapViewController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/3/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef AnnotationMapViewController_h
#define AnnotationMapViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


#import "SeoulLocationAnnotation+HelperMethods.h"

@interface AnnotationMapViewController : UIViewController

@property SeoulLocationAnnotation* annotation;


@end

#endif /* AnnotationMapViewController_h */
