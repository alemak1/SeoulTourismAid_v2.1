//
//  FlickrPhoto.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef FlickrPhoto_h
#define FlickrPhoto_h



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlickrPhoto : NSObject

@property UIImage* thumbnail;
@property UIImage* largeImage;
@property NSString* photoID;
@property NSInteger farm;
@property NSString* server;
@property NSString* secret;

-(instancetype)initWithPhotoID:(NSString*)photoID andWithFarm:(NSInteger)farm andWithServer:(NSString*)server andWithSecret:(NSString*)secret;

-(NSURL*)getFlickrImageURLWithSize:(NSString*)size;

-(void)loadLargeImage:(void(^)(FlickrPhoto*photo,NSError*error))completion;

-(CGSize)sizeToFillWidthOfSize:(CGSize)size;


@end

#endif /* FlickrPhoto_h */
