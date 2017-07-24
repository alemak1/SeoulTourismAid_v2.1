//
//  AudioHeaderView.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioHeaderView.h"

@interface AudioHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation AudioHeaderView




-(void)layoutSubviews{
    self.imageView.image = self.headerImage;
    self.label.text = self.headerText;
}

@end
