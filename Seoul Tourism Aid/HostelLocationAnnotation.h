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
    NearHostelLocationCoffeeShop, //1
    NearHostelLocationConvenienceStore, //2
    NearHostelLocationPharmacyDrugstore, //3
    NearHostelLocationCosmeticsSkinFacialCare, //4
    NearHostelLocationPhoneMobileServices, //5
    NearHostelLocationKoreanBarbecue, //6
    NearHostelLocationOtherRestaurants, //7
    NearHostelLocationOtherStores, //8
    NearHostelLocationPubsBars, //9
    NearHostelLocationBankATM, //10
    TouristAttractionStreetMarket, //11
    TouristAttractionShoppingArea, //12
    TouristAttractionMuseumLibrary, //13
    TouristAttractionTempleMonumentRelic, //14
    TouristAttractionWarMemorial, //15
    TouristAttractionTower, //16
    TouristAttractionTheaterMovie, //17
    TouristAttractionTheaterHotelLodging, //18
    TouristAttractionSaunaMassage, //19
    TouristAttractionClothingStore,//20
    TouristAttractionHospitalClinic,//21
    TouristAttractionPoliceFireStation,//22
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
