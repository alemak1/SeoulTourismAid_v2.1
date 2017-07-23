//
//  NavigationAidEntryController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef NavigationAidEntryController_h
#define NavigationAidEntryController_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface NavigationAidEntryController : UINavigationController


@property NSArray<NSString*>* polygonOverlayFileSources;
@property MKCoordinateRegion mapCoordinateRegion;
@property NSString* annotationViewImagePath;

/** The navigationRegionName is the query parameter that will be used to filter the records downloaded from CLoudKit servers.  If errors occur during connection with CloudKit servers, the ViewController dataSource can still load a text data from an on-file plist and substitute a generic image for each of the display images corresponding to each annotation **/

@property NSString* navigationRegionName;

/** The filepath for the plist provides back-up data store in case connection with CloudKit servers fail **/

@property NSString* annotationsFileSource;


@end

#endif /* NavigationAidEntryController_h */
