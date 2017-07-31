//
//  MainVideoPreviewController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainVideoPreviewController.h"
#import "SeoulVideoCollectionViewController.h"

@interface MainVideoPreviewController ()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *topMiddleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomMiddleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;



@property (weak, nonatomic) IBOutlet UIView *topContainerView;

@property (weak, nonatomic) IBOutlet UIView *topMiddleContainerView;

@property (weak, nonatomic) IBOutlet UIView *bottomMiddleContainerView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;



@end





@implementation MainVideoPreviewController

-(void)viewDidLoad{
    
    [self.topLabel setText:@"Explore Seoul"];
    [self.topMiddleLabel setText:@"Explore Korea"];
    
    [self.bottomMiddleLabel setText:@"Korean Food"];
    
    [self.bottomLabel setText:@"Age of Imagination"];



}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"embedSeg1"]){
        NSLog(@"Preparing segue with identifier %@",segue.identifier);
        
        SeoulVideoCollectionViewController* destinationController = (SeoulVideoCollectionViewController*)segue.destinationViewController;
        
        destinationController.currentVideoSection = 0;
    }
    
    if([segue.identifier isEqualToString:@"embedSeg2"]){
        NSLog(@"Preparing segue with identifier %@",segue.identifier);

           SeoulVideoCollectionViewController* destinationController = (SeoulVideoCollectionViewController*)segue.destinationViewController;
        destinationController.currentVideoSection = 1;
        
    }
    
    if([segue.identifier isEqualToString:@"embedSeg3"]){
        NSLog(@"Preparing segue with identifier %@",segue.identifier);

           SeoulVideoCollectionViewController* destinationController = (SeoulVideoCollectionViewController*)segue.destinationViewController;
        destinationController.currentVideoSection = 2;
        
    }
    
    if([segue.identifier isEqualToString:@"embedSeg4"]){
        NSLog(@"Preparing segue with identifier %@",segue.identifier);

           SeoulVideoCollectionViewController* destinationController = (SeoulVideoCollectionViewController*)segue.destinationViewController;
        
        destinationController.currentVideoSection = 3;
        
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskAll;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationPortrait;
    }
    
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        
    }
    
    return YES;
}

@end
