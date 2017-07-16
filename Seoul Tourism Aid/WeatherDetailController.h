//
//  WeatherDetailController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/30/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WeatherDetailController_h
#define WeatherDetailController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherDetailController : UIViewController


@property NSString* summaryText;
@property NSDate* date;

@property double temperature;
@property double humidity;
@property double precipitation;
@property double cloudCover;
@property int windSpeed;


@end

#endif /* WeatherDetailController_h */
