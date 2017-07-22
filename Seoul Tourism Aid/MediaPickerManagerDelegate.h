//
//  MediaPickerManagerDelegate.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef MediaPickerManagerDelegate_h
#define MediaPickerManagerDelegate_h

#import <UIKit/UIKit.h>

@class MediaPickerManager;

@protocol MediaPickerManagerDelegate <NSObject>

-(void)mediaPickerManager:(MediaPickerManager*)manager didFinishPickingImage:(UIImage*)image;

@end

#endif /* MediaPickerManagerDelegate_h */
