//
//  NSString+CurrencyHelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "NSString+CurrencyHelperMethods.h"

@implementation NSString (CurrencyHelperMethods)


+(NSString*) getCurrencyAbbreviationForCurrencyType:(CurrencyType)currencyType{
    switch (currencyType) {
        case AUD:
            return @"AUD";
        case BGN:
            return @"BGN";
        case BRL:
            return @"BRL";
        case CAD:
            return @"CAD";
        case CHF:
            return @"CHF";
        case CNY:
            return @"CNY";
        case CZK:
            return @"CZK";
        case DKK:
            return @"DKK";
        case GBP:
            return @"GBP";
        case HKD:
            return @"HKD";
        case HRK:
            return @"HRK";
        case HUF:
            return @"HUF";
        case JPY:
            return @"JPY";
        case KRW:
            return @"KRW";
        case MYR:
            return @"MYR";
        case NOK:
            return @"NOK";
        case NZD:
            return @"NZD";
        case PHP:
            return @"PHP";
        case PLN:
            return @"PLN";
        case RON:
            return @"RON";
        case RUB:
            return @"RUB";
        case SEK:
            return @"SEK";
        case SGD:
            return @"SGD";
        case THB:
            return @"THB";
        case USD:
            return @"USD";
        default:
            return nil;
    }
    
    return nil;
}

+(NSString*) getCurrencyNameForCurrencyType:(CurrencyType)currencyType{
    switch (currencyType) {
        case AUD:
            return @"Australian Dollar";
        case BGN:
            return @"Bulgarian Lev";
        case BRL:
            return @"Brazilian Real";
        case CAD:
            return @"Canadian Dollar";
        case CHF:
            return @"Swiss France";
        case CNY:
            return @"Chinese Yen";
        case CZK:
            return @"Czech Koruan";
        case DKK:
            return @"Danish Krone";
        case GBP:
            return @"British Pound";
        case HKD:
            return @"Hong Kong Dollar";
        case HRK:
            return @"Croatian Kuna";
        case HUF:
            return @"Hungarian Forint";
        case JPY:
            return @"Japanese Yen";
        case KRW:
            return @"Korean Won";
        case MYR:
            return @"Malaysian Ringgit";
        case NOK:
            return @"Norwegian Krone";
        case NZD:
            return @"New Zealand Dollar";
        case PHP:
            return @"Phillippines Peso";
        case PLN:
            return @"Polish Zloty";
        case RON:
            return @"Romanian Leu";
        case RUB:
            return @"Russian Ruble";
        case SEK:
            return @"Swedish Krona";
        case SGD:
            return @"Singapore Dollar";
        case THB:
            return @"Thai Baht";
        case USD:
            return @"US Dollar";
        default:
            return nil;
    }
    return nil;
}

+(NSString*)getAssortedProductImagePathFor:(AssortedProductCategory)productCategory{
    switch (productCategory) {
        case KIMCHI_STEW:
            return @"kimchi_stew";
        case NOODLES:
            return @"noodles";
        case MAKEUP:
            return @"makeup";
        case SIM_CARD:
            return @"sim_card";
        case CLOTHES:
            return @"red_shirt";
        case BARBECUE:
            return @"barbecue";
        case CELL_PHONE:
            return @"cell_phone";
        case HAIRCUT:
            return @"haircut";
        case BEER:
            return @"beerA";
        case COMPUTER:
            return @"laptopA";
        case CEREAL:
            return @"cerealA";
        case MICROWAVE:
            return @"microwaveA";
        case BLENDER:
            return @"blenderA";
        case FRUIT:
            return @"fruitA";
        case COFFEE:
            return @"coffeeGlassA";
        case TV:
            return @"tvA";
        case RICE_COOKER:
            return @"riceCookerA";
            /** Need icons for images below **/
        case FLOWER: //bouquet pic
            return @"bouquet120";
        case SHOES: //shoe pic
            return @"shoe120";
        case TRAVEL_TOUR: //travel pic
            return @"travel120";
        case HAIR_GEL: // hair care pic
            return @"hairCare120";
        case GAS: //gas pic
            return @"gas120";
        case SPA: //spa/massage pic
            return @"spa120";
        case LETTER: //post office pic
            return @"letter120";
        case ROOT_CANAL: //tooth pic
            return @"dentist120";
        case PILLS: //pharmacyA (previously downloaded)
            return @"medicine120";
        case OIL_CHANGE: //car repair pic
            return @"repairCar120";
        case RENTAL_CAR: //rental car pic
            return @"rentalCar120";
        case PARKING_SPACE:
            return @"parking120";
        case CAMPGROUND: //tent pic
            return @"tent120";
        case BICYCLE_STORE: //bicycle pic
            return @"bicycle120";
        case ATM: //atm pic
            return @"atm120";
        case BANK: //vault pic
            return @"vault120";
        case BOOK: //generic object pic
            return @"book";
        case BOWLING: //bowling 120
            return @"bowling120";
        case JEWELRY: //diamond pic
            return @"diamond120";
        case LAUNDRY: //laundry pic
            return @"laundry120";
        case MOVIE_TICKET: //theater pic
            return @"theater120";
        case GYM: //weightlifting pic
            return @"gym120";
        case PET:
            return @"dog120";
        default:
            return nil;
    }
}

+(NSString*)getSearchQueryAssociatedWithAssortedProductCategory:(AssortedProductCategory)assortedProductCategory{
    
    switch(assortedProductCategory){
        case KIMCHI_STEW:
            return @"restaurant";
        case NOODLES:
            return @"restaurant";
        case MAKEUP:
            return @"beauty_salon";
        case SIM_CARD:
            return @"sim card";
        case CLOTHES:
            return @"clothing_store";
        case BARBECUE:
            return @"restaurant";
        case CELL_PHONE:
            return @"cell phone";
        case HAIRCUT:
            return @"beauty_salon";
        case BEER:
            return @"liquor_store";
        case COMPUTER:
            return @"electronics_store";
        case CEREAL:
            return @"emart";
        case MICROWAVE:
            return @"electronics_store";
        case BLENDER:
            return @"electronics_store";
        case FRUIT:
            return @"store";
        case COFFEE:
            return @"cafe";
        case TV:
            return @"electronics_store";
        case RICE_COOKER:
            return @"electronics_store";
        /** Need icons for images below **/
        case FLOWER:
            return @"florist";
        case SHOES:
            return @"shoe_store";
        case TRAVEL_TOUR:
            return @"travel_agency";
        case HAIR_GEL:
            return @"hair_care";
        case GAS:
            return @"gas_station";
        case SPA:
            return @"spa";
        case LETTER:
            return @"post_office";
        case ROOT_CANAL:
            return @"dentist";
        case PILLS:
            return @"pharmacy";
        case OIL_CHANGE:
            return @"car_repair";
        case RENTAL_CAR:
            return @"car_rental";
        case PARKING_SPACE:
            return @"parking";
        case CAMPGROUND:
            return @"campground";
        case BICYCLE_STORE:
            return @"bicycle_store";
        case ATM:
            return @"atm";
        case BANK:
            return @"bank";
        case BOOK:
            return @"book_store";
        case BOWLING:
            return @"bowling_alley";
        case JEWELRY:
            return @"jewelry_store";
        case LAUNDRY:
            return @"laundry";
        case MOVIE_TICKET:
            return @"movie_theater";
        case GYM:
            return @"gym";
        default:
            return nil;
    }
}

@end
