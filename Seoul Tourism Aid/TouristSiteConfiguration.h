//
//  TouristSiteConfiguration.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteConfiguration_h
#define TouristSiteConfiguration_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "OverlayConfiguration.h"
//#import "DayOfWeek.h"

/**
 
@interface TouristSiteConfiguration : OverlayConfiguration


typedef enum TouristSiteCategory{
    MUSUEM = 0,
    TEMPLE,
    MONUMENT_OR_WAR_MEMORIAL,
    SHOPPING_AREA,
    NIGHT_MARKET,
    RADIO_TOWER,
    NATURAL_SITE,
    PARK,
    SPORT_STADIUM,
    OTHER,
    SEOUL_TOWER,
    YANGGU_COUNTY,
    KOREAN_WAR_MEMORIAL,
    GWANGHUAMUN,
    TOURIST_SITE_CATEGORY_END_INDEX
}TouristSiteCategory;


 **/

/** User-Initialized Properties

@property NSString* title;
@property NSString* siteDescription;
@property CGFloat admissionFee;

@property int* daysClosed;
@property TouristSiteCategory touristSiteCategory;

@property NSNumber* openingTime;
@property NSNumber* closingTime;
@property NSString* physicalAddress;
@property NSString* webAddress;
@property NSString* specialNote;

@property NSString* imagePath;

 **/

/** Computed properties determined dynamically based on local time and user location info

@property (readonly) BOOL isOpen;

@property (readonly) NSString* timeUntilClosingString;
@property (readonly) NSString* timeUntilOpeningString;

@property (readonly) NSTimeInterval timeUntilClosing;
@property (readonly) NSTimeInterval timeUntilOpening;

@property (readonly) NSString* distanceFromUserString;
@property (readonly) NSString* travelingTimeFromUserLocationString;

@property (readonly) CGFloat distanceFromUser;
@property (readonly) CGFloat travelingTimeFromUserLocation;
@property (readonly) int numberOfDaysClosed;

 **/

/** Initializers

-(instancetype)initWithConfigurationDict:(NSDictionary*)configurationDictionary;
- (instancetype)initWithFilename:(NSString *)filename;

-(NSString*)debugDescriptionA;
-(NSString*)debugDescriptionB;

-(CLRegion*) getRegionFromTouristConfiguration;


@end

#endif /* TouristSiteConfiguration_h */


**/
