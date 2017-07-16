//
//  WeatherConfiguration.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/29/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WeatherConfiguration.h"

@implementation WeatherConfiguration


-(instancetype)initWithJSONDict:(NSDictionary*)jsonDict{
    
    self = [super init];
    
    if(self){
        
        NSDictionary* dailyInfoDict = [jsonDict valueForKey:@"daily"];
        
        NSDictionary* configurationInfo = [[dailyInfoDict valueForKey:@"data"] objectAtIndex:0];
        
        
        /** Set the date **/

        NSTimeInterval unixDate = [[configurationInfo valueForKey:@"time"] longValue];
        NSDate* formattedDate = [NSDate dateWithTimeIntervalSince1970:unixDate];
        
        _date = formattedDate;
        
        /** Set icon name**/
        
        NSString* iconName = [configurationInfo valueForKey:@"icon"];
        _iconName = iconName;
        
        
        /** Set temperature **/

        
        double temperature = [[configurationInfo valueForKey:@"temperatureMax"] doubleValue];
        _temperature = temperature;
        
        
        /** Set humidity **/

        double humidity = [[configurationInfo valueForKey:@"humidity"] doubleValue];
        _humidity = humidity;
        
        /** Set precipitation **/

        
        double precipitation = [[configurationInfo valueForKey:@"precipIntensity"] doubleValue];
        _precipitation = precipitation;
        
        /** Set wind speed **/

        double windSpeed = [[configurationInfo valueForKey:@"windSpeed"] doubleValue];
        _windSpeed = windSpeed;
        
        /** Set cloud cover **/

        double cloudCover = [[configurationInfo valueForKey:@"cloudCover"] doubleValue];
        
        _cloudCover = cloudCover;
        
        /** Set the summary text **/

        
        NSString* summaryText = [configurationInfo valueForKey:@"summary"];
        
        _summaryText = summaryText;
        
        
    }
    
    return self;
}

@end
