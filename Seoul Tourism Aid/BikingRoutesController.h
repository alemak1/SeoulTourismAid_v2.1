//
//  BikingRoutesController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef BikingRoutesController_h
#define BikingRoutesController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BikingRoutesController : UITableViewController


typedef enum BIKE_ROUTES{
    GONGDEOK_HYOCHANG_ROUTE,
    GONGDEOK_SEOGANG_ROUTE,
    NATIONAL_SECURITY_PAVILION_PATH,
    KOREAN_WAR_EXHIBIT_ROOM_1,
    KOREAN_WAR_EXHIBIT_ROOM_2,
    KOREAN_WAR_EXHIBIT_ROOM_3,
    WAR_HISTORY_EXHIBIT_ROOM_1,
    WAR_HISTORY_EXHIBIT_ROOM_2,
    DONATED_RELICS_EXHIBIT,
    ROK_ARMED_FORCES_ROOM,
    LAST_ROUTE_INDEX
}BIKE_ROUTES;

@end

#endif /* BikingRoutesController_h */
