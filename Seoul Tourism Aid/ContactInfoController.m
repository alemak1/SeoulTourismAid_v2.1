//
//  ContactInfoController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "ContactInfoController.h"
#import "UIViewController+HelperMethods.h"

@interface ContactInfoController ()

- (IBAction)loadFacebookPage:(UIButton *)sender;

- (IBAction)loadInstagramPage:(UIButton *)sender;

/**

- (IBAction)loadYoutubePage:(UIButton *)sender;


- (IBAction)loadGooglePlusPage:(UIButton *)sender;

- (IBAction)loadTwitterPage:(UIButton *)sender;
**/

@end



@implementation ContactInfoController

-(void)viewDidLoad{
    
}



- (IBAction)loadFacebookPage:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://www.facebook.com/gdjhouse2na/"];
}

- (IBAction)loadInstagramPage:(UIButton *)sender {
}

/**
- (IBAction)loadYoutubePage:(UIButton *)sender {
}

- (IBAction)loadGooglePlusPage:(UIButton *)sender {
}

- (IBAction)loadTwitterPage:(UIButton *)sender {
}
 
 **/

@end
