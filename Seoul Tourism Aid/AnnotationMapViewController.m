//
//  AnnotationMapViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/3/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AnnotationMapViewController.h"
#import "UserLocationManager.h"

@interface AnnotationMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)getDirectionsToLocationInMaps:(UIButton *)sender;


@end





@implementation AnnotationMapViewController


-(void)viewWillLayoutSubviews{
    NSLog(@"Annotation title: %@",self.annotation.title);
    NSLog(@"Annotation address: %@",self.annotation.address);
    
    
    NSDictionary* attributedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Bold" size:30.0],NSFontAttributeName,[UIColor yellowColor],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:self.annotation.title attributes:attributedTitleAttributes];
    
    
    NSDictionary* attributedAddressAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:25.0],NSFontAttributeName,[UIColor yellowColor],NSForegroundColorAttributeName, nil];
    
    
    
    NSAttributedString* attributedAddress = [[NSAttributedString alloc] initWithString:self.annotation.address attributes:attributedAddressAttributes];
    
    [self.titleLabel setAttributedText: attributedTitle];
    [self.addressLabel setAttributedText:attributedAddress];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [self.mapView setDelegate:self];
    
    [self setRegionForMap];
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    [self.mapView addAnnotation:self.annotation];
    
  
}



-(void)viewDidLoad{
    
   
 
    
    
}

-(void) setRegionForMap{
    
    self.mapView.region = MKCoordinateRegionMake(self.annotation.coordinate, MKCoordinateSpanMake(0.001, 0.001));
    
}

- (IBAction)getDirectionsToLocationInMaps:(UIButton *)sender {
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsFromHostelTo:self.annotation.coordinate];
    
}
@end
