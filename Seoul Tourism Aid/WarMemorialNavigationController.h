//
//  WarMemorialNavigationController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/4/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WarMemorialNavigationController_h
#define WarMemorialNavigationController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WarMemorialAnnotation.h"

@interface WarMemorialNavigationController : UIViewController


@property NSString* annotationsFileSource;
@property NSArray<NSString*>* polygonOverlayFileSources;
@property MKCoordinateRegion mapCoordinateRegion;
@property NSString* annotationViewImagePath;
@property NSString* navigationRegionName;

@property NSMutableArray<WarMemorialAnnotation*>* annotationStore;

/** Operations to be performed on the main queue **/

-(void)updateUserInterfaceUponDownloadCompletion;
-(void)updateProgressViewWithProgress:(CGFloat)newProgress;
-(void)hideAnnotationDisplayElements;
-(void)hideProgressViewElements;

/** Asynchronous, background operations **/

-(void)loadWarMemorialAnnotationsArrayFromPlist;
-(void) loadAnnotations;
-(void)initializeProgressView;

@end

#endif /* WarMemorialNavigationController_h */
