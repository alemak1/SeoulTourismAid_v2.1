//
//  HostelLocationAnnotation.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostelLocationAnnotation.h"

@implementation SeoulLocationAnnotation

-(instancetype)initWithDict:(NSDictionary*)configurationDict{
    
    self = [super init];
    
    if(self){
        
        CGPoint point = CGPointFromString([configurationDict valueForKey:@"location"]);
        _coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        _title = [configurationDict valueForKey:@"title"];
        _subtitle = [configurationDict valueForKey:@"subtitle"];
        _locationType = [[configurationDict valueForKey:@"type"] integerValue];
        _address = [configurationDict valueForKey:@"address"];
        _imageFilePath = [configurationDict valueForKey:@"imagefilepath"];
    }
    
    return self;
    
}

@end
