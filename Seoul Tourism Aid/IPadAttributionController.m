//
//  IPadAttributionController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPadAttributionController.h"
#import "UIColor+HelperMethods.h"

@interface IPadAttributionController ()



@property (weak, nonatomic) IBOutlet UIView *currentContainerView;
@property (weak, nonatomic) IBOutlet UIView *nextContainerView;
@property (readonly) UIView* currentCV;
@property (readonly) UIView* nextCV;

@property (readonly) NSArray<UIView*>* containerViews;
-(void)swapContainerViews;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentContainerCenterXConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextContainerCenterXConstraint;

@property (readonly) NSArray<UIViewController*>* childViewControllerArray;
@property (readonly) NSInteger numberOfChildViewControllers;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end




@implementation IPadAttributionController

@synthesize  containerViews = _containerViews;

@synthesize childViewControllerArray = _childViewControllerArray;
int _currentChildViewController = 0;


-(UIView *)currentCV{
    return [_containerViews firstObject];
}

-(UIView *)nextCV{
    return [_containerViews lastObject];
}

-(void)swapContainerViews{
    
    NSLog(@"Swapping container views...");
    
    _containerViews = nil;
    
    _containerViews = @[self.nextContainerView,self.currentContainerView];
    
}

-(NSArray<UIView *> *)containerViews{
    if(_containerViews == nil){
        _containerViews = @[self.currentContainerView,self.nextContainerView];
    }
    return _containerViews;
}


-(void)viewWillAppear:(BOOL)animated{
    
    _currentChildViewController = 0;
    
    [self.nextContainerView setAlpha:0.00];
    [self.currentContainerView setAlpha:1.00];
    
  
    
   
    
}

-(void)viewDidLoad{
    
    UIViewController* currentViewController = [self.childViewControllerArray objectAtIndex:_currentChildViewController];
    
    
    [self addChildViewController:currentViewController];
    
    [self.nextContainerView addSubview:currentViewController.view];
    
    currentViewController.view.frame = self.nextContainerView.bounds;
    
    [currentViewController didMoveToParentViewController:self];
    
    [self.titleLabel setText:@"Click the Arrow to See More..."];
    
}


- (IBAction)showNextViewController:(id)sender {
    
    self.currentContainerView.alpha = 1;
    self.nextContainerView.alpha = 0;

    UIViewController* currentChildViewController = [self.childViewControllerArray firstObject];
    
    [currentChildViewController removeFromParentViewController];
    
    _currentChildViewController++;
    
    if(_currentChildViewController >= self.numberOfChildViewControllers){
        _currentChildViewController = 0;
    }
    
    for(UIView*view in self.nextContainerView.subviews){
        [view removeFromSuperview];
    }
    
    currentChildViewController = nil;

    currentChildViewController = [self.childViewControllerArray objectAtIndex:_currentChildViewController];
    
    [self addChildViewController:currentChildViewController];
    
    [currentChildViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.nextContainerView addSubview:currentChildViewController.view];
    
    currentChildViewController.view.frame = self.nextContainerView.bounds;
    
    [currentChildViewController didMoveToParentViewController:self];
    
    [self updateTitleLabelText];
    
    [self animateContainerTransitions];
}



-(void)animateContainerTransitions{
    
    
    [UIView animateWithDuration:1.00 animations:^{
    
        self.currentContainerView.alpha = 0;
        self.nextContainerView.alpha = 1;
    
    } completion:nil];
}


-(void)updateTitleLabelText{
    
    switch (_currentChildViewController) {
        case 0:
            [self.titleLabel setText:@"Miscellaneous Info"];
            break;
        case 1:
            [self.titleLabel setText:@"Acknowledgements"];
            break;
        case 2:
            [self.titleLabel setText:@"App Information"];
            break;
        default:
            break;
    }
}

-(void)swapObjcPointerWithC:(void**) ptrA with:(void**)ptrB{
    
    void *temp = *ptrA;
    *ptrA = *ptrB;
    *ptrB = temp;
    
}


- (void)swapController:(void**)controller1 with:(void**)controller2
{
    void* swap = *controller2;
    *controller2 = *controller1;
    *controller1 = swap;
}

-(NSArray<UIViewController *> *)childViewControllerArray{
    
    if(_childViewControllerArray == nil){
        UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
        
        UIViewController* miscellaneousInfoController = [storyboardD instantiateViewControllerWithIdentifier:@"MiscellaneousInfoController"];
        
        UIViewController* acknowledgementsIndexController = [storyboardD instantiateViewControllerWithIdentifier:@"AcknowledgementsIndexVC"];
        
        UIViewController* appFeatureController = [storyboardD instantiateViewControllerWithIdentifier:@"AppFeatureController"];
        
        _childViewControllerArray = @[miscellaneousInfoController,acknowledgementsIndexController,appFeatureController];

    }
    return _childViewControllerArray;
}

-(NSInteger)numberOfChildViewControllers{
    return [_childViewControllerArray count];
}


@end
