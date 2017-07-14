//
//  SeoulVideoCollectionViewController.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef SeoulVideoCollectionViewController_h
#define SeoulVideoCollectionViewController_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SeoulVideoCollectionViewController : UICollectionViewController

typedef enum VIDEO_SECTION{
    VIDEO_SECTION_1 = 0,
    VIDEO_SECITON_2,
    VIDEO_SECTION_3,
    VIDEO_SECTION_4,
    TOTAL_NUMBER_OF_VIDEO_SECTIONS
}VIDEO_SECTION;


@property VIDEO_SECTION currentVideoSection;

@end

#endif /* SeoulVideoCollectionViewController_h */
