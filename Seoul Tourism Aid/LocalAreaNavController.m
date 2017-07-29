//
//  HostelAreaNavigationController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "LocalAreaNavController.h"
#import "HostelAreaContainerController.h"


@implementation LocalAreaNavController

-(void)viewWillLayoutSubviews{
    
    HostelAreaContainerController* containerController = (HostelAreaContainerController*)[self.viewControllers firstObject];
    
    containerController.annotationSourceFilePath = self.annotationSourceFileName;
    containerController.mapRegion = self.mapViewingRegion;
    
}


-(void)viewDidLoad{
    
}


@end
