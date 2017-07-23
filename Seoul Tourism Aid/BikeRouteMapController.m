//
//  BikeRouteMapController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikeRouteMapController.h"
#import "BikeRoutePoint.h"



@interface BikeRouteMapController () <MKMapViewDelegate>


@property NSMutableArray<BikeRoutePoint*>* bikeRoutePoints;


@property CLLocationCoordinate2D startingCoordinate;
@property CLLocationCoordinate2D endCoordinate;

- (IBAction)getDirectionsToStartingPoint:(UIButton *)sender;

- (IBAction)getDirectionsToEndPoint:(UIButton *)sender;


@end

@implementation BikeRouteMapController


-(void)viewWillLayoutSubviews{
    
    [self.bikeRouteMapView setDelegate:self];

    
    MKMapPoint firstPoint = self.bikeRoute.points[0];
    MKMapPoint lastPoint = self.bikeRoute.points[self.bikeRoute.pointCount-1];
    
    self.bikeRoutePoints = [[NSMutableArray alloc] initWithCapacity:self.bikeRoute.pointCount];
    
    for(int i = 0; i < self.bikeRoute.pointCount; i++){
        BikeRoutePoint* nextPoint = [[BikeRoutePoint alloc] init];
        
        MKMapPoint nextMapPoint = self.bikeRoute.points[i];
        CLLocationCoordinate2D nextMapCoordinate = MKCoordinateForMapPoint(nextMapPoint);
        
        if(i == 0){
            self.startingCoordinate = nextMapCoordinate;
        }
        
        if(i == self.bikeRoute.pointCount-1){
            self.endCoordinate = nextMapCoordinate;
        }
        
        nextPoint.coordinate = nextMapCoordinate;
        
        NSString* titleString = @"";
        
        if(i == 0){
            titleString = @"Starting Point";
        } else if(i == self.bikeRoute.pointCount-1){
            titleString = @"Endpoint";
        } else {
            titleString = [NSString stringWithFormat:@"Point %d",i];
        }
        
        nextPoint.title = titleString;
        nextPoint.subtitle = [NSString stringWithFormat:@"Route Name: %@",self.routeName];
        
        [self.bikeRoutePoints addObject:nextPoint];
    }
    
    [self.bikeRouteMapView addAnnotations:self.bikeRoutePoints];
    
    
    
    CLLocationCoordinate2D firstCoordinate = MKCoordinateForMapPoint(firstPoint);
    CLLocationCoordinate2D lastCoordinate = MKCoordinateForMapPoint(lastPoint);
    
    CLLocationDegrees latDegrees = fabs(lastCoordinate.latitude - firstCoordinate.latitude);
    CLLocationDegrees longDegrees = fabs(lastCoordinate.longitude - firstCoordinate.longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(latDegrees, longDegrees);
    
    [self.bikeRouteMapView setRegion:MKCoordinateRegionMake(MKCoordinateForMapPoint(firstPoint), span)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self.bikeRouteMapView removeOverlays:self.bikeRouteMapView.overlays];
    
    NSLog(@"About to add bike route polyline: %@",[self.bikeRoute description]);
    [self.bikeRouteMapView addOverlay:self.bikeRoute];
    
   
    
}

-(void)viewDidLoad{
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        lineView.strokeColor = [UIColor greenColor];
        
        return lineView;
    }
    
    return nil;
}



- (IBAction)getDirectionsToStartingPoint:(UIButton *)sender {
    
    [self viewDirectionsWithMapsAppTo:self.startingCoordinate];
}

- (IBAction)getDirectionsToEndPoint:(UIButton *)sender {
    [self viewDirectionsWithMapsAppTo:self.endCoordinate];
}



-(void) viewDirectionsWithMapsAppTo:(CLLocationCoordinate2D)toLocationCoordinate2D{
    
    MKMapItem* fromLocation = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D fromLocationCoordinate = fromLocation.placemark.coordinate;
    
    
    CLLocationCoordinate2D toLocationCoordinate = toLocationCoordinate2D;
    
    MKPlacemark* toLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:toLocationCoordinate];
    
    MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:toLocationPlacemark];
    
    
    
    CLLocationDistance distanceBetweenEndpoints = [fromLocation.placemark.location distanceFromLocation:toLocation.placemark.location];
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocationCoordinate, distanceBetweenEndpoints*1.5, distanceBetweenEndpoints*1.5);
    
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:toLocation,fromLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey,
                                  MKLaunchOptionsDirectionsModeDefault,MKLaunchOptionsDirectionsModeKey, nil]];
}


@end
