//
//  WFSManager.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WFSManager_h
#define WFSManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WeatherForecastSite.h"

@interface WFSManager : NSObject

-(instancetype)initFromFileName:(NSString*)fileName;

-(NSString*)forecastSitesDescription;
-(NSUInteger)getNumberOfForecastSites;

-(NSString*)getTitleForForecastSite:(NSUInteger)index;
-(NSString*)getSubTitleForForecastSite:(NSUInteger)index;
-(CLLocationCoordinate2D)getCoordinateForForecastSite:(NSUInteger)index;

@end

#endif /* WFSManager_h */
