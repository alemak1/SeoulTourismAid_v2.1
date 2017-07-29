//
//  HeaderViewConfiguration.h
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef HeaderViewConfiguration_h
#define HeaderViewConfiguration_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SeoulLocationAnnotation+HelperMethods.h"

@interface HeaderViewConfiguration : NSObject

@property UIFont* titleFont;
@property UIColor* textColor;
@property NSString* imageName;
@property NSString* text;

/** Initializers **/

- (id) initWithFont:(UIFont*)fontType andWithTextColor:(UIColor*)textColor andWithSeoulLocationType:(SeoulLocationType)seoulLocationType;

/** Factory methods **/

+ (HeaderViewConfiguration*) getHeaderViewConfigurationForSection:(SeoulLocationType)seoulLocationType;

@end

#endif /* HeaderViewConfiguration_h */
