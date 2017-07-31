//
//  AnnotationMapViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/3/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AnnotationMapViewController.h"
#import "UserLocationManager.h"
#import "UIColor+HelperMethods.h"

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
    
    
    NSDictionary* attributedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:30.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:self.annotation.title attributes:attributedTitleAttributes];
    
    
    NSDictionary* attributedAddressAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:25.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    
    
    NSAttributedString* attributedAddress = [[NSAttributedString alloc] initWithString:self.annotation.address attributes:attributedAddressAttributes];
    
    [self.titleLabel setAttributedText: attributedTitle];
    [self.addressLabel setAttributedText:attributedAddress];
    
    [self.mapView setDelegate:self];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.annotation];
    
    [self setRegionForMap];
    
}





-(void)viewDidLoad{
    [self.mapView setDelegate:self];

    [self.mapView removeAnnotations:self.mapView.annotations];

    [self.mapView addAnnotation:self.annotation];
    
    [self setRegionForMap];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.mapView addAnnotation:self.annotation];
    
    [self setRegionForMap];

}

-(void) setRegionForMap{
    
    self.mapView.region = MKCoordinateRegionMake(self.annotation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    
}

- (IBAction)getDirectionsToLocationInMaps:(UIButton *)sender {
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsFromHostelTo:self.annotation.coordinate];
    
}
@end
