//
//  WFSManager.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WFSManager.h"

@interface WFSManager ()

@property NSArray* weatherForecastSites;

@end

@implementation WFSManager

-(instancetype)initFromFileName:(NSString*)fileName{
    
    self = [super init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    NSArray* siteInfoArray = [NSArray arrayWithContentsOfFile:path];
    
    
    NSMutableArray<WeatherForecastSite*>* wsfArray = [[NSMutableArray alloc] init];

    for(NSDictionary* siteInfoDict in siteInfoArray){
        
        WeatherForecastSite* newForecastSite = [[WeatherForecastSite alloc] initWithConfigurationDict:siteInfoDict];
        
        [wsfArray addObject:newForecastSite];
        
    }
    
    
    _weatherForecastSites = [NSArray arrayWithArray:wsfArray];
    
    return self;
}

-(NSString*)forecastSitesDescription{
    
    NSString* siteArrayDescription = @"The following weather sites have forecast information available: %@";
    
    for(WeatherForecastSite*wfs in self.weatherForecastSites){
        siteArrayDescription = [siteArrayDescription stringByAppendingString:[wfs weatherForecastSiteDescription]];
    }
                                
    return siteArrayDescription;
    
}

-(NSUInteger)getNumberOfForecastSites{
    return [self.weatherForecastSites count];
}

-(NSString*)getTitleForForecastSite:(NSUInteger)index{

    if(index > [self getNumberOfForecastSites]){
        return nil;
    }
    
    WeatherForecastSite* site = [self.weatherForecastSites objectAtIndex:index];
    
    return [site title];
}

-(NSString*)getSubTitleForForecastSite:(NSUInteger)index{
    
    if(index > [self getNumberOfForecastSites]){
        return nil;
    }
    
    WeatherForecastSite* site = [self.weatherForecastSites objectAtIndex:index];
    
    return [site subtitle];
}

-(CLLocationCoordinate2D)getCoordinateForForecastSite:(NSUInteger)index{
    
    if(index > [self getNumberOfForecastSites]){
        return CLLocationCoordinate2DMake(0.00, 0.00);
    }
    
    WeatherForecastSite* site = [self.weatherForecastSites objectAtIndex:index];
    
    return [site coordinate];
}

@end
