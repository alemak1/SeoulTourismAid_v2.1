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
#import "GameQuestion.h"

@interface GeneralGameSceneController ()

@property (readonly) SKView* skView;


@end


@implementation GeneralGameSceneController


SKView* _mainSkView;

-(void)viewWillLayoutSubviews{
    
    
    GameQuestion* gameQuestion1 = [[GameQuestion alloc] initWithQuestion:@"What is the Korean word for this?" andWithChoice1:@"코끼리" andWithChoice2:@"사자" andWithChoice3:@"고양이" andWithChoice4:@"개" andWithAnswer:1];
    
    NSData*gameQuestionData = [NSKeyedArchiver archivedDataWithRootObject:gameQuestion1];
    [[NSUserDefaults standardUserDefaults] setObject:gameQuestionData forKey:@"gameQuestionData"];
    
    [self registerNotifications];
    
    [self startGame];
    
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

-(void)startGame{
    
    SKScene* gameScene = [[KoreanLearningScene alloc] initWithSize:self.view.bounds.size];
    
    [self.skView presentScene:gameScene];
    
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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentQuestionPromptViewController:) name:DID_REQUEST_GAME_RESTART_NOTIFICATION object:nil];
    
}

-(void)removeNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_ENCOUNTER_QUESTION_OBJECT_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_GAME_RESTART_NOTIFICATION object:nil];

    
}

@end
