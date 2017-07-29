//
//  AnnotationManager.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AnnotationManager.h"
#import "HostelLocationAnnotation.h"

@interface AnnotationManager ()

@property NSMutableArray<SeoulLocationAnnotation*>* annotationArray;


@end

@implementation AnnotationManager

-(instancetype)initWithFilename:(NSString*)filename{
    
    self = [super init];
    
    if(self){
        
        NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        
        NSArray* arrayOfDicts = [NSArray arrayWithContentsOfFile:path];
        
        _annotationArray = [[NSMutableArray alloc] init];
        
        for(NSDictionary* configurationDict in arrayOfDicts){
            
            SeoulLocationAnnotation* annotation = [[SeoulLocationAnnotation alloc] initWithDict:configurationDict];
            
            [self.annotationArray addObject:annotation];
            
        }
        
    }
    
    return self;
}

-(NSArray<SeoulLocationAnnotation*>*)getAllAnnotations{
    
    return [NSArray arrayWithArray:self.annotationArray];
}

-(NSArray<SeoulLocationAnnotation*>*)getAnnotationsOfType:(SeoulLocationType)locationType{
    
    return [self.annotationArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SeoulLocationAnnotation* annotation, NSDictionary*bindings){
        
        if([annotation locationType] == locationType){
            return annotation;
        }
        
        return nil;
    }]];
}

-(SeoulLocationAnnotation*)getAnnotationForIndexPath:(NSIndexPath*)indexPath{
    
    NSArray* annotationsArray = [self getAnnotationsOfType:(SeoulLocationType)indexPath.section];
    
    return [annotationsArray objectAtIndex:indexPath.row];
}

/** Helper functions for debugging the annotations array **/

-(NSString*)debugDescriptionDetail{
    
    NSString* baseString = [self getBaseStringForDebugDescription];
    
    for(SeoulLocationAnnotation* annotation in self.annotationArray){
        
        [self addAnnotationDetailsToBaseString:baseString forAnnotation:annotation];
    }
    
    return baseString;
}


-(NSString*)debugDescriptionAbbreviated{
    
    NSString* baseString = [self getBaseStringForDebugDescription];
    

    for(SeoulLocationAnnotation* annotation in self.annotationArray){
        
        NSString* annotationTitle = [annotation title];
        
        baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"Annotation Title: ",annotationTitle]];
    }
    
    return baseString;
}


-(NSString*)getBaseStringForDebugDescription{
    NSUInteger totalAnnotations = [self.annotationArray count];
    
    NSString* baseString = [NSString stringWithFormat:@"Total Number of annotations is: %d. The annotations are as follows: ",(int)totalAnnotations];
    
    return baseString;
}

-(void) addAnnotationDetailsToBaseString:(NSString*)baseString forAnnotation:(SeoulLocationAnnotation*)annotation{
    
    NSString* title = [annotation title];
    NSString* address = [annotation address];
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    
    NSString* annotationDescription = [NSString stringWithFormat:@"The annotation is for title: %@, at the address: %@, at the coordinates Lat: %f, Long: %f", title,address,coordinate.latitude,coordinate.longitude];
    
    baseString = [baseString stringByAppendingString:annotationDescription];
    
}

@end
