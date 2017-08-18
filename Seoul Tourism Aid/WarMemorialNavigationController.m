//
//  WarMemorialNavigationController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/4/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WarMemorialNavigationController.h"
#import "CloudKitHelper.h"
#import "UserLocationManager.h"

@interface WarMemorialNavigationController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *annotationImageView;

@property (weak, nonatomic) IBOutlet UILabel *annotationLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *loadingProgressLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


- (IBAction)getDirectionsToUserSelectedAnnotation:(UIButton *)sender;


@property MKAnnotationView* selectedAnnotationView;

@end





@implementation WarMemorialNavigationController

@synthesize annotationsFileSource = _annotationsFileSource;
@synthesize polygonOverlayFileSources = _polygonOverlayFileSources;
@synthesize annotationViewImagePath = _annotationViewImagePath;
@synthesize mapCoordinateRegion = _mapCoordinateRegion;

-(void)viewWillLayoutSubviews{
    
    
    [self.mapView setDelegate:self];
    [self.mapView removeOverlays:self.mapView.overlays];

    [self loadPolygonOverlays];
    
    

   
    
}



-(void)updateProgressViewWithProgress:(CGFloat)newProgress{
    
    [self.progressView setProgress:newProgress];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self setMapRegion];


}


-(void)viewDidLoad{

}

#pragma mark ******** PUBLIC HELPER METHODS FOR UPDATING THE UI

-(void)initializeProgressView{
    [self.progressView setProgress:0.00];
}

-(void)hideProgressViewElements{
    [self.progressView setHidden:YES];
    [self.loadingProgressLabel setHidden:YES];
}

-(void)hideAnnotationDisplayElements{
    [self.mapView setHidden:YES];
    [self.annotationLabel setHidden:YES];
    [self.annotationImageView setHidden:YES];
}


-(void)showAnnotationDisplayElements{
    [self.mapView setHidden:NO];
    [self.annotationLabel setHidden:NO];
    [self.annotationImageView setHidden:NO];
}

-(void)updateUserInterfaceUponDownloadCompletion{
    
        [self.progressView setHidden:YES];
        [self.loadingProgressLabel setHidden:YES];
    
        [self.mapView setHidden:NO];
        [self.annotationLabel setHidden:NO];
        [self.annotationImageView setHidden:NO];

}

#pragma makr ****** MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView* view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
    
    
    view.image = [UIImage imageNamed:self.annotationViewImagePath];
    
    return view;
}
 


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    //Set the label and the image view with annotation objects description text and image path respectively
    
    self.selectedAnnotationView = view;
    
    WarMemorialAnnotation* annotation = [self getWarMemorialAnnotationForAnnotationView:view];
    
    [self configureAnnotationLabelWithAnnotation:annotation];
    
    [self configureAnnotationImageViewWithAnnotation:annotation];
  
}



-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer* circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        [circleView setStrokeColor:[UIColor redColor]];
        
        return circleView;
    } else if([overlay isKindOfClass:[MKPolyline class]]){
        
        MKPolylineRenderer* polygonView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        
        [polygonView setStrokeColor:[UIColor greenColor]];
        
        return polygonView;
        
    }
    
    return nil;
}


#pragma mark ******** HELPER METHODS FOR CONFIGURING INITIAL SETUP OF THE MAPVIEW AND DATASOURCE

-(void)loadWarMemorialAnnotationsArrayFromPlist{
    
    self.annotationStore = [[NSMutableArray alloc] init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:self.annotationsFileSource ofType:@"plist"];
    
    NSArray* warMemorialDictArray = [NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary*dict in warMemorialDictArray){
        WarMemorialAnnotation* annotation = [[WarMemorialAnnotation alloc] initWithDict:dict];
        

        [self.annotationStore addObject:annotation];
        
    
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.annotationStore];
    
}

-(void) setMapRegion{
    

    [self.mapView setRegion:self.mapCoordinateRegion];
    
}


-(void) loadAnnotations{
    
    NSLog(@"MapView is loading the downloaded annotations...");
    
    [self.mapView removeAnnotations:self.mapView.annotations];
   
    if(self.annotationStore){
        [self.mapView addAnnotations:self.annotationStore];
    }
}


