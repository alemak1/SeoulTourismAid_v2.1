//
//  WebViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WebViewController.h"



@interface WebViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end



@implementation WebViewController



-(void)viewWillLayoutSubviews{
    
    NSLog(@"Generating URL request object....");
    
    NSURL* url = [NSURL URLWithString:self.urlAddress];
    NSURLRequest * requestObj = [NSURLRequest requestWithURL:url];
    
    NSLog(@"Loading URL request");
    
    [self.webView loadRequest:requestObj];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
}


-(void)viewDidLoad{
    
    
}


@end
