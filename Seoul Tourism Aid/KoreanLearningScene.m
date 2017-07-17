//
//  KoreanLearningScene.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import <CoreMotion/CoreMotion.h>
#import "KoreanLearningScene.h"
#import "Constants.h"
#import "GameQuestion.h"
#import "GameObjectArchiverKeys.h"

@interface KoreanLearningScene () <SKPhysicsContactDelegate>

typedef enum IconBitmask{
    PLAYER_BUNNY = 1,
    OBJECT_ICON = 2,
    ENEMY = 4
}IconBitmask;

@property SKSpriteNode* userBunny;

/** CoreMotion Properties **/

@property (readonly) CMMotionManager* motionManager;
@property (readonly) NSOperationQueue* operationQueue;
@property CMDeviceMotion* deviceMotion;


- (void(^)(CMDeviceMotion*,NSError*)) handler;

/** Computed, Helper Properties **/


@property (readonly) double pitch;
@property (readonly) double yaw;
@property (readonly) double roll;
@property (readonly) double xRotationRate;
@property (readonly) double yRotationRate;
@property (readonly) double zRotationRate;

@property (readonly) CGFloat playerVelocityDx;

/** UIElements **/

@property SKSpriteNode* mainMenuButton;
@property SKNode* optionsSelectionPanel;
@property SKNode* overlayNode;
@property SKNode* worldNode;

@property SKSpriteNode* restartButton;
@property SKSpriteNode* returnToMenuButton;
@property SKSpriteNode* returnToGameButton;
@property SKNode* scoreBoard;


@end

@implementation KoreanLearningScene

BOOL _notificationHasJustBeenSent = false;

CGFloat _lastUpdatedPlayerVelocity = 0.00;
NSTimeInterval _notificationDelayFrameCount = 0.00;
NSTimeInterval _notificationDelayTimeInterval = 3.00;
NSTimeInterval _lastUpdatedTime = 0.00;

int _playerScore = 0;

CMMotionManager* _mainMotionManager;
NSOperationQueue* _helperOperationQueue;



-(void)didMoveToView:(SKView *)view{
    
    
    _playerScore = 0;
   
    if([self.motionManager isDeviceMotionAvailable]){
        [self.motionManager setDeviceMotionUpdateInterval:1.00];
        [self.motionManager startDeviceMotionUpdatesToQueue:self.operationQueue withHandler:self.handler];
    }
    
    [self.physicsWorld setContactDelegate:self];
    
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [self configureWorldNode];
    
    [self configureBackgroundSceneAndIconNodes];
    
    [self configurePlayerBunny];
    
    [self configureOverlayNode];
    
    [self configureOverlayButtons];
    
    NSLog(@"Player bunny information: %@",[self.userBunny description]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerScore:) name:DID_SCORE_POINT_NOTIFICATION object:nil];
    
}

-(void)sceneDidLoad{
    
}




-(void)update:(NSTimeInterval)currentTime{
    
    NSTimeInterval frameCount = currentTime - _lastUpdatedTime;
    
    if(_notificationHasJustBeenSent){
        
        _notificationDelayFrameCount += frameCount;
        
        if(_notificationDelayFrameCount > _notificationDelayTimeInterval){
            
            _notificationHasJustBeenSent = false;
            
            _notificationDelayFrameCount = 0;
        }
        
    }
    
    
    _lastUpdatedTime = currentTime;
}



-(void)didEvaluateActions{
    
    BOOL currentPlayerMovementIsRight = self.playerVelocityDx > 10.0 ? YES : NO;
    BOOL lastPlayerMovementIsRight = _lastUpdatedPlayerVelocity > 10.0 ? YES: NO;
    
    BOOL currentPlayerMovementIsLeft = !(currentPlayerMovementIsRight);
    BOOL lastPlayerMovementIsLeft = !(lastPlayerMovementIsRight);
    
    
    if(currentPlayerMovementIsRight && !lastPlayerMovementIsRight){
        NSLog(@"Player is now moving right...");
        [self configureRightMovementAnimation];
    }
    
    if(currentPlayerMovementIsLeft && !lastPlayerMovementIsLeft){
        NSLog(@"Player is now moving left...");
        [self configureLeftMovementAnimation];
    }
    
    _lastUpdatedPlayerVelocity = self.playerVelocityDx;
}


