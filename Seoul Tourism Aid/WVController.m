//
//  WVController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVController.h"


@interface WVController () <UIWebViewDelegate>

@property IBOutlet UIWebView* wvForWebPage;

@end

@implementation WVController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.wvForWebPage setDelegate:self];
    
    if(self.webURL){
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:self.webURL];

        [self.wvForWebPage loadRequest:urlRequest];
    } else {
        NSURL* url = [NSURL URLWithString:self.webURLString];
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        
        [self.wvForWebPage loadRequest:urlRequest];
    }
    
 
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(error){
        NSLog(@"The web view faile dto load due to the following error: %@",[error localizedDescription]);
    }
}

@end
