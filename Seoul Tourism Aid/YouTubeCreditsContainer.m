//
//  YouTubeCreditsContainer.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTubeCreditsContainer.h"
#import "YouTubeCreditsController.h"

@interface YouTubeCreditsContainer () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation YouTubeCreditsContainer



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.scrollView setDelegate:self];
    
    
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [self.scrollView setDelegate:self];
    
    
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    /** Configure the scroll view **/
    
    [self.scrollView setDelegate:self];
    
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*0.95, CGRectGetHeight(self.scrollView.bounds)*2.0)];
    
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
    
    
    /** Instantiate the feature view controller from the storyboard, add it as a child view controller, and add it view to the scroll view **/
    
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    
    YouTubeCreditsController* youTubeCreditsController = [storyboardD instantiateViewControllerWithIdentifier:@"YouTubeCreditsController"];
    
    [self addChildViewController:youTubeCreditsController];
    
    [self.scrollView addSubview:youTubeCreditsController.view];
    
    [youTubeCreditsController.view setFrame:CGRectMake(0.00, 0.00, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    [youTubeCreditsController didMoveToParentViewController:self];
    
    
    
}

@end
