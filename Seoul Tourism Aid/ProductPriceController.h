//
//  ProductPriceController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ProductPriceController_h
#define ProductPriceController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProductCategory.h"

@interface ProductPriceController : UICollectionViewController

@property NSString* currentCurrencyCode;

-(void)setCurrentAssortedProductCategory:(AssortedProductCategory)assortedProductCategory;
-(AssortedProductCategory)getCurrentAssortedProductCategory;

@end

#endif /* ProductPriceController_h */
