//
//  SKViewCell.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "SKViewCell.h"



@interface SKViewCell ()

@property IBOutlet SKView* skView;


@end



@implementation SKViewCell

-(void)setSceneOption:(SCENE_OPTION)newSceneOption{
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:170.0/255.0 green:238.0/255.0 blue:236.0/255.0 alpha:1.00]];
    
    [self setBackgroundColor:[UIColor colorWithRed:170.0/255.0 green:238.0/255.0 blue:236.0/255.0 alpha:1.00]];
    
    self.skView = (SKView*)self.skView;
    
    SKScene* gameScene =  [self getGameSceneForSceneOption:newSceneOption];;
    
    [self.skView presentScene:gameScene];
}


-(SKScene*)getGameSceneForSceneOption:(SCENE_OPTION)newSceneOption{
    
    SKScene* gameScene = [[SKScene alloc] initWithSize:self.contentView.bounds.size];
    
    [gameScene setBackgroundColor:[UIColor colorWithRed:170.0/255.0 green:238.0/255.0 blue:236.0/255.0 alpha:1.00]];
    
    switch(newSceneOption){
        case SCENE1:
            [self configureSceneForOption1:gameScene];
            break;
        case SCENE2:
            [self configureSceneForOption2:gameScene];
            break;
        case SCENE3:
            [self configureSceneForOption3:gameScene];
            break;
        case SCENE4:
            [self configureSceneForOption4:gameScene];
            break;
        case SCENE5:
            [self configureSceneForOption5:gameScene];
            break;
        case SCENE6:
            [self configureSceneForOption6:gameScene];
            break;
        case SCENE7:
            [self configureSceneForOption7:gameScene];
            break;
        case SCENE8:
            [self configureSceneForOption8:gameScene];
            break;
        case SCENE9:
            [self configureSceneForOption9:gameScene];
            break;
    }
    
    return gameScene;
}


-(void)configureSceneForOption1:(SKScene*)scene{
    
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"informationB"]] andWithActionArray:actionArray];

}



-(void)configureSceneForOption2:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];

    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"compassB"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption3:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction rotateByAngle:30.0 duration:0.5],[SKAction rotateByAngle:-30.0 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"city1"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption4:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction rotateByAngle:-20.0 duration:1.7],[SKAction rotateByAngle:20.0 duration:1.7], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"templeB"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption5:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"cloudyA"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption6:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"chatA"]] andWithActionArray:actionArray];
}


-(void)configureSceneForOption7:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"shoppingCartB"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption8:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"mapAddressB"]] andWithActionArray:actionArray];
}

-(void)configureSceneForOption9:(SKScene*)scene{
    NSArray* actionArray = [NSArray arrayWithObjects:[SKAction scaleTo:1.5 duration:0.5],[SKAction scaleTo:0.7 duration:0.5], nil];
    
    [self configureScene:scene withTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"paintingB"]] andWithActionArray:actionArray];
}



-(void)configureScene:(SKScene*)scene withTexture:(SKTexture*)texture andWithActionArray:(NSArray<SKAction*>*)actionArray {
    
    NSLog(@"About to configure scene %@ and with action array %@",[scene description],[actionArray description]);
    
    [scene setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    SKSpriteNode* spriteNode = [[SKSpriteNode alloc] initWithTexture:texture];
    [spriteNode setAnchorPoint:CGPointMake(0.5, 0.5)];
    [spriteNode setPosition:CGPointMake(0.0, 0.0)];
    
    
    SKAction* action1 = [SKAction sequence:actionArray];
    
    SKAction* animation = [SKAction repeatActionForever:action1];
    
    [spriteNode runAction:animation];
    
    [scene addChild:spriteNode];
}


@end
