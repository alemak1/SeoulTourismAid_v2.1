//
//  SeoulLocationAnnotation+HelperMethods.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "HostelLocationAnnotation.h"

@interface SeoulLocationAnnotation (HelperMethods)

+(NSString*) getTitleForLocationType:(SeoulLocationType)locationType;
+(NSString*)getImagePathForSeoulLocationType:(SeoulLocationType)seoulLocationType;
+(UIColor*)getFontHeaderColorForSeoulLocationType:(SeoulLocationType)seoulLocationType;

@end
