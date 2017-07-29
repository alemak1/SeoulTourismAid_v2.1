//
//  HeaderConfiguration.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderViewConfiguration.h"

@interface HeaderViewConfiguration ()


@end

@implementation HeaderViewConfiguration


#pragma mark ******** INITIALIZERS

- (id) initWithFont:(UIFont*)fontType andWithTextColor:(UIColor*)textColor andWithSeoulLocationType:(SeoulLocationType)seoulLocationType{
    
    
    self = [super init];
    
    if(self){
        
        _titleFont = fontType;
        _textColor = textColor;
        
        _text = [SeoulLocationAnnotation getTitleForLocationType:seoulLocationType];
        _imageName = [SeoulLocationAnnotation getImagePathForSeoulLocationType:seoulLocationType];
        
    }
    
    return self;
}

#pragma mark ******** FACTORY METHOD

+ (HeaderViewConfiguration*) getHeaderViewConfigurationForSection:(SeoulLocationType)seoulLocationType{
    
    UIColor* headerTextColor = [SeoulLocationAnnotation getFontHeaderColorForSeoulLocationType:seoulLocationType];
    
    return [[HeaderViewConfiguration alloc] initWithFont:[UIFont fontWithName:@"Copperplate" size:25.0] andWithTextColor:headerTextColor andWithSeoulLocationType:seoulLocationType];
    
}




@end