-(void)didSimulatePhysics{
    
    CGVector horizontalMovementVector = [self getHorizontalImpulseForDeviceMotion];
    
    /** NSLog(@"The horizontal movement vector(dx) is: %f",horizontalMovementVector.dx); **/
    
    [self.userBunny.physicsBody applyForce:horizontalMovementVector];
    
    [self centerOnNode:self.userBunny];
}


-(void)centerOnNode:(SKNode*)node{
    CGPoint cameraPositionInScene = [self convertPoint:node.position fromNode:self.worldNode];
    
    self.worldNode.position = CGPointMake(self.worldNode.position.x-cameraPositionInScene.x, self.worldNode.position.y - cameraPositionInScene.y);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch*touch in touches) {
        
        CGPoint touchPos = [touch locationInNode:self.worldNode];
        
        if([self.userBunny containsPoint:touchPos]){
            if(fabs(self.userBunny.physicsBody.velocity.dy) <= 0.10){
                
                CGVector jumpImpulse = CGVectorMake(0.00, 700.0);
                [self.userBunny.physicsBody applyImpulse:jumpImpulse];
                
            }
            
        }
        
        touchPos = [touch locationInNode:self.overlayNode];
        
        if([self.mainMenuButton containsPoint:touchPos]){
            if(self.isPaused){
                
                SKLabelNode*label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Game Options"];
                
                [self.optionsSelectionPanel removeFromParent];
                
                [self setPaused:NO];
                
            } else {
                NSLog(@"Node at touch point is menu button...");
                
                
                SKLabelNode*label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Resume Game"];
                
                [self.optionsSelectionPanel moveToParent:self.overlayNode];
                
                [self.optionsSelectionPanel setPosition:CGPointMake(0.00, 0.00)];
                
                [self setPaused:YES];
                
                
            }
            
            return;
            
            
        }
        
        
        
        
        if(self.isPaused){
            
            
            if([self.returnToGameButton containsPoint:touchPos]){
                SKLabelNode*label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Game Options"];
                
                [self.optionsSelectionPanel removeFromParent];
                
                [self setPaused:NO];

            }
            
            if([self.returnToMenuButton containsPoint:touchPos]){
                
                
            }
            
            if([self.restartButton containsPoint:touchPos]){
                SKLabelNode*label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Game Options"];
                
                [self setPaused:YES];
                
                [self.optionsSelectionPanel removeFromParent];

                
                SKTransition* transition = [SKTransition crossFadeWithDuration:0.50];
                
                KoreanLearningScene* newScene = [[KoreanLearningScene alloc] initWithSize:self.view.bounds.size];
                
                newScene.hasRestarted = true;
                
                [self.view presentScene:newScene transition:transition];
                
            }
            
            return;
        }
        
       
        
        
        
       
    }
    
    
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_SCORE_POINT_NOTIFICATION object:nil];
}

-(void (^)(CMDeviceMotion *, NSError *))handler{
    
    return ^(CMDeviceMotion*motion,NSError*error){
        
        if(error){
            NSLog(@"Error: an error occurred while getting device motion data, error description: %@",[error localizedDescription]);
            return;
        }
        
        if(!motion){
            NSLog(@"Error: no motion data available");
            return;
        } else {
            
            self.deviceMotion = motion;
            
        }
        
        
    };
}


-(CMMotionManager *)motionManager{
    
    if(_mainMotionManager == nil){
        _mainMotionManager = [[CMMotionManager alloc] init];
    }
    
    return _mainMotionManager;
}

