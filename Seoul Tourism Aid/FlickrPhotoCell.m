//
//  FlickrPhotoCell.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrPhotoCell.h"



@interface FlickrPhotoCell ()


@end




@implementation FlickrPhotoCell




-(instancetype)init{
    
    if(self = [super init]){
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
    
}

@end
