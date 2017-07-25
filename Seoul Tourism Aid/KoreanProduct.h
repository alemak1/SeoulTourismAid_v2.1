//
//  KoreanProduct.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef KoreanProduct_h
#define KoreanProduct_h

#import <Foundation/Foundation.h>
#import "ProductCategory.h"

@interface KoreanProduct : NSObject


@property NSString* name;
@property NSString* brand;
@property NSString* imagePath;
@property NSNumber* priceInKRW;
@property NSString* unityQuantity;

@property AssortedProductCategory assortedCategory;
@property GeneralProductCategory generalCategory;
@property SpecificProductCategory specificCategory;

-(instancetype)initWithDictionary:(NSDictionary*)configurationDict;


@end

#endif /* KoreanProduct_h */
