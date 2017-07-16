//
//  WayPointConfiguration.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocationManager.h"
#import "WayPointConfiguration.h"
#import "Constants.h"

@implementation WayPointConfiguration

-(instancetype)initWithPlaceID:(NSString*)placeID andWithName:(NSString*)name{
    
    if(self = [super init]){
        self.name = name;
        self.placeID = placeID;
    }
    
    return self;
}

-(instancetype)initWithAddress:(NSString*)address andWithName:(NSString*)name{
    
    if(self = [super init]){
        self.name = name;
        self.address = address;
    }
    
    return self;
}


-(instancetype)initWithLocation:(CLLocation*)location andWithName:(NSString*)name{
    if(self = [super init]){
        self.name = name;
        self.location = location;
    }
    
    return self;
    
}

-(NSURL*)getDirectionsRequestURLFromUserLocationOrigin{
    
    
    /** Get the User Location from CoreLocation services to pass in the user's latitude and longitude values for the required query parameter 'origin' in the Google Maps URL String **/
    
    CLLocation* userLocation =  [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSString* originString = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,nil];
    

    NSString* destinationString = [self getFormattedQueryParameter];
    

    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@",originString,destinationString,GOOGLE_API_KEY];
    
    return [NSURL URLWithString:urlString];
    
   
}

-(NSString*)getFormattedQueryParameter{
    
    NSString* queryString;
    
    if(self.placeID){
        queryString = [NSString stringWithFormat:@"place_id:%@",self.placeID];
    }
    
    if(self.location){
        queryString = [NSString stringWithFormat:@"%f,%f",self.location.coordinate.latitude,self.location.coordinate.longitude];
        
    }
    
    if(self.address){
        queryString = [NSString stringWithFormat:@"%@",self.address];
    }
    
    
    if(!queryString){
        
        NSLog(@"URL indeterminate: could not infer a valid destination string from the waypoint configuration information");
        
        return nil;
    }
    
    return queryString;

}

@end
