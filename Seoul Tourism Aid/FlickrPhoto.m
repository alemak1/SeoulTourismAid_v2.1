//
//  FlickrPhoto.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//




#import "FlickrPhoto.h"


@interface FlickrPhoto ()

@end

@implementation FlickrPhoto

-(instancetype)initWithPhotoID:(NSString*)photoID andWithFarm:(NSInteger)farm andWithServer:(NSString*)server andWithSecret:(NSString*)secret{
    
    if(self = [super init]){
        _photoID = photoID;
        _farm = farm;
        _server = server;
        _secret = secret;
    }
    
    return self;
}


-(NSURL*)getFlickrImageURLWithSize:(NSString*)size{
    
    NSString* imageSize = @"m";
    
    if(size){
        imageSize = size;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%@/%@_%@_%@.jpg",(long)self.farm,self.server,self.photoID,self.secret,imageSize, nil];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    return url;
}

-(void)loadLargeImage:(void(^)(FlickrPhoto*photo,NSError*error))completion{
    
    NSURL* loadURL = [self getFlickrImageURLWithSize:@"b"];
    
    if(!loadURL){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self,nil);
        });
    }
    
    NSURLRequest* loadRequest = [NSURLRequest requestWithURL:loadURL];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:loadRequest completionHandler:^(NSData*data,NSURLResponse*response,NSError*error){
        
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(self,error);
            });
        }
        
        if(!data){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(self,nil);
            });
        }
        
        UIImage* returnedImage = [UIImage imageWithData:data];
        
        self.largeImage = returnedImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(self,nil);
        });
        
        
    }] resume];
    
}

-(CGSize)sizeToFillWidthOfSize:(CGSize)size{
    
    if(!self.thumbnail){
        return size;
    }
    
    CGSize imageSize = self.thumbnail.size;
    CGSize returnSize = size;
    
    CGFloat aspectRatio = imageSize.width/imageSize.height;
    
    returnSize.height = returnSize.width/aspectRatio;
    
    if(returnSize.height > size.height){
        returnSize.height = size.height;
        returnSize.width = size.height*aspectRatio;
    }
    
    return returnSize;
}


@end
