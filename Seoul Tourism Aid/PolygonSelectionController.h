//
//  PolygonSelectionController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef PolygonSelectionController_h
#define PolygonSelectionController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PolygonSelectionController : UITableViewController

typedef enum POLYGON_TYPE{
    LOTTO_HOTEL,
    PETRAEUS_BUILDING,
    KOREAN_WAR_MEMORIAL,
    GUANGHUAMUN,
    NATIONAL_PALACE_MUSEUM,
    WORLD_CUP_STADIUM,
    LAST_POLYGON_INDEX
}POLYGON_TYPE;

@end

#endif /* PolygonSelectionController_h */
