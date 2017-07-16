//
//  WeatherForecastSite.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecastSite.h"

@implementation WeatherForecastSite

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andWithTitle:(NSString*)title andWithSubtitle:(NSString*)subtitle{
    

    self = [super init];
    
    if(self){
        _coordinate = coordinate;
        _title = _title;
        _subtitle = subtitle;
    }
    
    return self;
}


-(instancetype)initWithConfigurationDict:(NSDictionary*)configurationDict{
    
    self = [super init];
    
    if(self){
        NSString* title = [configurationDict valueForKey:@"title"];
        NSString* subtitle = [configurationDict valueForKey:@"subtitle"];
        CLLocationDegrees longitude = [[configurationDict valueForKey:@"longitude"] doubleValue];
        CLLocationDegrees latitude = [[configurationDict valueForKey:@"latitude"] doubleValue];
    
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
    
}

-(NSString*)weatherForecastSiteDescription{
    
    return [NSString stringWithFormat:@"Weather Forecast Site with Title: %@, Subtitle: %@, Latitude: %f, Longitude: %f",self.title,self.subtitle,self.coordinate.latitude,self.coordinate.longitude];
    
}

@end
