//
//  SeoulLocationAnnotation+HelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "SeoulLocationAnnotation+HelperMethods.h"

@implementation SeoulLocationAnnotation (HelperMethods)



+(NSString*) getTitleForLocationType:(SeoulLocationType)locationType{
    
    switch (locationType) {
        case NearHostelLocationBankATM:
            return @"Banks and ATMs";
        case NearHostelLocationPubsBars:
            return @"Pubs and Bars";
        case NearHostelLocationCoffeeShop:
            return @"Coffee Shops";
        case NearHostelLocationOtherStores:
            return @"Other Types of Stores";
        case NearHostelLocationKoreanBarbecue:
            return @"Korean Barbecue";
        case NearHostelLocationConvenienceStore:
            return @"Convenience Stores";
        case NearHostelLocationOtherRestaurants:
            return @"Other Kinds of Restaurants";
        case NearHostelLocationSportsRecreation:
            return @"Sports and Recreation";
        case NearHostelLocationPharmacyDrugstore:
            return @"Pharmacy and Drugstores";
        case NearHostelLocationPhoneMobileServices:
            return @"Phone and Mobile Services";
        case NearHostelLocationCosmeticsSkinFacialCare:
            return @"Cosmetics and Skin Care";
        case TouristAttractionTower:
            return @"Radio Towers";
        case TouristAttractionMuseumLibrary:
            return @"Museums and Libraries";
        case TouristAttractionTempleMonumentRelic:
            return @"Temples, Monuments, & Historical Sites";
        case TouristAttractionWarMemorial:
            return @"Korean War Memorial";
        case TouristAttractionShoppingArea:
            return @"Shopping Area";
        case TouristAttractionStreetMarket:
            return @"Night Market";
        case TouristAttractionTheaterMovie:
            return @"Movies and Theaters";
        default:
            return nil;
    }
}

+(NSString*)getImagePathForSeoulLocationType:(SeoulLocationType)seoulLocationType{
    switch(seoulLocationType){
        case NearHostelLocationCoffeeShop:
            return @"coffeeA";
        case NearHostelLocationKoreanBarbecue:
            return @"barbecueA";
        case NearHostelLocationConvenienceStore:
            return @"convenienceStoreA";
        case NearHostelLocationOtherRestaurants:
            return @"otherRestaurantsA";
        case NearHostelLocationSportsRecreation:
            return @"microphoneA";
        case NearHostelLocationPharmacyDrugstore:
            return @"pharmacyA";
        case NearHostelLocationPhoneMobileServices:
            return @"phoneA";
        case NearHostelLocationCosmeticsSkinFacialCare:
            return @"creamIconA";
        case NearHostelLocationPubsBars:
            return @"otherRestaurantsA";
        case NearHostelLocationOtherStores:
            return @"convenienceStoreA";
        case NearHostelLocationBankATM:
            return @"piggyBankA";
        case TouristAttractionTower:
            return @"towerA";
        case TouristAttractionMuseumLibrary:
            return @"paintingA";
        case TouristAttractionTempleMonumentRelic:
            return @"templeA";
        case TouristAttractionWarMemorial:
            return @"tankA";
        case TouristAttractionShoppingArea:
            return @"shoppingA";
        case TouristAttractionStreetMarket:
            return @"streetStandA";
        case TouristAttractionTheaterMovie:
            return @"tvD";
        default:
            return nil;
    }

}

+(UIColor*)getFontHeaderColorForSeoulLocationType:(SeoulLocationType)seoulLocationType{
    
    switch (seoulLocationType) {
        case NearHostelLocationCoffeeShop:
            return [UIColor brownColor];
        case NearHostelLocationKoreanBarbecue:
            return [UIColor redColor];
        case NearHostelLocationConvenienceStore:
            return [UIColor grayColor];
        case NearHostelLocationOtherRestaurants:
            return [UIColor purpleColor];
        case NearHostelLocationSportsRecreation:
            return [UIColor cyanColor];
        case NearHostelLocationPharmacyDrugstore:
            return [UIColor magentaColor];
        case NearHostelLocationPhoneMobileServices:
            return [UIColor blueColor];
        case NearHostelLocationCosmeticsSkinFacialCare:
            return [UIColor yellowColor];
        case NearHostelLocationPubsBars:
            return [UIColor orangeColor];
        case NearHostelLocationOtherStores:
            return [UIColor grayColor];
        case NearHostelLocationBankATM:
            return [UIColor lightGrayColor];
        case TouristAttractionTower:
            return [UIColor darkGrayColor];
        case TouristAttractionMuseumLibrary:
            return [UIColor brownColor];
        case TouristAttractionTempleMonumentRelic:
            return [UIColor redColor];
        case TouristAttractionWarMemorial:
            return [UIColor grayColor];
        case TouristAttractionShoppingArea:
            return [UIColor blueColor];
        case TouristAttractionStreetMarket:
            return [UIColor yellowColor];
        case TouristAttractionTheaterMovie:
            return [UIColor greenColor];
        default:
            return nil;
    }
    
}

@end
