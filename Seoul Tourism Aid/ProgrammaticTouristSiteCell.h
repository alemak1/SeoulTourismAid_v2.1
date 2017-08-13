//
//  ProgrammaticTouristSiteCell.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/11/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ProgrammaticTouristSiteCell_h
#define ProgrammaticTouristSiteCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TouristSiteConfiguration.h"

@interface ProgrammaticTouristSiteCell : UICollectionViewCell

@property UIImage* siteImage;
@property NSString* titleText;
@property NSString* isOpenStatusText;
@property NSString* distanceToSiteText;


@property TouristSiteConfiguration* touristSiteConfigurationObject;


@end

#endif /* ProgrammaticTouristSiteCell_h */