-(NSOperationQueue *)operationQueue{
    
    if(_helperOperationQueue == nil){
        _helperOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _helperOperationQueue;
}

-(void)motionDebugInfo:(CMDeviceMotion*)deviceMotion{
    
    double pitch = [deviceMotion attitude].pitch;
    double yaw = [deviceMotion attitude].yaw;
    double roll = [deviceMotion attitude].roll;
    
    double xRotationRate = [deviceMotion rotationRate].x;
    double yRotationRate = [deviceMotion rotationRate].y;
    double zRotationRate = [deviceMotion rotationRate].z;
    
    
    NSLog(@"The device has registered a pitch of %f, a yaw of %f, a roll of %f, an xRotation rate of %f, a yRotationRate of %f, and a zRotationRate of %f",pitch,yaw,roll,xRotationRate,yRotationRate,zRotationRate);
    
}

-(CGVector)getHorizontalImpulseForDeviceMotion{
    
    double dx = 0;
    
    if([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait){
        if(self.roll > M_PI/12 /**&& self.xRotationRate > 0**/){
            
            
            /** NSLog(@"Roll is greater than zero"); **/
            double absVal = fabs(self.roll-M_PI/12)/(2*M_PI);
            dx = 310.00*(1-absVal);
        }
        
        if(self.roll < -M_PI/12 /**&& self.xRotationRate < 0**/){
            
            /** NSLog(@"Roll is less than zero"); **/
            double absVal = fabs(self.roll+M_PI/12)/(2*M_PI);
            dx = -310.00*(1-absVal);
            
        }
        
        
    }
    
    
    if([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight){
        
        if(self.pitch > 0 && self.yRotationRate > 0){
            
            /** NSLog(@"Pitch is greater than zero"); **/
            
            dx = 260.00;
            
        }
        
        if(self.pitch < 0 && self.yRotationRate < 0){
            
            /** NSLog(@"Pitch is less than zero"); **/
            
            dx = -260.00;
            
        }
        
    }
    
    return CGVectorMake(dx,0.00);
}


/** Convenience properties for getting Core Motion Data **/

-(double)pitch{
    return [self.deviceMotion attitude].pitch;
    
}

-(double)roll{
    return [self.deviceMotion attitude].roll;
    
}

-(double)yaw{
    return [self.deviceMotion attitude].yaw;
    
}


-(double)xRotationRate{
    return [self.deviceMotion rotationRate].x;
    
}

-(double)yRotationRate{
    return [self.deviceMotion rotationRate].y;
    
}

-(double)zRotation{
    return [self.deviceMotion rotationRate].z;
    
    
}


-(CGFloat)playerVelocityDx{
    
    return self.userBunny.physicsBody.velocity.dx;
    
}


+(NSSet<NSString *> *)keyPathsForValuesAffectingPlayerVelocityDx{
    
    return [NSSet setWithObjects:@"self.userBunny.physicsBody.velocity.dx", nil];
}

#pragma mark ****** HELPER FUNCTIONS FOR CONFIGURING THE SCENE

-(void) configureBackgroundSceneAndIconNodes{
    
    SKNode* backgroundScene = [SKNode nodeWithFileNamed:@"KoreanLearningSceneBackground"];
    SKNode* backgroundNode = [backgroundScene childNodeWithName:@"RootNode"];
    [backgroundNode moveToParent:self.worldNode];
    
    
    
    for(__strong SKNode*node in backgroundNode.children){
        if([node.name containsString:@"object"]){
            
            int32_t totalPossibleGameObjects = (int32_t)[GAME_OBJECTS_ARRAY count];
            
            NSUInteger randomNameIndex = arc4random_uniform(totalPossibleGameObjects);
            
            NSString* randomName = [GAME_OBJECTS_ARRAY objectAtIndex:randomNameIndex];
            
            SKTexture* objectTexture = [SKTexture textureWithImageNamed:randomName];
            
            SKSpriteNode* objectNode = [SKSpriteNode spriteNodeWithTexture:objectTexture];
            
            SKPhysicsBody* objectPB = [SKPhysicsBody bodyWithTexture:objectTexture size:objectTexture.size];
            
            [objectNode setPhysicsBody: objectPB];
            
            [objectNode setName:randomName];
            
            [objectNode setPosition:CGPointMake(node.position.x, node.position.y)];
            
            
            [self.worldNode addChild:objectNode];
            
            NSLog(@"Configuring bitmaks for object with node name: %@",node.name);
            [self configureBitmasksForObjectIcon:objectNode];
            
        }
    }
    

    CGFloat posOffset = [UIScreen mainScreen].bounds.size.height*0.00;
    [backgroundNode setPosition:CGPointMake(0.0, posOffset)];
    [backgroundNode setScale:0.50];
    [backgroundNode setZPosition:-1];
    
}

-(void)showIconDebugInfo{
    
    for(SKSpriteNode*node in self.children){
        if([node.name containsString:@"Object"]){
            
            
        }
    }
    
}

-(void) configurePlayerBunny{
    
    
    SKTexture* bunnyTexture = [SKTexture textureWithImageNamed:@"bunny2_walk2"];
    
    self.userBunny = [[SKSpriteNode alloc] initWithTexture:bunnyTexture];
    [self.userBunny setZPosition:10.0];
    
    self.userBunny.physicsBody = [SKPhysicsBody bodyWithTexture:bunnyTexture size:[bunnyTexture size]];
    [self.userBunny setScale:0.50];
    
    [self.userBunny.physicsBody setAffectedByGravity:YES];
    [self.userBunny.physicsBody setLinearDamping:0.00];
    [self.userBunny.physicsBody setAllowsRotation:NO];
    [self.userBunny.physicsBody setDynamic:YES];
    [self configurePlayerBunnyBitmask];
    
    SKAction* walkAction = [SKAction animateWithTextures:[NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"bunny2_walk2"],[SKTexture textureWithImageNamed:@"bunny2_walk1"], nil] timePerFrame:0.20];
    
    SKAction* walkingAnimation = [SKAction repeatActionForever:walkAction];
    
    [self.userBunny runAction:walkingAnimation withKey:@"walkingAnimation"];
    
    
    [self.worldNode addChild:self.userBunny];
    
    
    
}


-(void)configureWorldNode{
    self.worldNode = [[SKNode alloc] init];
    [self addChild:self.worldNode];
    [self.worldNode setZPosition:-5];
}

-(void)configureOverlayNode{
    
    self.overlayNode = [[SKNode alloc] init];
    [self addChild:self.overlayNode];
    [self.overlayNode setPosition:CGPointMake(0.00, 0.00)];
    [self.overlayNode setZPosition:20.0];
    
}

-(void)configureOverlayButtons{
    
    SKNode* overlayCollection = [SKNode nodeWithFileNamed:@"EntryUIOverlay"];
    
    
    self.mainMenuButton = (SKSpriteNode*)[overlayCollection childNodeWithName:@"MainMenuButton"];
    
    self.optionsSelectionPanel = [overlayCollection childNodeWithName:@"GameOptionsMenu"];
    NSLog(@"Game Options Menu is: %@",[self.optionsSelectionPanel description]);
    
    [self configureOptionsPanelButtons];
    
    
    [self.mainMenuButton moveToParent:self.overlayNode];
    
    CGFloat yPosOffset = [UIScreen mainScreen].bounds.size.height*0.40;
    
    [self.mainMenuButton setPosition:CGPointMake(0.00, -yPosOffset)];
    
    
    
    CGFloat yPosOffsetScoreboard = [UIScreen mainScreen].bounds.size.height*0.30;
    
    self.scoreBoard = [overlayCollection childNodeWithName:@"ScoreBoard"];
    
    [self.scoreBoard moveToParent:self.overlayNode];
    
    [self.scoreBoard setPosition:CGPointMake(0.00, yPosOffsetScoreboard)];
    
    if(!self.hasRestarted){
        SKNode* introLabel = [overlayCollection childNodeWithName:@"IntroLabel"];
    
        [introLabel moveToParent:self.overlayNode];
    
        [introLabel setPosition:CGPointMake(0.00, 0.00)];
    
        SKAction* labelAction = [SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:4.00],[SKAction runBlock:^{
    
        [introLabel removeFromParent];
        
        }], nil]];
    
        [introLabel runAction:labelAction];
    }
}


