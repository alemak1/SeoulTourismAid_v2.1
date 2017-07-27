//
//  TouristSiteCSCNavController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteCSCNavController.h"

@implementation TouristSiteCSCNavController

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}


@end
