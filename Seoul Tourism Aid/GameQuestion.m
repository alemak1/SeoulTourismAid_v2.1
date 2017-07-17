//
//  GameQuestion.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameQuestion.h"


@implementation GameQuestion

-(instancetype)initWithQuestion:(NSString*)question andWithChoice1:(NSString*)choice1 andWithChoice2:(NSString*)choice2 andWithChoice3:(NSString*)choice3 andWithChoice4:(NSString*)choice4 andWithAnswer:(NSInteger)answer{
    
    if(self = [super init]){
        
        self.question = question;
        self.choice1 = choice1;
        self.choice2 = choice2;
        self.choice3 = choice3;
        self.choice4 = choice4;
        self.answer = answer;
        
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]){
        
        self.question = [aDecoder decodeObjectForKey:@"Question"];
        self.choice1 = [aDecoder decodeObjectForKey:@"Choice1"];
        self.choice2 = [aDecoder decodeObjectForKey:@"Choice2"];
        self.choice3 = [aDecoder decodeObjectForKey:@"Choice3"];
        self.choice4 = [aDecoder decodeObjectForKey:@"Choice4"];
        self.answer = [[aDecoder decodeObjectForKey:@"Answer"] integerValue];


    }
    
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.question forKey:@"Question"];
    [aCoder encodeObject:self.choice1 forKey:@"Choice1"];
    [aCoder encodeObject:self.choice2 forKey:@"Choice2"];
    [aCoder encodeObject:self.choice3 forKey:@"Choice3"];
    [aCoder encodeObject:self.choice4 forKey:@"Choice4"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.answer] forKey:@"Answer"];
    
}

@end
