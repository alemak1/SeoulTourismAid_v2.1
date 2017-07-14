//
//  VideoScrollViewController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoScrollViewController.h"
#import "MainVideoPreviewController.h"

@interface VideoScrollViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation VideoScrollViewController

-(void)viewDidLoad{
    
    CGRect viewFrame = self.view.frame;
    CGFloat contentViewHeight = 1.50*CGRectGetHeight(viewFrame);
    CGFloat contentViewWidth = 0.80*CGRectGetWidth(viewFrame);
    CGSize contentViewSize = CGSizeMake(contentViewWidth, contentViewHeight);
    
    [self.scrollView setContentSize:contentViewSize];
    
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainVideoPreviewController* videoPreviewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainVideoPreviewController"];
    
    [self addChildViewController:videoPreviewController];
    
    videoPreviewController.view.frame = CGRectMake(0.00, 0.00, contentViewWidth, contentViewHeight);
    
    [self.scrollView addSubview:videoPreviewController.view];
    
    
    [videoPreviewController didMoveToParentViewController:self];
}

//Storyboard ID: MainVideoPreviewController

@end
