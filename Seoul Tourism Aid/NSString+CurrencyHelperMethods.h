//
//  NSString+CurrencyHelperMethods.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyType.h"
#import "ProductCategory.h"

@interface NSString (CurrencyHelperMethods)

+(NSString*) getCurrencyAbbreviationForCurrencyType:(CurrencyType)currencyType;

+(NSString*) getCurrencyNameForCurrencyType:(CurrencyType)currencyType;

+(NSString*)getAssortedProductImagePathFor:(AssortedProductCategory)productCategory;

+(NSString*)getSearchQueryAssociatedWithAssortedProductCategory:(AssortedProductCategory)assortedProductCategory;

@end
