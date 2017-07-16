//
//  UIView+HelperMethods.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "UIView+HelperMethods.h"

@implementation UIView (HelperMethods)



/** Helper method for programmatically generating custom inset frames based on the dimensions of a subview's superview **/

-(CGRect) getFrameAdjustedRelativeToContentViewWithXCoordOffset:(CGFloat)xCoordinateOffset andWithYCoordOffset:(CGFloat)yCoordinateOffset andWithWidthMultiplier:(CGFloat)widthMultiplier andWithHeightMultiplier:(CGFloat)heightMultiplier{
    
    
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    CGFloat contentViewHeight = CGRectGetHeight(self.frame);
    
    CGRect insetFrame = self.frame;
    
    insetFrame.origin.x = contentViewWidth*xCoordinateOffset;
    insetFrame.origin.y = contentViewHeight*yCoordinateOffset;
    insetFrame.size = CGSizeMake(contentViewWidth*widthMultiplier, contentViewHeight*heightMultiplier);
    return insetFrame;
}


@end
