//
//  VideoThumbnailCell.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef VideoThumbnailCell_h
#define VideoThumbnailCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YTPlayerView.h"


@interface VideoThumbnailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YTPlayerView *cellPlayerView;


@end

#endif /* VideoThumbnailCell_h */
