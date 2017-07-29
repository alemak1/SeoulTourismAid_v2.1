//
//  HostelAreaMapViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostelAreaMapViewController.h"
#import "HostelAreaMapOptionsController.h"
#import "AnnotationManager.h"
#import "HostelLocationAnnotationView.h"
#import "DirectionsMenuController.h"

@interface HostelAreaMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;

- (IBAction)changeMapType:(UISegmentedControl *)sender;

- (IBAction)dismissNavigationController:(UIBarButtonItem *)sender;

@property AnnotationManager* annotationManager;

- (IBAction)showAnnotationOptionsController:(UIBarButtonItem *)sender;



@end


@implementation HostelAreaMapViewController


static void* HostelAreaMapControllerContext = &HostelAreaMapControllerContext;

-(void)viewWillLayoutSubviews{
    
    [self addObserver:self forKeyPath:@"mapRegion" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"annotationSourceFilePath" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    
    /** The Map Region centers around the hostel **/
    
    self.annotationManager = [[AnnotationManager alloc] initWithFilename:self.annotationSourceFilePath];
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.mapView setDelegate:self];
    
   
  
    

    
    
}

-(void)viewDidLoad{
    


}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"mapRegion"];
    [self removeObserver:self forKeyPath:@"annotationSourceFilePath"];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if([keyPath isEqualToString:@"mapRegion"]){
        
        self.mapView.region = self.mapRegion;

        
    }
    
    if([keyPath isEqualToString:@"annotationSourceFilePath"]){
        
        
        [self.mapView addAnnotations:[self.annotationManager getAllAnnotations]];

    }

     
}


//-(void)viewDidLoad{
    
    //[super viewDidLoad];
    
    /**
    if(self.selectedOptions.count > 0){
   
        [self.mapView removeAnnotations:self.mapView.annotations];
    
        for (NSNumber* option in self.selectedOptions) {
        
            SeoulLocationType locationType = (SeoulLocationType)[option integerValue];
            
            [self.mapView addAnnotations:[self.annotationManager getAnnotationsOfType:locationType]];
        
        }
    }
     
     **/
   
//}




- (IBAction)changeMapType:(UISegmentedControl *)sender {
    switch (self.mapTypeControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (IBAction)dismissNavigationController:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    SeoulLocationAnnotationView* annotationView = [[SeoulLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"seoulLocationAnnotation"];
    
    return annotationView;
}


- (IBAction)showAnnotationOptionsController:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"presentMapViewOptionsSegue" sender:nil];
}


@end
