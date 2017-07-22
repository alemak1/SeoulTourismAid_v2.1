//
//  MediaPickerManager.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef MediaPickerManager_h
#define MediaPickerManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MediaPickerManagerDelegate.h"

@interface MediaPickerManager : NSObject


-(instancetype)initWithPresentingViewController:(UIViewController*)presentingViewController;

-(void)presentImagePickerController:(BOOL)animated;
-(void)dismissImagePickerController:(BOOL)animated withCompletionHandler:(void(^)(void))completion;

@property id<MediaPickerManagerDelegate>delegate;

@end

#endif /* MediaPickerManager_h */
