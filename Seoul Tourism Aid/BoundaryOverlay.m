//
//  BoundaryOverlay.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoundaryOverlay.h"

@implementation BoundaryOverlay

float _latOffset = 0.001;
float _longOffset = 0.001;

-(instancetype)initWithFilename:(NSString*)fileName{
    
    self = [super init];
    
    if(self){
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];

        NSDictionary* infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        _name =[infoDict valueForKey:@"name"];
        
        NSArray* stringArray = [infoDict valueForKey:@"boundary"];
        
        _boundaryPointsCount = [stringArray count];
        
        _boundary = calloc(sizeof(CLLocationCoordinate2D), _boundaryPointsCount);
        
        NSLog(@"Initializing boundary overlay with the following point:");
        
        for(int i = 0; i < _boundaryPointsCount; i++){
            
            CGPoint p = CGPointFromString(stringArray[i]);
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(p.x, p.y);
            
            NSLog(@"Point lat,long:%f,%f",location.latitude,location.longitude);
            
            _boundary[i] = location;
        }
        
    }
    
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    return [self midCoordinate];
}


-(MKMapRect)boundingMapRect{
    MKMapPoint topLeft = MKMapPointForCoordinate([self upperLeftCoordinate]);
    MKMapPoint topRight = MKMapPointForCoordinate([self upperRightCoordinate]);
    MKMapPoint bottomLeft = MKMapPointForCoordinate([self bottomLeftCoordinate]);
    
    return MKMapRectMake(topLeft.x, topLeft.y, fabs(topLeft.x - topRight.x), fabs(topLeft.y - bottomLeft.y));
}

/** Helper Functions for Determing Upper Lower/Right and Bottom Lower/Right points of boundingMapRect**/


-(CLLocationCoordinate2D)upperLeftCoordinate{
    
    return CLLocationCoordinate2DMake([self getMaximumLatitude] + _latOffset, [self getMinimumLongitude] - _longOffset);
}

-(CLLocationCoordinate2D)upperRightCoordinate{
      return CLLocationCoordinate2DMake([self getMaximumLatitude] + _latOffset, [self getMaximumLongitude] + _longOffset);
}

-(CLLocationCoordinate2D)bottomLeftCoordinate{
      return CLLocationCoordinate2DMake([self getMinimumLatitude] - _latOffset, [self getMinimumLongitude] - _longOffset);
}

-(CLLocationCoordinate2D)bottomRightCoordinate{
    return CLLocationCoordinate2DMake([self getMinimumLatitude] - _latOffset, [self getMaximumLongitude] + _longOffset);
}

-(CLLocationCoordinate2D)midCoordinate{
    
    CGFloat midLatitude = [self getMaximumLatitude] - [self getMinimumLatitude];
    CGFloat midLongitude = [self getMaximumLongitude] - [self getMinimumLongitude];
    
    return CLLocationCoordinate2DMake(midLatitude, midLongitude);
}

/** Helper Functions for Getting MapRect corner points **/

-(float) getMinimumLongitude{
    
    float minLong = self.boundary[0].longitude;
    int minLongIndex = 0;
    
    for (int i = 0; i < self.boundaryPointsCount; i ++) {
        
        if(self.boundary[i].longitude < minLong){
            minLong = self.boundary[i].longitude;
            minLongIndex = i;
        }
    }
    
    return minLong;
}


-(float) getMaximumLongitude{
    float maxLong = self.boundary[0].longitude;
    int maxLongIndex = 0;
    
    for (int i = 0; i < self.boundaryPointsCount; i ++) {
        
        if(self.boundary[i].longitude > maxLong){
            maxLong = self.boundary[i].longitude;
            maxLongIndex = i;
        }
    }
    
    return maxLong;

}

-(float) getMinimumLatitude{
    
    float minLat = self.boundary[0].latitude;
    int minLatIndex = 0;
    
    for (int i = 0; i < self.boundaryPointsCount; i ++) {
        
        if(self.boundary[i].latitude < minLat){
            minLat = self.boundary[i].latitude;
            minLatIndex = i;
        }
    }
    
    return minLat;
}


-(float) getMaximumLatitude{
    float maxLat = self.boundary[0].latitude;
    int maxLatIndex = 0;
    
    for (int i = 0; i < self.boundaryPointsCount; i ++) {
        
        if(self.boundary[i].latitude > maxLat){
            maxLat = self.boundary[i].latitude;
            maxLatIndex = i;
        }
    }
    
    return maxLat;
}

@end
