//
//  KoreanProduct.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/5/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "KoreanProduct.h"


@implementation KoreanProduct

-(instancetype)initWithDictionary:(NSDictionary*)configurationDict{
    
    self = [super init];
    
    
    if(self){
        
        _brand = configurationDict[@"brand"];
        _name = configurationDict[@"name"];
        _imagePath = configurationDict[@"imagePath"];
        _priceInKRW = configurationDict[@"priceInKRW"];
        _unityQuantity = configurationDict[@"unitQuantity"];
        
        _generalCategory = (GeneralProductCategory)[configurationDict[@"generalCategory"] integerValue];
        
        _specificCategory = (SpecificProductCategory)[configurationDict[@"specificCategory"] integerValue];
        
        if(configurationDict[@"assortedCategory"]){
             _assortedCategory = (AssortedProductCategory)[configurationDict[@"assortedCategory"] integerValue];
        }
        
       
        
        
        
    }
    
    return self;
}

@end