-(void)configurePlayerBunnyBitmask{
    [self.userBunny.physicsBody setCategoryBitMask:PLAYER_BUNNY];
    
    u_int32_t contactBitMask = OBJECT_ICON | ENEMY;
    
    [self.userBunny.physicsBody setContactTestBitMask:contactBitMask];
}


-(void)configureRightMovementAnimation{
    
    [self.userBunny removeActionForKey:@"walkingAnimation"];
    
    SKAction* walkAction = [SKAction animateWithTextures:[NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"bunny2_walk2"],[SKTexture textureWithImageNamed:@"bunny2_walk1"], nil] timePerFrame:0.20];
    
    SKAction* walkingAnimation = [SKAction repeatActionForever:walkAction];
    
    [self.userBunny runAction:walkingAnimation withKey:@"walkingAnimation"];
    
}


-(void)configureLeftMovementAnimation{
    
    [self.userBunny removeActionForKey:@"walkingAnimation"];
    
    SKAction* walkAction = [SKAction animateWithTextures:[NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"bunny2_walk2_left"],[SKTexture textureWithImageNamed:@"bunny2_walk1_left"], nil] timePerFrame:0.20];
    
    SKAction* walkingAnimation = [SKAction repeatActionForever:walkAction];
    
    [self.userBunny runAction:walkingAnimation withKey:@"walkingAnimation"];
    
    
    
}

