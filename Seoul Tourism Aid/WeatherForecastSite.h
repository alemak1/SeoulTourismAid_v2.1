//
//  WeatherForecastSite.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WeatherForecastSite_h
#define WeatherForecastSite_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface WeatherForecastSite : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andWithTitle:(NSString*)title andWithSubtitle:(NSString*)subtitle;

-(instancetype)initWithConfigurationDict:(NSDictionary*_Nullable)configurationDict;

-(NSString*)weatherForecastSiteDescription;

@end

#endif /* WeatherForecastSite_h */
