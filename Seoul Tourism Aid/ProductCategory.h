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
    FLOWER, //florist
    SHOES, //shoe_store,
    TRAVEL_TOUR, //travel_agency
    HAIR_GEL, //hair_care,
    GAS,//gas_station
    SPA,//spa
    LETTER,//post_office,
    ROOT_CANAL, //dentist
    PILLS, //pharmacy
    PET,//pet_store
    OIL_CHANGE,//car_repair,
    RENTAL_CAR, //car_rental
    PARKING_SPACE,//parking
    CAMPGROUND,//campground
    BICYCLE_STORE,//bicycle_store
    ATM,//atm
    BANK,//bank
    BOOK,//book_store
    BOWLING,//bowling_alley
    JEWELRY,//jewelry_store
    LAUNDRY,//laundry
    MOVIE_TICKET,//movie_theater
    GYM,//gym
    LAST_ASSORTED_PRODUCT_INDEX,
    BARBECUE,
    HAIRCUT,
    MAKEUP,
    NOODLES
}AssortedProductCategory;

#endif /* ProductCategory_h */
