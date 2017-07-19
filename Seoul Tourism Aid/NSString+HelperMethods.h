//
//  NSString+HelperMethods.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayOfWeek.h"

@interface NSString (HelperMethods)

+ (NSString *)timeFormattedStringFromTotalSeconds:(int)totalSeconds;
+ (NSString *)timeHHMMSSFormattedStringFromTotalSeconds:(int)totalSeconds;
+ (NSString*) getDayAbbreviation:(DayOfWeek)dayOfWeek;

@end
