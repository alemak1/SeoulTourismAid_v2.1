//
//  EntryGameScene.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "EntryGameScene.h"
#import "Constants.h"

@interface EntryGameScene () <SKPhysicsContactDelegate>

typedef enum IconBitmask{
    PLAYER_BUNNY = 1,
    CHAT_ICON = 2,
    WEATHER_ICON = 4,
    PAINTING_ICON = 8,
    TV_ICON = 16,
    TEMPLE_ICON = 32,
    COMPASS_ICON = 64,
    INFORMATION_ICON = 128,
    SHOPPING_ICON =  256
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

/** References to the Option Icons **/

@property SKSpriteNode* chatIcon;
@property SKSpriteNode* weatherIcon;
@property SKSpriteNode* templeIcon;
@property SKSpriteNode* informationIcon;
@property SKSpriteNode* shoppingIcon;
@property SKSpriteNode* compassIcon;
@property SKSpriteNode* tvIcon;
@property SKSpriteNode* paintingIcon;

/** UIElements **/

@property SKSpriteNode* mainMenuButton;
@property SKNode* optionsSelectionPanel;
@property SKNode* overlayNode;
@property SKNode* worldNode;

@property SKSpriteNode* imageGalleryButton;
@property SKSpriteNode* youTubeVideoButton;
@property SKSpriteNode* touristSiteInfoButton;
@property SKSpriteNode* appInformationButton;
@property SKSpriteNode* bunnyGameButton;
@property SKSpriteNode* productInfoButton;
@property SKSpriteNode* languageHelpButton;
@property SKSpriteNode* navigationAidButton;
@property SKSpriteNode* backToBunnySelectionButton;
@property SKSpriteNode* weatherForecastButton;
@property SKSpriteNode* regionMonitoringButton;




@end

@implementation EntryGameScene

BOOL _gameIsPaused = false;
BOOL _mainMenuIsActive = false;
BOOL _notificationHasBeenSent = false;

CGFloat _lastPlayerVelocity = 0.00;
NSTimeInterval _notificationDelayCount = 0.00;
NSTimeInterval _notificationDelayInterval = 5.00;

NSTimeInterval _lastUpdateTime = 0.00;

CMMotionManager* _motionManager;
NSOperationQueue* _operationQueue;

-(void)sceneDidLoad{

    
    if([self.motionManager isDeviceMotionAvailable]){
        [self.motionManager setDeviceMotionUpdateInterval:1.00];
        [self.motionManager startDeviceMotionUpdatesToQueue:self.operationQueue withHandler:self.handler];
    }
    
    _gameIsPaused = false;
    
    [self.physicsWorld setContactDelegate:self];

    [self configureWorldNode];
    
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [self configureBackgroundSceneAndIconNodes];
    
    [self configurePlayerBunny];

    [self configureOverlayNode];
    
    [self configureOverlayButtons];

    [self.worldNode setScale:0.50];
    [self.overlayNode setScale:0.50];
}




-(void)update:(NSTimeInterval)currentTime{
    
    NSTimeInterval frameCount = currentTime - _lastUpdateTime;
    
    if(_notificationHasBeenSent){
        
        _notificationDelayCount += frameCount;
        
        if(_notificationDelayCount > _notificationDelayInterval){
            
            _notificationHasBeenSent = false;

            _notificationDelayCount = 0;
        }
        
    }
    
    
    _lastUpdateTime = currentTime;
}



-(void)didEvaluateActions{
    
    BOOL currentPlayerMovementIsRight = self.playerVelocityDx > 10.0 ? YES : NO;
    BOOL lastPlayerMovementIsRight = _lastPlayerVelocity > 10.0 ? YES: NO;
    
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
    
    _lastPlayerVelocity = self.playerVelocityDx;
}


-(void)didSimulatePhysics{
    
   CGVector horizontalMovementVector = [self getHorizontalImpulseForDeviceMotion];
    
   /** NSLog(@"The horizontal movement vector(dx) is: %f",horizontalMovementVector.dx); **/
    
    [self.userBunny.physicsBody applyForce:horizontalMovementVector];
    
    [self centerOnNode:self.userBunny];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch*touch in touches) {
        
        
        CGPoint touchPos = [touch locationInNode:self.worldNode];
        
        
        if([self.userBunny containsPoint:touchPos] && !_gameIsPaused){
            if(fabs(self.userBunny.physicsBody.velocity.dy) <= 0.10){
                    
                CGVector jumpImpulse = CGVectorMake(0.00, 700.0);
                [self.userBunny.physicsBody applyImpulse:jumpImpulse];
                    
            }
            return;
        }
        
        
        
        touchPos = [touch locationInNode:self.overlayNode];
        
        
        if([self.mainMenuButton containsPoint:touchPos]){
            
            if(_mainMenuIsActive){
                
                [self setPaused:NO];
                
                SKLabelNode* label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Main Menu"];
                
                [self.optionsSelectionPanel removeFromParent];
                
                _mainMenuIsActive = false;
                
                _gameIsPaused = false;
                
            } else {
                NSLog(@"Node at touch point is menu button...");
                
                [self.optionsSelectionPanel moveToParent:self.overlayNode];
                
                [self setPaused:YES];
                
                SKLabelNode* label = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
                
                [label setText:@"Back to Bunny Selector"];
                
                _mainMenuIsActive = true;
                
                _gameIsPaused = true;
                
            }
           
            return;
        }
        
        /** Weather Forecast Button **/
        
        if([self.weatherForecastButton containsPoint:touchPos]){
            
            NSLog(@"Go to weather forecast controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_WEATHER_INFO_NOTIFICATION object:nil];

            
            return;
        }
        
        
        /** YouTube Video Button **/
        
        if([self.youTubeVideoButton containsPoint:touchPos]){
            
            NSLog(@"Go to YouTube Video controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_YOUTUBE_VIDEO_NOTIFICATION object:nil];
            
            return;
        }
        
        /** Bunny Game  Button **/
        
        if([self.bunnyGameButton containsPoint:touchPos]){
            
            NSLog(@"Go to Bunny Game controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_BUNNY_GAME_NOTIFICATION object:nil];

            
            return;
        }
        
        /** Product Info  Button **/
        
        if([self.productInfoButton containsPoint:touchPos]){
            
            NSLog(@"Go to Product Info controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_PRODUCT_INFO_NOTIFICATION object:nil];

            
            return;
        }
        
        
        /** App Info Controller  Button **/
        
        if([self.appInformationButton containsPoint:touchPos]){
            
            NSLog(@"Go to App Info controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_APP_INFO_NOTIFICATION object:nil];

            
            
            return;
        }
        
        
        /** Montiored Region  Button **/
        
        if([self.regionMonitoringButton containsPoint:touchPos]){
            
            NSLog(@"Go to Region Monitoring Info controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_MONITORED_REGIONS_NOTIFICATION object:nil];

            
            return;
        }
        
        /** Navigation Aid Info  Button **/
        
        if([self.navigationAidButton containsPoint:touchPos]){
            
            NSLog(@"Go to Navigation Info controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_NAVIGATION_AID_NOTIFICATION object:nil];

            
            return;
        }
        
        /** Tourist Site Info  Button **/
        
        if([self.touristSiteInfoButton containsPoint:touchPos]){
            
            NSLog(@"Go to Tourist Site Info controller...");
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_TOURISM_SITE_INFO_NOTIFICATION object:nil];

            
            return;
        }
        
        /** Image Gallery  Button **/
        
        if([self.imageGalleryButton containsPoint:touchPos]){
            
            NSLog(@"Go to Image Gallery Info controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_IMAGE_GALLERY_NOTIFICATION object:nil];
            
            
            return;
        }
        
        
        /** Language Help  Button **/
        
        if([self.languageHelpButton containsPoint:touchPos]){
            
            NSLog(@"Go to Language Help  controller...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_KOREAN_AUDIO_NOTIFICATION object:nil];

            
            
            return;
        }
        
        
        /** Back to Bunny Selector Button **/

        
        if([self.backToBunnySelectionButton containsPoint:touchPos]){
            NSLog(@"Node at touch point is menu button...");
            
            [self.optionsSelectionPanel removeFromParent];
            
            [self setPaused:NO];
            
            _gameIsPaused = false;
            
            SKLabelNode* mainMenuText = (SKLabelNode*)[self.mainMenuButton childNodeWithName:@"MainMenuText"];
            
            [mainMenuText setText:@"Main Menu"];
            
            return;
        }
        
        
        
        
        
        
    }
    
   
    
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
    
    if(_motionManager == nil){
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    return _motionManager;
}

-(NSOperationQueue *)operationQueue{
    
    if(_operationQueue == nil){
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _operationQueue;
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
    
    SKNode* backgroundScene = [SKNode nodeWithFileNamed:@"EntryGameSceneBackground"];
    SKNode* backgroundNode = [backgroundScene childNodeWithName:@"RootNode"];
    [backgroundNode moveToParent:self.worldNode];
    
    self.chatIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"ChatIcon"];
    [self.chatIcon.physicsBody setCategoryBitMask:2];
    
    self.weatherIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"WeatherIcon"];
    self.templeIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"TempleIcon"];
    self.informationIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"InformationIcon"];
    self.shoppingIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"ShoppingIcon"];
    self.compassIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"CompassIcon"];
    self.tvIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"TVIcon"];
    self.paintingIcon = (SKSpriteNode*)[backgroundNode childNodeWithName:@"PaintingIcon"];
    
    [self configureBitmasksForIcons];
    
    CGFloat posOffset = -self.view.bounds.size.height*0.80;
    [backgroundNode setPosition:CGPointMake(0.0, posOffset)];
    [backgroundNode setScale:0.50];
    [backgroundNode setZPosition:5.00];
    
}



-(void)showIconDebugInfo{
    NSLog(@"ChatIcon successfully allocated and initialized with info: %@",[self.chatIcon description]);
    
    NSLog(@"WeatherIcon successfully allocated and initialized with info: %@",[self.weatherIcon description]);
    
    NSLog(@"TempleIcon successfully allocated and initialized with info: %@",[self.templeIcon description]);
    
    NSLog(@"InformationIcon successfully allocated and initialized with info: %@",[self.informationIcon description]);
    
    NSLog(@"ShoppingIcon successfully allocated and initialized with info: %@",[self.shoppingIcon description]);
    
    NSLog(@"TVIcon successfully allocated and initialized with info: %@",[self.tvIcon description]);

    
    NSLog(@"PaintingIcon successfully allocated and initialized with info: %@",[self.paintingIcon description]);

    NSLog(@"CompassIcon successfully allocated and initialized with info: %@",[self.compassIcon description]);

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
    [self.worldNode setPosition:CGPointMake(0.00, 0.00)];
    [self addChild:self.worldNode];

}

-(void)configureOverlayNode{
    
    self.overlayNode = [[SKNode alloc] init];
    [self addChild:self.overlayNode];
    [self.overlayNode setPosition:CGPointMake(0.00, 0.00)];
    [self.overlayNode setZPosition:20.0];
}

-(void) configureOverlayButtons{
    
    SKNode* overlayCollection = [SKNode nodeWithFileNamed:@"EntryUIOverlay"];
    self.mainMenuButton = (SKSpriteNode*)[overlayCollection childNodeWithName:@"MainMenuButton"];
    
    self.optionsSelectionPanel = [overlayCollection childNodeWithName:@"RootNode"];
    
    [self configureOptionsPanelButtons];
        
    [self.mainMenuButton moveToParent:self.overlayNode];
    
    CGFloat yPos = -[UIScreen mainScreen].bounds.size.height*0.30;
    CGFloat xPos = [UIScreen mainScreen].bounds.size.width*0.30;
    
    [self.mainMenuButton setPosition:CGPointMake(xPos, yPos)];
    
}


-(void)configurePlayerBunnyBitmask{
    [self.userBunny.physicsBody setCategoryBitMask:PLAYER_BUNNY];
    
    u_int32_t contactBitMask = CHAT_ICON | WEATHER_ICON | PAINTING_ICON | TV_ICON | TEMPLE_ICON | COMPASS_ICON | SHOPPING_ICON | INFORMATION_ICON;
    
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

-(void)configureBitmasksForIcons{
    [self.paintingIcon.physicsBody setCategoryBitMask:PAINTING_ICON];
    [self.paintingIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.templeIcon.physicsBody setCategoryBitMask:TEMPLE_ICON];
    [self.templeIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.tvIcon.physicsBody setCategoryBitMask:TV_ICON];
    [self.tvIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.chatIcon.physicsBody setCategoryBitMask:CHAT_ICON];
    [self.chatIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.weatherIcon.physicsBody setCategoryBitMask:WEATHER_ICON];
    [self.weatherIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.templeIcon.physicsBody setCategoryBitMask:TEMPLE_ICON];
    [self.templeIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.compassIcon.physicsBody setCategoryBitMask:COMPASS_ICON];
    [self.compassIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.shoppingIcon.physicsBody setCategoryBitMask:SHOPPING_ICON];
    [self.shoppingIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
    [self.informationIcon.physicsBody setCategoryBitMask:INFORMATION_ICON];
    [self.informationIcon.physicsBody setContactTestBitMask:PLAYER_BUNNY];
    
}


-(void)configureOptionsPanelButtons{
    
    self.imageGalleryButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"ImageGalleryOption"];
    self.youTubeVideoButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"TourismVideoOption"];
    self.touristSiteInfoButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"TouristSiteOption"];
    self.appInformationButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"AppInformationOption"];
    self.bunnyGameButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"BunnyGameOption"];
    self.productInfoButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"ProductPriceOption"];
    self.languageHelpButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"LanguageHelpOption"];
    self.navigationAidButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"NavigationAidOption"];
    self.backToBunnySelectionButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"BackToBunnySelectorOption"];
    self.weatherForecastButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"WeatherOption"];
    self.regionMonitoringButton = (SKSpriteNode*)[self.optionsSelectionPanel childNodeWithName:@"RegionMonitoringOption"];
}

