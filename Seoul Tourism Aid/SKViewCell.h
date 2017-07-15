//
//  SKViewCell.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef SKViewCell_h
#define SKViewCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKViewCell : UICollectionViewCell


typedef enum SCENE_OPTION{
    SCENE1,
    SCENE2,
    SCENE3,
    SCENE4,
    SCENE5,
    SCENE6,
    SCENE7,
    SCENE8,
    SCENE9,
    TOTAL_NUMBER_OF_SCENES
}SCENE_OPTION;


-(void)setSceneOption:(SCENE_OPTION)newSceneOption;


@end

#endif /* SKViewCell_h */
