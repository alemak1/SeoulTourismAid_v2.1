//
//  GooglePlace.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GooglePlace_h
#define GooglePlace_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OverlayConfiguration.h"

@import GooglePlaces;

@interface GooglePlace: NSObject<MKOverlay>


typedef enum USER_DEFINED_GOOGLE_PLACE_CATEGORY{
    Museum = 0,
    Temple = 1,
    Monument_HistoricalCulturalSite = 2,
    ShoppingArea = 3,
    Outdoor_NaturalSite = 6,
    Park_RecreationSite = 7,
    SeoulTower = 10,
    YangguCounty = 11,
    Other = 9
}USER_DEFINED_GOOGLE_PLACE_CATEGORY;


-(instancetype _Nullable )initWithGMSPlace:(NSString*_Nullable)placeID andWithUserDefinedCategory:(NSNumber*_Nullable)userDefinedCategory andWithBatchCompletionHandler:(void(^_Nullable)(void))batchCompletionHandler andCompletionHandler:(void(^_Nullable)(void))completion;

-(void)loadGooglePlaceDetailData;
-(void)showDebugSummary;

@property NSString* _Nullable placeID;
@property NSURL* _Nullable website;
@property float rating;
@property NSString* _Nullable name;
@property NSString* _Nullable formattedAddress;
@property NSString* _Nullable phoneNumber;
@property NSArray<NSString*>* _Nullable types;
@property GMSPlacesOpenNowStatus openNowStatus;


@property (nonatomic, readonly) NSString* _Nullable isOpenNowText;
@property (nonatomic, readonly) NSString* _Nullable priceLevelText;
@property (nonatomic, readonly) UIImage* _Nullable firstImage;

/** MKAnnotation Properties **/

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (readonly) MKCoordinateRegion coordinateRegion;
@property (nonatomic, readonly) CLLocation* location;

@end



#endif /* GooglePlace_h */
