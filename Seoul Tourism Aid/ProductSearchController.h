//
//  ProductSearchController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/5/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef ProductSearchController_h
#define ProductSearchController_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ProductCategory.h"

@interface ProductSearchController : UIViewController

@property AssortedProductCategory assortedProductCategory;

@property BOOL shouldPerformGoogleSearch;


@end

#endif /* ProductSearchController_h */
