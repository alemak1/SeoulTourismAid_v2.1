//
//  KoreanProductCell.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/5/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "KoreanProductCell.h"

@interface KoreanProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end

@implementation KoreanProductCell

@synthesize image = _image;

-(instancetype)init{
    
    self = [super init];
    
    if(self){
        [self.imageView setImage:self.image];
    }
    
    return self;
}

-(UIImage *)image{
    return _image;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    [self.imageView setImage:image];
}

@end
