//
//  HostelAreaContainerController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "HostelAreaContainerController.h"
#import "HostelAreaMapViewController.h"

@interface HostelAreaContainerController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (readonly) HostelAreaMapViewController*hostelAreaMapViewController;

@end

@implementation HostelAreaContainerController

//BOOL _parentViewHasLoaded = false;

-(void)viewWillLayoutSubviews{
    
   
    [self addObserver:self forKeyPath:@"hostelAreaMapViewController" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    
    
   // _parentViewHasLoaded = YES;
    
    self.hostelAreaMapViewController.annotationSourceFilePath = self.annotationSourceFilePath;
    self.hostelAreaMapViewController.mapRegion = self.mapRegion;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [self performSegueWithIdentifier:@"embedHostelAreaMapViewController" sender:nil];

    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"hostelAreaMapViewController"]){
        
        self.hostelAreaMapViewController.annotationSourceFilePath = self.annotationSourceFilePath;
        self.hostelAreaMapViewController.mapRegion = self.mapRegion;
        
        
    }
    
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"hostelAreaMapViewController"];
}


-(void)viewDidLoad{
  
    
}


-(HostelAreaMapViewController *)hostelAreaMapViewController{
    
    HostelAreaMapViewController* hostelAreaMapViewController = (HostelAreaMapViewController*)[self.childViewControllers firstObject];
    
    return hostelAreaMapViewController;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"embedHostelAreaMapViewController"]){
        
        /**
        NSLog(@"Preparing to embed the HostelAreaMapViewController...");

        NSString* debugMessage1 = @"Parent view has loaded, so segue will be performed";
        NSString* debugMessage2 = @"Parent view has NOT loaded, so segue will NOT be performed";
        
        NSString* debugMessage = _parentViewHasLoaded ? debugMessage1 : debugMessage2;
        
        NSLog(@"Debug message: %@",debugMessage);
        **/
        
        
        HostelAreaMapViewController* hostelAreaMapViewController = segue.destinationViewController;
        
        hostelAreaMapViewController.annotationSourceFilePath = self.annotationSourceFilePath;
        hostelAreaMapViewController.mapRegion = self.mapRegion;
    }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    /**
    if([identifier isEqualToString:@"embedHostelAreaMapViewController"]){
        
        NSString* debugMessage1 = @"Parent view has loaded, so segue will be performed";
        NSString* debugMessage2 = @"Parent view has NOT loaded, so segue will NOT be performed";
        
        NSString* debugMessage = _parentViewHasLoaded ? debugMessage1 : debugMessage2;
        
        NSLog(@"Debug message: %@",debugMessage);

        return _parentViewHasLoaded ? YES: NO;
        
    }
    
    return NO;
     **/
    return YES;
}

@end
