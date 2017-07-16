//
//  UIViewController+HelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "UIViewController+HelperMethods.h"
#import "WebViewController.h"
#import <WebKit/WebKit.h>

@implementation UIViewController (HelperMethods)

-(void)loadWebsiteWithURLAddress:(NSString*)urlAddress{
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSLog(@"Loading Dark Sky Website...");
    
    WebViewController* webViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    webViewController.urlAddress = urlAddress;
    
    [self showViewController:webViewController sender:nil];

    
}
@end
