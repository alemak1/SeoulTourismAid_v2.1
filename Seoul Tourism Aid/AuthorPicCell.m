//
//  AuthorPicCell.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AuthorPicCell.h"

@interface AuthorPicCell ()


@property (weak, nonatomic) IBOutlet UIImageView *authorPicImageView;


@end


@implementation AuthorPicCell

-(void)layoutSubviews{
    self.authorPicImageView.image = self.authorPic;
}

@end
