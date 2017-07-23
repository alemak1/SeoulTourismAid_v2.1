//
//  AudioController.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef AudioController_h
#define AudioController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AudioSection.h"

@interface AudioController : NSObject

- (instancetype)init;

-(void) playSoundForIndexPath:(NSIndexPath*)indexPath;

@end

#endif /* AudioController_h */