-(void) loadCircleOverlays{
    
    if(self.annotationStore){
        for(WarMemorialAnnotation* annotation in self.annotationStore){
        
            CLLocationCoordinate2D circleCenter = [annotation coordinate];
        
            MKCircle* circleOverlay = [MKCircle circleWithCenterCoordinate:circleCenter radius:30.0];
        
            NSLog(@"Adding circle overlay with description %@",[circleOverlay description]);
        
            [self.mapView addOverlay:circleOverlay];
        }
    }
}


-(void) loadPolygonOverlays{
    
    if(self.polygonOverlayFileSources){
        for(NSString* filePath in self.polygonOverlayFileSources){
            [self loadPolygonOverlayWithFileName:filePath];
        }
    }
}


- (void) loadPolygonOverlayWithFileName:(NSString*)fileName{
    
    NSString* mainBuildingPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    NSDictionary* mainBuildingDict = [NSDictionary dictionaryWithContentsOfFile:mainBuildingPath];
    
    
    
    NSArray* pointsArray = mainBuildingDict[@"boundary"];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++){
        CGPoint p =  CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x, p.y);
    }
    
    MKPolyline* mainBuildingPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    NSLog(@"Adding polyline with description: %@",[mainBuildingPolyline description]);
    
    [self.mapView addOverlay:mainBuildingPolyline];
}


#pragma mark ****** HELPER METHOD FOR GETTING ANNOTATION CORRESPONDING TO AN ANNOTATION VIEW (i.e. annotation view selected by the user) 

-(WarMemorialAnnotation*)getWarMemorialAnnotationForAnnotationView:(MKAnnotationView*)view{
    
    for(WarMemorialAnnotation* warAnnotation in self.annotationStore){
        
        if(warAnnotation.title == view.annotation.title){
            
            return view.annotation;
            
        }
        
    }
    
    return nil;
}


/** Getters and setters for exposed properties **/

-(void)setAnnotationsFileSource:(NSString *)annotationsFileSource{
    _annotationsFileSource = annotationsFileSource;
}

-(NSString*)annotationsFileSource{
    return _annotationsFileSource;
}

#pragma mark ******* HELPER METHODS FOR CONFIGURING THE ANNOTATION LABEL AND IMAGEVIEW 

- (void) configureAnnotationImageViewWithAnnotation:(WarMemorialAnnotation*)annotation{
    if(annotation.image){
        
        [self.annotationImageView setImage:annotation.image];
        
    } else {
        [self.annotationImageView setImage:[UIImage imageNamed:@"zooCageC"]];
    }
}

-(void) configureAnnotationLabelWithAnnotation:(WarMemorialAnnotation*)annotation{
    
    NSString* labelString = annotation.title;
    
    NSDictionary* attributedStringDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Bold" size:30.0],NSFontAttributeName,[UIColor greenColor],NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:labelString attributes:attributedStringDict];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        NSString* descriptionText = @" / ";
        descriptionText = [descriptionText stringByAppendingString:annotation.subtitle];
        
        NSDictionary* descriptionTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:20.0],NSFontAttributeName,[UIColor greenColor],NSForegroundColorAttributeName, nil];
        
        NSAttributedString* attributedDescriptionString = [[NSAttributedString alloc] initWithString:descriptionText attributes:descriptionTextAttributes];
        
        [attributedString insertAttributedString:attributedDescriptionString atIndex:[labelString length]];
        
    }
    
    
    
    [self.annotationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.annotationLabel setMinimumScaleFactor:0.50];
    [self.annotationLabel setNumberOfLines:0];
    
    [self.annotationLabel setAttributedText:attributedString];
    
}


- (IBAction)getDirectionsToUserSelectedAnnotation:(UIButton *)sender {
    
    if(!self.selectedAnnotationView){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No location selected!" message:@"Select a location in order to get directions in Maps" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okayAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
        
    }
    
    [[UserLocationManager sharedLocationManager] viewLocationInMapsTo:self.selectedAnnotationView.annotation.coordinate andWithPlacemarkName:self.selectedAnnotationView.annotation.title];
    
    
    

}

@end
