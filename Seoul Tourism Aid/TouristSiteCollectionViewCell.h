//
//  TouristSiteCollectionViewCell.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteCollectionViewCell_h
#define TouristSiteCollectionViewCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TouristSiteCollectionViewCell.h"
#import "TouristSiteConfiguration.h"

/** For the Seoul Tourism Section, a CollectionView Cell will contain an image and title corresponding to the appropriate tourist site; it will also display the user's current distance to and traveling time to the said tourist stie, which are comptued using the user's location; in addition, each cell contains two buttons, one transitioning to a map route to the location, and the other transition to detail view about the tourist site; some details about whether the tourist site is currently open or close, or time to closing can be updated based on the current time; **/

/** 
    TODO:   Create a manager object to get location updates and dynamically update a collection of MKAnnotation objects based on the user's current location; the manager can be initialized from a .plist file contained the names, image name paths, and other detail information for the tourist site in question
 **/


@interface TouristSiteCollectionViewCell : UICollectionViewCell


@property UIImage* siteImage;
@property NSString* titleText;
@property NSString* isOpenStatusText;
@property NSString* distanceToSiteText;

-(void)configureIsOpenStatusLabel;

@property TouristSiteConfiguration* touristSiteConfigurationObject;



@end

#endif /* TouristSiteCollectionViewCell_h */