-(void)centerOnNode:(SKNode*)node{
    CGPoint cameraPositionInScene = [self convertPoint:node.position fromNode:self.worldNode];
    
    self.worldNode.position = CGPointMake(self.worldNode.position.x-cameraPositionInScene.x, self.worldNode.position.y - cameraPositionInScene.y);
}





#pragma makr SKPHYSICS CONTACT DELEGATE METHOD

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* bodyA = contact.bodyA;
    SKPhysicsBody* bodyB = contact.bodyB;
    
    SKPhysicsBody* otherBody = bodyA.categoryBitMask == PLAYER_BUNNY ? bodyB : bodyA;
    
    IconBitmask otherBody_bitmask = otherBody.categoryBitMask;
    
    if(_notificationHasBeenSent){
        return;
    }
    
    switch (otherBody_bitmask) {
        case CHAT_ICON:
            NSLog(@"Player contacted chat icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_KOREAN_AUDIO_NOTIFICATION object:nil];
            break;
        case WEATHER_ICON:
            NSLog(@"Player contacted weather icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_WEATHER_INFO_NOTIFICATION object:nil];
            break;
        case PAINTING_ICON:
            NSLog(@"Player contacted painting icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_IMAGE_GALLERY_NOTIFICATION object:nil];
            break;
        case TEMPLE_ICON:
            NSLog(@"Player contacted temple icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_TOURISM_SITE_INFO_NOTIFICATION object:nil];
            break;
        case TV_ICON:
            NSLog(@"Player contacted tv icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_YOUTUBE_VIDEO_NOTIFICATION object:nil];
            break;
        case INFORMATION_ICON:
            NSLog(@"Player contacted information icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_APP_INFO_NOTIFICATION object:nil];
            break;
        case SHOPPING_ICON:
            NSLog(@"Player contacted shopping icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_PRODUCT_INFO_NOTIFICATION object:nil];
            break;
        case COMPASS_ICON:
            NSLog(@"Player contacted compass icon");
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_NAVIGATION_AID_NOTIFICATION object:nil];
            break;
        default:
            break;
    }
    
    _notificationHasBeenSent = true;
    
}



@end
