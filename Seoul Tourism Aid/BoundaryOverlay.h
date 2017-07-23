//
//  BoundaryOverlay.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef BoundaryOverlay_h
#define BoundaryOverlay_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BoundaryOverlay : NSObject<MKOverlay>


@property (nonatomic, readonly) CLLocationCoordinate2D *boundary;
@property (nonatomic, readonly) NSInteger boundaryPointsCount;

@property (nonatomic, strong) NSString *name;

-(instancetype)initWithFilename:(NSString*)fileName;


-(CLLocationCoordinate2D)midCoordinate;
-(CLLocationCoordinate2D) upperLeftCoordinate;
-(CLLocationCoordinate2D)upperRightCoordinate;
-(CLLocationCoordinate2D)bottomLeftCoordinate;
-(CLLocationCoordinate2D) bottomRightCoordinate;

@end

#endif /* BoundaryOverlay_h */