-(void)configureBitmasksForObjectIcon:(SKSpriteNode*)objectNode{
    [objectNode.physicsBody setAffectedByGravity:YES];
    [objectNode.physicsBody setCategoryBitMask:OBJECT_ICON];
    [objectNode.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
}

-(void)configureOptionsPanelButtons{
    
    self.returnToGameButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"BackToGameButton"];
    self.returnToMenuButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"AppMainMenuButton"];
    self.restartButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"RestartButton"];
    
    [self showUIButtonDebugInfo];
   
}


-(void) showUIButtonDebugInfo{
    NSLog(@"The Restart Button was loaded with info: %@",[self.restartButton description]);
    
    NSLog(@"The Return to Main Menu Button was loaded with info: %@",[self.returnToMenuButton description]);
    
    
    NSLog(@"The Return to Game  Button was loaded with info: %@",[self.returnToGameButton description]);
   
}



#pragma makr SKPHYSICS CONTACT DELEGATE METHOD

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* bodyA = contact.bodyA;
    SKPhysicsBody* bodyB = contact.bodyB;
    
    SKPhysicsBody* otherBody = bodyA.categoryBitMask == PLAYER_BUNNY ? bodyB : bodyA;
    SKSpriteNode* otherBodyNode = (SKSpriteNode*)otherBody.node;
    
    IconBitmask otherBody_bitmask = otherBody.categoryBitMask;
    
    if(_notificationHasJustBeenSent){
        return;
    }
    
    switch (otherBody_bitmask) {
        case OBJECT_ICON:
            [self handleContactForNode:otherBodyNode];
            break;
        case ENEMY:
            break;
        default:
            break;
    }
    
    _notificationHasJustBeenSent = true;
    
}

-(void)handleContactForNode:(SKSpriteNode*)otherBodyNode{
    
    [self showQuestionInformationForObject:otherBodyNode];
    [self postQuestionObjectNotificationForObjectNode:otherBodyNode];
    _notificationHasJustBeenSent = true;
    
    [otherBodyNode runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:_notificationDelayTimeInterval-0.50], [SKAction runBlock:^{
        
        [otherBodyNode removeFromParent];
        
    }],nil]]];
}


-(void)postQuestionObjectNotificationForObjectNode:(SKSpriteNode*)objectNode{
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:objectNode.name,@"nodeName", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ENCOUNTER_QUESTION_OBJECT_NOTIFICATION object:nil userInfo:userInfo];
    
}

-(void)showQuestionInformationForObject:(SKSpriteNode*)node{
    
    NSString* question = [node.userData valueForKey:@"Question"];
    NSString* choice1 = [node.userData valueForKey:@"Choice1"];
    NSString* choice2 = [node.userData valueForKey:@"Choice2"];
    NSString* choice3 = [node.userData valueForKey:@"Choice3"];
    NSString* choice4 = [node.userData valueForKey:@"Choice4"];
    NSInteger answer = [[node.userData valueForKey:@"Answer"] integerValue];
    
    NSLog(@"Question: %@, Choice (1): %@, Choice (2): %@, Choice (3): %@, Choice (4): %@, Answer: %ld",question,choice1,choice2,choice3,choice4,answer);



}


-(void)updatePlayerScore:(NSNotification*)notification{
    _playerScore += 1;
    
    SKSpriteNode* scoreIcon = (SKSpriteNode*)[self.scoreBoard childNodeWithName:@"NumberIcon"];
    
    NSString* textureName = [NSString stringWithFormat:@"number%d",_playerScore];
    
    [scoreIcon setTexture:[SKTexture textureWithImageNamed:textureName]];
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end


