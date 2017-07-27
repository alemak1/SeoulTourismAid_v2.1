//
//  TouristSiteSectionHeaderCell.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TouristSiteSectionHeaderCell.h"

@interface TouristSiteSectionHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end



@implementation TouristSiteSectionHeaderCell


-(instancetype)init{
    
    self = [super init];
    
    if(self){
        

        
    }
    
    return self;
}


-(void)layoutSubviews{
    
    [self.titleLabel setText:self.titleText];

}

@end
