//
//  WeatherConfiguration.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/29/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WeatherConfiguration_h
#define WeatherConfiguration_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherConfiguration : NSObject

@property NSDate* date;
@property NSString* iconName;
@property NSString* summaryText;

@property double temperature;
@property double humidity;
@property double precipitation;
@property double windSpeed;
@property double cloudCover;

-(instancetype)initWithJSONDict:(NSDictionary*)jsonDict;

@end

#endif /* WeatherConfiguration_h */
