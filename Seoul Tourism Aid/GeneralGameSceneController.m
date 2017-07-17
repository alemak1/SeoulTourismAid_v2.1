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
#import "GameObjectArchiverKeys.h"

@interface GeneralGameSceneController ()

@property (readonly) SKView* skView;


@end


@implementation GeneralGameSceneController


SKView* _mainSkView;

-(void)viewWillLayoutSubviews{
    
    [self archiveGameQuestions];
    
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
    
    NSString* gameQuestionKey = [notification.userInfo valueForKey:@"nodeName"];
    
    NSData* gameQuestionData = [[NSUserDefaults standardUserDefaults] objectForKey:gameQuestionKey];
    
    GameQuestion* gameQuestion = [NSKeyedUnarchiver unarchiveObjectWithData:gameQuestionData];
    
    //TOOD: use gameQuestion to populate alert controller title, message, and choice fields
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:gameQuestion.question message:@"Choose From the Answer Choices Below:" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* choice1Action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"(1) %@",gameQuestion.choice1] style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
    
        
        if(gameQuestion.answer == 1){
            NSLog(@"You scored a point");
        }
    
    }];
    
    UIAlertAction* choice2Action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"(2) %@",gameQuestion.choice2] style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        
        if(gameQuestion.answer == 2){
            NSLog(@"You scored a point");

        }
        
    }];
    
    UIAlertAction* choice3Action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"(3) %@",gameQuestion.choice3] style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        
        if(gameQuestion.answer == 3){
            NSLog(@"You scored a point");

        }
        
    }];
    
    UIAlertAction* choice4Action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"(4) %@", gameQuestion.choice4] style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        
        if(gameQuestion.answer == 4){
            NSLog(@"You scored a point");

        }
        
    }];
    
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


-(void) archiveGameQuestions{
    
    [self archiveGameQuestionWithKey:kPen andWithQuestion:nil andWithChoice1:nil andWithChoice2:nil andWithChoice3:nil andWithChoice4:nil andWithAnswer:nil];
    
    [self archiveGameQuestionWithKey:kPencil andWithQuestion:nil andWithChoice1:nil andWithChoice2:nil andWithChoice3:nil andWithChoice4:nil andWithAnswer:nil];

    
}

-(void)archiveGameQuestionWithKey:(NSString*)archiverKey andWithQuestion:(NSString*)question andWithChoice1:(NSString*)choice1 andWithChoice2:(NSString*)choice2 andWithChoice3:(NSString*)choice3 andWithChoice4:(NSString*)choice4 andWithAnswer:(NSInteger)answer{
    
    GameQuestion* gameQuestion = [[GameQuestion alloc] initWithQuestion:archiverKey andWithChoice1:choice1 andWithChoice2:choice2 andWithChoice3:choice3 andWithChoice4:choice4 andWithAnswer:answer];
    
    NSData*gameQuestionData = [NSKeyedArchiver archivedDataWithRootObject:gameQuestion];
    
    [[NSUserDefaults standardUserDefaults] setObject:gameQuestionData forKey:kElephant];
    
    
}


@end
