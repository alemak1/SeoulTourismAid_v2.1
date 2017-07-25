//
//  AcknowledgementsContainerController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "AcknowledgementsContainerController.h"
#import "AcknowledgementsIndexVC.h"


@interface AcknowledgementsContainerController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation AcknowledgementsContainerController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    /** Configure the scroll view **/
    
    [self.scrollView setDelegate:self];
    
     [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*0.90, CGRectGetHeight(self.scrollView.frame)*1.80)];
    
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
    
    
    /** Instantiate the feature view controller from the storyboard, add it as a child view controller, and add it view to the scroll view **/
    
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    
    AcknowledgementsIndexVC* acknowledgementIndexVC = [storyboardD instantiateViewControllerWithIdentifier:@"AcknowledgementsIndexVC"];
    
    [self addChildViewController:acknowledgementIndexVC];
    
    [self.scrollView addSubview:acknowledgementIndexVC.view];
    
    [acknowledgementIndexVC.view setFrame:CGRectMake(0.00, 0.00, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    [acknowledgementIndexVC didMoveToParentViewController:self];
    
   
    
}

@end
