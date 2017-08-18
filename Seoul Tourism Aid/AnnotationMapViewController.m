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
    NSLog(@"The latitude of this location is: %f, the longitude is: %f",self.annotation.coordinate.latitude,self.annotation.coordinate.longitude);
    
    NSDictionary* attributedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:30.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:self.annotation.title attributes:attributedTitleAttributes];
    
    
    NSDictionary* attributedAddressAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:25.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    
    
    NSAttributedString* attributedAddress = [[NSAttributedString alloc] initWithString:self.annotation.address attributes:attributedAddressAttributes];
    
    [self.titleLabel setAttributedText: attributedTitle];
    [self.addressLabel setAttributedText:attributedAddress];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.annotation];
    
    
    [self setRegionForMap];
    
    [self.mapView setNeedsLayout];

}


-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSDictionary* attributedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:30.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
        
        NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:self.annotation.title attributes:attributedTitleAttributes];
        
        
        NSDictionary* attributedAddressAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:25.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
        
        
        
        NSAttributedString* attributedAddress = [[NSAttributedString alloc] initWithString:self.annotation.address attributes:attributedAddressAttributes];
        
        [self.titleLabel setAttributedText: attributedTitle];
        [self.addressLabel setAttributedText:attributedAddress];
        
    });
}

-(void)viewWillAppear:(BOOL)animated{
  
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.annotation];
    
    
    [self setRegionForMap];
    
    [self.mapView setNeedsLayout];


}

-(void)viewDidLoad{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.annotation];
    
    
    [self setRegionForMap];
    
    [self.mapView setNeedsLayout];

}



-(void) setRegionForMap{
    
    self.mapView.region = MKCoordinateRegionMake(self.annotation.coordinate, MKCoordinateSpanMake(0.001, 0.001));
    
}

- (IBAction)getDirectionsToLocationInMaps:(UIButton *)sender {
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:self.annotation.coordinate andWithPlacemarkName:self.annotation.title];
    
    
}
@end
