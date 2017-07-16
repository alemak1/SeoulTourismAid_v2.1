//
//  UIView+HelperMethods.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/26/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HelperMethods)

-(CGRect) getFrameAdjustedRelativeToContentViewWithXCoordOffset:(CGFloat)xCoordinateOffset andWithYCoordOffset:(CGFloat)yCoordinateOffset andWithWidthMultiplier:(CGFloat)widthMultiplier andWithHeightMultiplier:(CGFloat)heightMultiplier;

@end
