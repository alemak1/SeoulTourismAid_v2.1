//
//  TouristSiteConfiguration.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#ifndef TouristSiteConfiguration_h
#define TouristSiteConfiguration_h

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>

#import "OverlayConfiguration.h"
#import "OperatingHours.h"
#import "DayOfWeek.h"

@import GooglePlaces;


/** Tourist Site Configuration objects encapsulate detailed information about tourist sites; they can be initialized from CKRecords, GMSPlaces, special configuration dictionaries, and plist files **/

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


/** User-Initialized Properties **/

@property NSString* googlePlaceID;
@property NSString* siteDescription;

@property CGFloat generalAdmissionFee;
@property NSArray<NSString*>* detailedPriceInfoArray;
@property NSArray<NSString*>* detailedParkingFeeInfoArray;

@property TouristSiteCategory touristSiteCategory;

@property OperatingHours* operatingHours;
@property NSArray<NSString*>* detailedOperatingHoursInfoArray;


@property NSString* physicalAddress;
@property NSString* webAddress;

@property NSString* largeImage;
@property UIImage* calloutImage;
@property NSArray<UIImage*>* accessoryImages;


/** Computed properties determined dynamically based on local time and user location info **/

@property (readonly) BOOL isOpen;

@property (readonly) NSString* timeUntilClosingString;
@property (readonly) NSString* timeUntilOpeningString;

@property (readonly) NSTimeInterval timeUntilClosing;
@property (readonly) NSTimeInterval timeUntilOpening;

@property (readonly) NSString* distanceFromUserString;
@property (readonly) NSString* travelingTimeFromUserLocationString;

@property (readonly) CGFloat distanceFromUser;
@property (readonly) CGFloat travelingTimeFromUserLocation;


/** Computed properties determined from Google Places API (based on Google PlaceID **/

/** Initializers **/

-(instancetype)initWithGMSPlace:(GMSPlace *)place;
-(instancetype)initWithCKRecord:(CKRecord*)record;

-(instancetype)initWithConfigurationDict:(NSDictionary*)configurationDictionary;
- (instancetype)initWithFilename:(NSString *)filename;

-(NSString*)debugDescriptionA;
-(NSString*)debugDescriptionB;

-(CLRegion*) getRegionFromTouristConfiguration;


@end

#endif /* TouristSiteConfiguration_h */
