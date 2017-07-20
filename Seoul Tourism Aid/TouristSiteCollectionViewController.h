//
//  TouristSiteCollectionViewController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristSiteCollectionViewController_h
#define TouristSiteCollectionViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TouristSiteConfiguration.h"

@interface TouristSiteCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property TouristSiteCategory category;

@end


#endif /* TouristSiteCollectionViewController_h */
