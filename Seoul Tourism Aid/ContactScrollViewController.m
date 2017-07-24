//
//  ContactScrollViewController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactScrollViewController.h"


@interface ContactScrollViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation ContactScrollViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    /** Configure the scroll view **/
    
    [self.scrollView setDelegate:self];
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)*3.00)];

    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setAlwaysBounceVertical:NO];
    
    /** Instantiate the feature view controller from the storyboard, add it as a child view controller, and add it view to the scroll view **/
    
    UIStoryboard* mainStoryBOard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController* contactInfoController = [mainStoryBOard instantiateViewControllerWithIdentifier:@"ContactInfoController"];
    
    [self addChildViewController:contactInfoController];
    
    [self.scrollView addSubview:contactInfoController.view];
    
    [contactInfoController.view setFrame:CGRectMake(0.00, 0.00, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    [contactInfoController didMoveToParentViewController:self];
    
}





@end
