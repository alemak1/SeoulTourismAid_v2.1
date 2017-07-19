//
//  TouristSiteConfiguration.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteConfiguration.h"


@interface TouristSiteConfiguration ()


@end


@implementation TouristSiteConfiguration

-(instancetype)initWithCKRecord:(CKRecord*)record{
    
    if(self = [super init]){
    
        record[@"accessoryImages"]; //Asset List
        record[@"address"]; //String
        record[@"calloutImage"]; //Asset
        record[@"calloutImage"]; //Asset
        record[@"category"]; //Int(64)
        record[@"calloutImage"]; //Asset
        record[@"coordinate"]; //String
        record[@"description"]; //String
        record[@"generalAdmissionFee"]; //Double
        record[@"calloutImage"]; //Asset
        record[@"location"]; //CLLocation
        record[@"largeImage"]; //Asset
        record[@"operatingHoursByDay"]; //Reference Type (operating hours)
        record[@"operatingHoursInfo"]; //List(Strings)
        record[@"parkingFee"]; //List(String)
        record[@"priceInfo"]; //List(String)
        record[@"subtitle"]; //String
        record[@"title"]; //String
        record[@"webAddress"]; //String

    }

}

@end
