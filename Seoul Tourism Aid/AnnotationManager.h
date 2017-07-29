//
//  AnnotationManager.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef AnnotationManager_h
#define AnnotationManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HostelLocationAnnotation.h"

@interface AnnotationManager : NSObject


-(NSArray<SeoulLocationAnnotation*>*)getAllAnnotations;
-(NSArray<SeoulLocationAnnotation*>*)getAnnotationsOfType:(SeoulLocationType)locationType;

-(SeoulLocationAnnotation*)getAnnotationForIndexPath:(NSIndexPath*)indexPath;

-(instancetype)initWithFilename:(NSString*)filename;

-(NSString*)debugDescriptionDetail;
-(NSString*)debugDescriptionAbbreviated;

@end

#endif /* AnnotationManager_h */
