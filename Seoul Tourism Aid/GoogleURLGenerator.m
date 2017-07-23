//
//  GoogleURLGenerator.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserLocationManager.h"
#import "GoogleURLGenerator.h"
#import "Constants.h"


@implementation GoogleURLGenerator

+(NSURL*)getURLFromOrigin:(WayPointConfiguration*)origin toDestination:(WayPointConfiguration*)destination{
    
    
    NSString* originQueryParameter = [origin getFormattedQueryParameter];
    NSString* destinationQueryParameter = [destination getFormattedQueryParameter];
    
     NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",originQueryParameter,destinationQueryParameter];
    
    
    return [NSURL URLWithString:urlString];
}


+(NSURL*)getURLFromOrigin:(WayPointConfiguration*)origin toDestination:(WayPointConfiguration*)destination andWithIntermediaryWaypoints:(NSArray<WayPointConfiguration*>*)wayPoints{
    
    
    NSString* originQueryParameter = [origin getFormattedQueryParameter];
    NSString* destinationQueryParameter = [destination getFormattedQueryParameter];
    
    NSString* baseURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",originQueryParameter,destinationQueryParameter];
    
    NSString* modifiedURLString = [baseURLString stringByAppendingString:@"&waypoints=optimize:true"];
    
    for(WayPointConfiguration*wayPoint in wayPoints){
        
        NSString* queryParameter = [wayPoint getFormattedQueryParameter];
        
        NSString* modifiedQueryParameter = [NSString stringWithFormat:@"|%@",queryParameter];
        
        modifiedURLString = [modifiedURLString stringByAppendingString:modifiedQueryParameter];
    }
    
    

    return [NSURL URLWithString:modifiedURLString];
}


+(NSURL*)getURLFromUserLocationToDestination:(WayPointConfiguration*)destination{
    
    CLLocation* userLocation =  [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSString* originString = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,nil];
    
    
    NSString* destinationString = [destination getFormattedQueryParameter];
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",originString,destinationString];
    
    return [NSURL URLWithString:urlString];
    
}


+(NSURL*)getURLFromUserLocationtoDestination:(WayPointConfiguration*)destination andWithIntermediaryWaypoints:(NSArray<WayPointConfiguration*>*)wayPoints{
    
    CLLocation* userLocation =  [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    NSString* originQueryParameter = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,nil];
    

    NSString* destinationQueryParameter = [destination getFormattedQueryParameter];
    
    NSString* baseURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",originQueryParameter,destinationQueryParameter];
    
    NSString* modifiedURLString = [baseURLString stringByAppendingString:@"&waypoints=optimize:true"];
    
    for(WayPointConfiguration*wayPoint in wayPoints){
        
        NSString* queryParameter = [wayPoint getFormattedQueryParameter];
        
        NSString* modifiedQueryParameter = [NSString stringWithFormat:@"|%@",queryParameter];
        
        modifiedURLString = [modifiedURLString stringByAppendingString:modifiedQueryParameter];
    }
    
   
    return [NSURL URLWithString:modifiedURLString];
    
    
}




@end
