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
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:gameQuestion.question message:@"Choose from the choices below:" preferredStyle:UIAlertControllerStyleAlert];
    
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
    
    [self archiveGameQuestionWithKey:kPen andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"펜" andWithChoice2:@"가방" andWithChoice3:@"소금" andWithChoice4:@"가격" andWithAnswer:1];
    
    [self archiveGameQuestionWithKey:kPencil andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"열쇠" andWithChoice2:@"연필" andWithChoice3:@"가격" andWithChoice4:@"소금" andWithAnswer:2];
    
    [self archiveGameQuestionWithKey:kBook andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가격" andWithChoice2:@"열쇠" andWithChoice3:@"식품" andWithChoice4:@"도서" andWithAnswer:4];
    
    [self archiveGameQuestionWithKey:kBag andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가방" andWithChoice2:@"가격" andWithChoice3:@"열쇠" andWithChoice4:@"돈" andWithAnswer:1];
    
     [self archiveGameQuestionWithKey:kFork andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가방" andWithChoice2:@"포크" andWithChoice3:@"가격" andWithChoice4:@"돈" andWithAnswer:2];
    
    [self archiveGameQuestionWithKey:kSalt andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가방" andWithChoice2:@"포크" andWithChoice3:@"소금" andWithChoice4:@"돈" andWithAnswer:3];
    
    [self archiveGameQuestionWithKey:kPepper andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가방" andWithChoice2:@"포크" andWithChoice3:@"소금" andWithChoice4:@"후추" andWithAnswer:4];
    
    [self archiveGameQuestionWithKey:kKeys andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가격" andWithChoice2:@"돈" andWithChoice3:@"열쇠" andWithChoice4:@"도서" andWithAnswer:3];
    
    [self archiveGameQuestionWithKey:kCoffee andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"가격" andWithChoice2:@"커피" andWithChoice3:@"열쇠" andWithChoice4:@"도서" andWithAnswer:2];
    
     [self archiveGameQuestionWithKey:kCompass andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"나침반" andWithChoice2:@"커피" andWithChoice3:@"열쇠" andWithChoice4:@"도서" andWithAnswer:1];
    
    
    [self archiveGameQuestionWithKey:kMoney andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"식품" andWithChoice2:@"돈" andWithChoice3:@"은행" andWithChoice4:@"가격" andWithAnswer:2];

    [self archiveGameQuestionWithKey:kBottle andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"난로" andWithChoice2:@"믹서기"  andWithChoice3:@"병" andWithChoice4:@"오븐" andWithAnswer:3];
    
     [self archiveGameQuestionWithKey:kFolder andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기"  andWithChoice2:@"폴더" andWithChoice3:@"병" andWithChoice4:@"오븐" andWithAnswer:2];
    
    [self archiveGameQuestionWithKey:kLaptop andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"맥북" andWithChoice2:@"폴더" andWithChoice3:@"병" andWithChoice4:@"믹서기"  andWithAnswer:1];
    

    [self archiveGameQuestionWithKey:kSpoon andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"맥북" andWithChoice2:@"폴더" andWithChoice3:@"병" andWithChoice4:@"숟가락" andWithAnswer:4];
    
    [self archiveGameQuestionWithKey:kBlender andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기" andWithChoice2:@"오븐" andWithChoice3:@"난로" andWithChoice4:@"마이크로파" andWithAnswer:1];
    
    
    
    [self archiveGameQuestionWithKey:kComputer andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기" andWithChoice2:@"컴퓨터" andWithChoice3:@"난로" andWithChoice4:@"마이크로파" andWithAnswer:2];
    
     [self archiveGameQuestionWithKey:kCellPhone andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기" andWithChoice2:@"컴퓨터" andWithChoice3:@"난로" andWithChoice4:@"휴대 전화" andWithAnswer:4];
    
     [self archiveGameQuestionWithKey:kBandaid andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기" andWithChoice2:@"밴드 원조" andWithChoice3:@"난로" andWithChoice4:@"휴대 전화" andWithAnswer:2];
    
    [self archiveGameQuestionWithKey:kToothBrush andWithQuestion:@"What is the Korean character for this object?" andWithChoice1:@"믹서기" andWithChoice2:@"밴드 원조" andWithChoice3:@"칫솔" andWithChoice4:@"휴대 전화" andWithAnswer:3];

}

-(void)archiveGameQuestionWithKey:(NSString*)archiverKey andWithQuestion:(NSString*)question andWithChoice1:(NSString*)choice1 andWithChoice2:(NSString*)choice2 andWithChoice3:(NSString*)choice3 andWithChoice4:(NSString*)choice4 andWithAnswer:(NSInteger)answer{
    
    GameQuestion* gameQuestion = [[GameQuestion alloc] initWithQuestion:question andWithChoice1:choice1 andWithChoice2:choice2 andWithChoice3:choice3 andWithChoice4:choice4 andWithAnswer:answer];
    
    NSData*gameQuestionData = [NSKeyedArchiver archivedDataWithRootObject:gameQuestion];
    
    [[NSUserDefaults standardUserDefaults] setObject:gameQuestionData forKey:archiverKey];
    
    
}


@end
