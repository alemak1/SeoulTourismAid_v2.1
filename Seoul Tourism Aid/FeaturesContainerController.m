//
//  FeaturesContainerController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeaturesContainerController.h"



@interface FeaturesContainerController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation FeaturesContainerController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    /** Configure the scroll view **/
    
    [self.scrollView setDelegate:self];
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)*1.80)];
    
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:NO];
    
    /** Instantiate the feature view controller from the storyboard, add it as a child view controller, and add it view to the scroll view **/
    
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    
    UIViewController* featuresVC = [storyboardD instantiateViewControllerWithIdentifier:@"AppFeatureController"];
    
    [self addChildViewController:featuresVC];
    
    [self.scrollView addSubview:featuresVC.view];
    
    [featuresVC.view setFrame:CGRectMake(0.00, 0.00, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    [featuresVC didMoveToParentViewController:self];
}

@end
