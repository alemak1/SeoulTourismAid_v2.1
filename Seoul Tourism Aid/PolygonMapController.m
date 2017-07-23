//
//  PolygonMapController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//



#import "PolygonMapController.h"

@interface PolygonMapController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;


@end

@implementation PolygonMapController


-(void)viewWillLayoutSubviews{
    
    [self.mainMapView setDelegate:self];
    
    
  
      MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.polygonOverlay.boundingMapRect);
    
    self.mainMapView.region = region;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mainMapView removeOverlays:self.mainMapView.overlays];
    
    MKPolygon* polygon = [MKPolygon polygonWithCoordinates:self.polygonOverlay.boundary count:self.polygonOverlay.boundaryPointsCount];
    
    [self.mainMapView addOverlay:polygon];
    
    
    
    
}

-(void)viewDidLoad{
    
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolygon class]]){
        
        MKPolygonRenderer* polygonView = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        
        polygonView.strokeColor = [UIColor greenColor];
        
        return polygonView;
    }
    
    return nil;
}


@end
