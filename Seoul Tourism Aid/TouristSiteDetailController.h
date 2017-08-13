//
//  TouristSiteDetailController.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteDetailController_h
#define TouristSiteDetailController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TouristSiteConfiguration.h"

@interface TouristSiteDetailController : UIViewController


@property NSString* titleText;
@property NSString* subtitleText;
@property NSString* descriptionText;
@property UIImage* detailImage;
@property NSString* flickrAuthor;

@property BOOL regionMonitoringStatus;

@property TouristSiteConfiguration* touristSiteConfiguration;



@end

#endif /* TouristSiteDetailController_h */
