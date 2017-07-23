//
//  WarMemorialAnnotation.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/4/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WarMemorialAnnotation.h"

@implementation WarMemorialAnnotation


-(instancetype)initWithCKRecord:(CKRecord*)record{
    
    if(self = [super init]){
        
        NSLog(@"Initializing a WarMemorialAnnotation from a CKRecord...");
        
        self.title = record[@"title"];
        self.subtitle = record[@"subtitle"];
        self.annotationDescription = record[@"description"];
        
        NSString* coordinateString = record[@"coordinate"];
        CGPoint point = CGPointFromString(coordinateString);
        self.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        
        NSString* navigationRegionName = record[@"navigationRegionName"];
        
        CKAsset* asset = record[@"image"];
        
        if(asset == nil){
            NSLog(@"Error: CKAsset for image data failed to download for annotation with description %@",self.annotationDescription);
        } else {
            
            NSURL* assetURL = [asset fileURL];
            NSData* imageData = [NSData dataWithContentsOfURL:assetURL];
            
            UIImage* annotationImage = [UIImage imageWithData:imageData];
            
            self.image = (annotationImage != nil) ? annotationImage : [self getDefaultImageForNavigationRegionName:navigationRegionName];
            
        
            
        }
      
        
        
    }
    
    return self;
}


-(instancetype)initWithDict:(NSDictionary*)configurationDict{
    
    self = [super init];
    
    if(self){
        
        self.title = configurationDict[@"title"];
        self.subtitle = configurationDict[@"subtitle"];
        self.annotationDescription = configurationDict[@"description"];
        self.imagePath =  configurationDict[@"imagePath"];
        
        NSString* coordinateString = configurationDict[@"coordinate"];
        CGPoint point = CGPointFromString(coordinateString);
        
        self.coordinate = CLLocationCoordinate2DMake(point.x, point.y);



    }
    
    return self;
}


-(UIImage*)getDefaultImageForNavigationRegionName:(NSString*)navigationRegionName{
    
    if([navigationRegionName isEqualToString:@"SeoulGrandPark"]){
        return [UIImage imageNamed:@"zooCageC"];
    }
    
    return nil;
}

@end
