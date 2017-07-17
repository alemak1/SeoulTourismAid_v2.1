//
//  GameQuestion.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef GameQuestion_h
#define GameQuestion_h

#import <Foundation/Foundation.h>

@interface GameQuestion : NSObject<NSCoding>

@property NSString* question;
@property NSString* choice1;
@property NSString* choice2;
@property NSString* choice3;
@property NSString* choice4;
@property NSInteger answer;

-(instancetype)initWithQuestion:(NSString*)question andWithChoice1:(NSString*)choice1 andWithChoice2:(NSString*)choice2 andWithChoice3:(NSString*)choice3 andWithChoice4:(NSString*)choice4 andWithAnswer:(NSInteger)answer;

@end

#endif /* GameQuestion_h */
