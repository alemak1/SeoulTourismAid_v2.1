//
//  OverlayConfiguration.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverlayConfiguration.h"


@interface OverlayConfiguration () 

@end

@implementation OverlayConfiguration

-(instancetype)initWithGMSPlace: (GMSPlace*)place{
    
    if(self = [super init]){
         _midCoordinate = place.coordinate;
         _name = place.name;

    }
    
    return self;
}

- (instancetype)initWithFilename:(NSString *)filename{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        _midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
        
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
        
        NSArray *boundaryPoints = properties[@"boundary"];
        
        _boundaryPointsCount = boundaryPoints.count;
        
        _boundary = malloc(sizeof(CLLocationCoordinate2D)*_boundaryPointsCount);
        
        for(int i = 0; i < _boundaryPointsCount; i++) {
            CGPoint p = CGPointFromString(boundaryPoints[i]);
            _boundary[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
    }
    
    return self;
}


-(instancetype)initWithDictionary:(NSDictionary*)properties{
    
    self = [super init];
    
    if(self){
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        _midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
    
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
    
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
    
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
    
        NSArray *boundaryPoints = properties[@"boundary"];
    
        _boundaryPointsCount = boundaryPoints.count;
    
        _boundary = malloc(sizeof(CLLocationCoordinate2D)*_boundaryPointsCount);
    
        for(int i = 0; i < _boundaryPointsCount; i++) {
            CGPoint p = CGPointFromString(boundaryPoints[i]);
            _boundary[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
        
    }
    
    return self;
}



- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"Midpoint Latitude: %f ; Midpoint Longitude: %f; Overlay Top Left Latitude: %f, Overlay Top Left Longitude: %f; OverlayTopRight Latitude: %f, OverlayTopRight Longitude: %f; OverlayBottomLeft Latitude: %f, Overlay Bottom Left Longitude: %f, OVerlayBottomRight Latitude: %f, OverlayBottomRight Longitude: %f",self.midCoordinate.latitude, self.midCoordinate.longitude,self.overlayTopLeftCoordinate.latitude,self.overlayTopLeftCoordinate.longitude,self.overlayTopRightCoordinate.latitude,self.overlayTopRightCoordinate.longitude,self.overlayBottomLeftCoordinate.latitude,self.overlayBottomLeftCoordinate.longitude,self.overlayBottomRightCoordinate.latitude,self.overlayBottomRightCoordinate.longitude];
}


-(CLLocationCoordinate2D)coordinate{
    return _midCoordinate;
}

-(MKMapRect)boundingMapRect{
    return self.overlayBoundingMapRect;
}

@end
