//
//  HostelLocationAnnotation.h
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef HostelLocationAnnotation_h
#define HostelLocationAnnotation_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface SeoulLocationAnnotation : NSObject<MKAnnotation>

typedef NS_ENUM(NSUInteger, SeoulLocationType) {
    NearHostelLocationSportsRecreation = 0,
    NearHostelLocationCoffeeShop,
    NearHostelLocationConvenienceStore,
    NearHostelLocationPharmacyDrugstore,
    NearHostelLocationCosmeticsSkinFacialCare,
    NearHostelLocationPhoneMobileServices,
    NearHostelLocationKoreanBarbecue,
    NearHostelLocationOtherRestaurants,
    NearHostelLocationOtherStores,
    NearHostelLocationPubsBars,
    NearHostelLocationBankATM,
    TouristAttractionStreetMarket,
    TouristAttractionShoppingArea,
    TouristAttractionMuseumLibrary,
    TouristAttractionTempleMonumentRelic,
    TouristAttractionWarMemorial,
    TouristAttractionTower,
    TouristAttractionTheaterMovie,
    LAST_LOCATION_TYPE_INDEX
    
    
};

-(instancetype)initWithDict:(NSDictionary*)configurationDict;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic) SeoulLocationType locationType;
@property (nonatomic) NSString* address;
@property (nonatomic) NSString* imageFilePath;

@end

#endif /* HostelLocationAnnotation_h */
