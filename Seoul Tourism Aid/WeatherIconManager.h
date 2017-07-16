//
//  WeatherIconManager.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/29/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WeatherIconManager_h
#define WeatherIconManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSString* const kRAIN;
extern NSString* const kSNOW;
extern NSString* const kSLEET;
extern NSString* const kWINDY;
extern NSString* const kCLOUDY;
extern NSString* const kPARTLY_CLOUDY_DAY;
extern NSString* const kPARTLY_CLOUDY_NIGHT;
extern NSString* const kCLEAR_DAY;
extern NSString* const kCLEAR_NIGHT;
extern NSString* const kFOG;
extern NSString* const kHAIL;




@interface WeatherIconManager : NSObject

typedef enum WeatherCategory{
    RAIN = 0,
    SNOW,
    SLEET,
    WIND,
    CLOUDY,
    PARTLY_CLOUDY_DAY,
    PARTLY_CLOUDY_NIGHT,
    CLEAR_DAY,
    CLEAR_NIGHT,
    FOG,
    HAIL,
    WEATHER_CATEGORY_END_INDEX

}WeatherCategory;



+(UIImage*) getWeatherIconForFilePath:(NSString*)filePath;
+(UIImage*)getWeatherIconForWeatherCategoryEnum:(WeatherCategory)weatherCategory;


@end

#endif /* WeatherIconManager_h */
