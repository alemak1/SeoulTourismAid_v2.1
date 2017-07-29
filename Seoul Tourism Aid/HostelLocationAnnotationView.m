//
//  HostelLocationAnnotationView.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostelLocationAnnotationView.h"
#import "HostelLocationAnnotation.h"
#import "SeoulLocationAnnotation+HelperMethods.h"

@implementation SeoulLocationAnnotationView

/** The initializer will automaticallys determine the image for the annotation view based on the the value of the "SeoulLocation" enum type  **/

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if(self){
        SeoulLocationAnnotation* seoulLocationAnnotation = self.annotation;
        
        NSString* imagePath = [SeoulLocationAnnotation getImagePathForSeoulLocationType:seoulLocationAnnotation.locationType];
        
        self.image = [UIImage imageNamed:imagePath];
        
        if([annotation isKindOfClass:[SeoulLocationAnnotation class]]){
            
            SeoulLocationAnnotation* locationAnnotation = (SeoulLocationAnnotation*)annotation;
            
            [self setCanShowCallout:YES];
        
            /** Configure detail label **/
            
            UILabel* detailLabel = [[UILabel alloc] init];
            
            NSString* detailString = [NSString stringWithFormat:@"%@, %@",locationAnnotation.title,locationAnnotation.address];
            
            NSAttributedString* attributedDetailString = [[NSAttributedString alloc] initWithString:detailString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:21.0],NSFontAttributeName, nil]];
            
            [detailLabel setAttributedText:attributedDetailString];
            
            [self setDetailCalloutAccessoryView:detailLabel];
        
            /** Configure left callout label **/
            UILabel* leftCalloutLabel = [[UILabel alloc] init];
            NSString* leftCalloutString = [NSString stringWithFormat:@"%@",locationAnnotation.address];
            
            NSAttributedString* attributedCalloutString = [[NSAttributedString alloc] initWithString:leftCalloutString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:17.0],NSFontAttributeName, nil]];
                                                           
            [leftCalloutLabel setAttributedText:attributedCalloutString];
        
            [self setLeftCalloutAccessoryView:leftCalloutLabel];
        
        
            /** Configure right callout label **/
            
            [self setRightCalloutAccessoryView:nil];
        }
        
    }
    
    return self;
}

@end
