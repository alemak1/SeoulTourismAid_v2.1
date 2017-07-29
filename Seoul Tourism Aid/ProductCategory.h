//
//  ProductCategory.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ProductCategory_h
#define ProductCategory_h

typedef enum GeneralProductCategory{
    BEVERAGE,
    LAST_GENERAL_PRODUCT_CATEGORY
    
}GeneralProductCategory;

typedef enum SpecificProductCategory{
    DAESO_TEA,
    LAST_SPECIFIC_PRODUCT_CATEGORY
    
}SpecificProductCategory;


typedef enum AssortedProductCategory{
    BEER = 0,   //0
    CEREAL = 1,
    COMPUTER = 2,
    BLENDER = 3,
    TV = 4,
    RICE_COOKER = 5,
    MICROWAVE = 6,
    FRUIT = 7,
    COFFEE = 8,
    KIMCHI_STEW = 9,
    CLOTHES = 10,
    SIM_CARD = 11,
    CELL_PHONE = 12,
    FLOWER = 13, //florist
    SHOES = 14, //shoe_store,
    TRAVEL_TOUR = 15, //travel_agency
    HAIR_GEL = 16, //hair_care,
    GAS = 17,//gas_station
    SPA = 18,//spa
    LETTER = 19,//post_office,
    ROOT_CANAL = 20, //dentist
    PILLS = 21, //pharmacy
    PET = 22,//pet_store
    OIL_CHANGE = 23,//car_repair,
    RENTAL_CAR = 24, //car_rental
    PARKING_SPACE = 25,//parking
    CAMPGROUND = 26,//campground
    BICYCLE_STORE = 27,//bicycle_store
    ATM = 28,//atm
    BANK = 29,//bank
    BOOK = 30,//book_store
    BOWLING = 31,//bowling_alley
    JEWELRY = 32,//jewelry_store
    LAUNDRY = 33,//laundry
    MOVIE_TICKET = 34,//movie_theater
    GYM = 35,//gym
    LAST_ASSORTED_PRODUCT_INDEX,
    BARBECUE,
    HAIRCUT,
    MAKEUP,
    NOODLES
}AssortedProductCategory;

#endif /* ProductCategory_h */
