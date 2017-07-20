//
//  UIViewController+HelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "UIViewController+HelperMethods.h"
#import "WVController.h"
#import <WebKit/WebKit.h>

@implementation UIViewController (HelperMethods)

-(void)loadWebsiteWithURLAddress:(NSString*)urlAddress{
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    NSLog(@"Loading Dark Sky Website...");
    
    WVController* webViewController = [storyboardC instantiateViewControllerWithIdentifier:@"WVController"];
    
    webViewController.webURLString = urlAddress;
    
    [self showViewController:webViewController sender:nil];

    
}
@end
