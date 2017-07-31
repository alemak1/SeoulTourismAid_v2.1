//
//  HostelAreaNavigationController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "LocalAreaNavController.h"
#import "HostelAreaMapViewController.h"

@implementation LocalAreaNavController

-(void)viewWillLayoutSubviews{
    
    HostelAreaMapViewController* hostelAreaMapViewController = (HostelAreaMapViewController*)[self.viewControllers firstObject];
    
    hostelAreaMapViewController.annotationSourceFilePath = self.annotationSourceFileName;
    hostelAreaMapViewController.mapRegion = self.mapViewingRegion;
    
}


-(void)viewDidLoad{
    
}


@end
