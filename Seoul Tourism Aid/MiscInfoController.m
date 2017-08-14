//
//  MiscInfoController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MiscInfoController.h"
#import "UIViewController+HelperMethods.h"


@interface MiscInfoController ()


- (IBAction)showAppReviewPage:(UIButton *)sender;

- (IBAction)showAppSupportWebsite:(UIButton *)sender;



@end


@implementation MiscInfoController

-(void)viewDidLoad{
    
}



- (IBAction)showAppReviewPage:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://suzhoupanda.github.io"];
    
}

- (IBAction)showAppSupportWebsite:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://suzhoupanda.github.io/seoul_tourism_aid/index.html"];
}


@end
