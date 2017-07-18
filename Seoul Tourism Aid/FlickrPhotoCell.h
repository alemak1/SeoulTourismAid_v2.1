//
//  FlickrPhotoCell.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef FlickrPhotoCell_h
#define FlickrPhotoCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlickrPhotoCell : UICollectionViewCell

@property UIImageView* imageView;

@property (weak, nonatomic) IBOutlet UIImageView *outletImageView;


@end

#endif /* FlickrPhotoCell_h */
