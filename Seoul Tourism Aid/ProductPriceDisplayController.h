//
//  ProductPriceDisplayController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ProductPriceDisplayController_h
#define ProductPriceDisplayController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProductPriceDisplayController : UIViewController

@property NSString* foreignCurrencyAbbreviation;

@property NSNumber* foreignPrice;
@property NSNumber* koreanPrice;

@property NSString* productPriceDescription;


@end

#endif /* ProductPriceDisplayController_h */
