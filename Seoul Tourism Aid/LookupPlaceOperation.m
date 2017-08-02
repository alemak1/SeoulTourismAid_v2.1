//
//  LookupPlaceOperation.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "LookupPlaceOperation.h"

@import GooglePlaces;




@implementation LookupPlaceOperation

NSString* _placeID;

-(instancetype)initWithPlaceID:(NSString*)placeID{
    
    self = [super init];
    
    if(self){
        
        _placeID = placeID;

    }
    
    return self;
}

-(instancetype)init{
    
    self = [super init];
    
    return self;
}


-(void)main{
    
    [[GMSPlacesClient sharedClient] lookUpPlaceID:_placeID callback:^(GMSPlace*result, NSError*error){
        
        
        
        if(result){
            
            NSLog(@"Finished initializing GooglePlace with info %@",[self description]);
        } else {
            
            if(error){
                
                NSLog(@"Error occurred while looking up Location via Google PlaceID: %@",[error localizedDescription]);
                NSLog(@"Reasone for failure: %@",[error localizedFailureReason]);
                
            } else {
                NSLog(@"Error: failed to download Google Place; no results obtain from callback");
                
                
            }
            
            
        }
    }];

    
}

@end
