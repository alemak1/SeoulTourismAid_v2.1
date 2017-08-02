//
//  GooglePlaceCollectionViewController.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GooglePlaceCollectionViewController_h
#define GooglePlaceCollectionViewController_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GooglePlaceManager.h"
#import "GooglePlace.h"

@interface GooglePlaceCollectionViewController : UICollectionViewController

@property USER_DEFINED_GOOGLE_PLACE_CATEGORY placeCategory;

@end

#endif /* GooglePlaceCollectionViewController_h */
