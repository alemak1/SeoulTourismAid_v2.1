//
//  GeneralGameSceneController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "GeneralGameSceneController.h"
#import "KoreanLearningScene.h"
#import "Constants.h"

@interface GeneralGameSceneController ()


@property (readonly) SKView* skView;


@end


@implementation GeneralGameSceneController


SKView* _mainSkView;

-(void)viewWillLayoutSubviews{
    
    [self registerNotifications];
    
    SKScene* gameScene = [[KoreanLearningScene alloc] initWithSize:self.view.bounds.size];
    
    [self.skView presentScene:gameScene];
    
    
    
}



-(void)viewDidLoad{
    
}

-(SKView *)skView{
    
    
    if(_mainSkView == nil){
        
        _mainSkView = [[SKView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:_mainSkView];
    }
    
    return _mainSkView;
    
}

-(void)presentQuestionPromptViewController:(NSNotification*)notification{
    NSString* question = [notification.userInfo valueForKey:@"Question"];
    NSString* choice1 = [notification.userInfo valueForKey:@"Choice1"];
    NSString* choice2 = [notification.userInfo valueForKey:@"Choice2"];
    NSString* choice3 = [notification.userInfo valueForKey:@"Choice3"];
    NSString* choice4 = [notification.userInfo valueForKey:@"Choice4"];

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:question message:@"Choose From the Answer Choices Below:" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* choice1Action = [UIAlertAction actionWithTitle:@"(1)" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* choice2Action = [UIAlertAction actionWithTitle:@"(2)" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* choice3Action = [UIAlertAction actionWithTitle:@"(3)" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* choice4Action = [UIAlertAction actionWithTitle:@"(4)" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:choice1Action];
    [alertController addAction:choice2Action];
    [alertController addAction:choice3Action];
    [alertController addAction:choice4Action];
    
    
    [self showViewController:alertController sender:nil];

}

-(void)dealloc{
    [self removeNotifications];
}


#pragma mark ****** HELPER METHODS FOR REGISTERING AND REMOVING NOTIFICATIONS

-(void) registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentQuestionPromptViewController:) name:DID_ENCOUNTER_QUESTION_OBJECT_NOTIFICATION object:nil];
    
}

-(void)removeNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_ENCOUNTER_QUESTION_OBJECT_NOTIFICATION object:nil];
    
    
    
}

@end
