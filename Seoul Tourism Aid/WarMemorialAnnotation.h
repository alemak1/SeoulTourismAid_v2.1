//
//  WarMemorialAnnotation.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/4/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WarMemorialAnnotation_h
#define WarMemorialAnnotation_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CloudKit/CloudKit.h>

@interface WarMemorialAnnotation : NSObject<MKAnnotation>


@property NSString* imagePath;
@property NSString* annotationDescription;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* subtitle;
@property (nonatomic)CLLocationCoordinate2D coordinate;

@property UIImage* image;
@property CLLocation* location;

-(instancetype)initWithDict:(NSDictionary*)configurationDict;

-(instancetype)initWithCKRecord:(CKRecord*)record;


@end

#endif /* WarMemorialAnnotation_h */
