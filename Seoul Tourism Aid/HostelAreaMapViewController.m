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
#import "LocalAreaNavController.h"

@interface HostelAreaMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;

- (IBAction)changeMapType:(UISegmentedControl *)sender;


@property AnnotationManager* annotationManager;


- (IBAction)showFilterOptionsController:(UIButton *)sender;


@end


@implementation HostelAreaMapViewController


static void* HostelAreaMapControllerContext = &HostelAreaMapControllerContext;

-(void)viewWillLayoutSubviews{
    

    self.annotationManager = [[AnnotationManager alloc] initWithFilename:self.annotationSourceFilePath];
    
   // [self addObserver:self forKeyPath:@"mapRegion" options:NSKeyValueObservingOptionInitial context:nil];
    
   // [self addObserver:self forKeyPath:@"annotationSourceFilePath" options:NSKeyValueObservingOptionInitial context:nil];


}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"mapRegion"]){
       // self.mapView.region = self.mapRegion;

    }
    
    if([keyPath isEqualToString:@"annotationSourceFilePath"]){
        
        //[self.mapView removeAnnotations:self.mapView.annotations];
        
       // [self.mapView addAnnotations:[self.annotationManager getAllAnnotations]];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"Selected options are: %@",[self.selectedOptions description]);
    
    [self.mapView setDelegate:self];
    [self configureMapRegion];
    
    [self.mapView removeAnnotations:self.mapView.annotations];

    if(self.selectedOptions == nil || self.selectedOptions.count == 0){
        NSLog(@"Adding all annotations...");
        [self configureAnnotations];
    
    } else {
        NSLog(@"Adding selected annotations...");

        for (NSNumber*option in self.selectedOptions) {
            SeoulLocationType locationType = (SeoulLocationType)[option integerValue];
            
            NSLog(@"Selected option include: %d",locationType);

            
            [self.mapView addAnnotations:[self.annotationManager getAnnotationsOfType:locationType]];
        }
        
    }
    
   
}


-(void)configureMapRegion{
    self.mapView.region = self.mapRegion;

}

-(void)configureAnnotations{
    
    
    [self.mapView addAnnotations:[self.annotationManager getAllAnnotations]];
    

}

-(NSMutableArray *)selectedOptions{
    
    LocalAreaNavController* localAreaNavController = (LocalAreaNavController*)self.navigationController;
    
    return localAreaNavController.selectedOptions;
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

- (IBAction)showFilterOptionsController:(UIButton *)sender {
}


@end
