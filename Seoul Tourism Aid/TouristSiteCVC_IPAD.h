//
//  TouristSiteCVC_IPAD.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteCVC_IPAD_h
#define TouristSiteCVC_IPAD_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TouristSiteCVC_IPAD : UICollectionViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

extern NSString* const kSeoulTowerKey;
extern NSString* const kYangguKey;
extern NSString* const kNaturalSiteKey;
extern NSString* const kMuseumKey;
extern NSString* const kParkSites;
extern NSString* const kOtherSites;

extern NSString* const kGwanghuamunSites;
extern NSString* const kShoppingSites;
extern NSString* const kTempleSites;
extern NSString* const kMonumentSites;


@end
#endif /* TouristSiteCVC_IPAD_h */
