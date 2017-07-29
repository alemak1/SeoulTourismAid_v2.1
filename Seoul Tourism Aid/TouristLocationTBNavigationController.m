//
//  TouristLocationTBNavigationController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristLocationTBNavigationController.h"
#import "TouristLocationTableViewController.h"
#import "TouristLocationParentController.h"
@implementation TouristLocationTBNavigationController


-(void)viewWillAppear:(BOOL)animated{
 
    TouristLocationParentController* tbParentController = (TouristLocationParentController*)[self.viewControllers firstObject];
    
    tbParentController.annotationFilePath = self.annotationFilePath;
    
}

-(void)viewDidLoad{
    
}

@end
