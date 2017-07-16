//
//  WeatherCollectionCell.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/29/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef WeatherCollectionCell_h
#define WeatherCollectionCell_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherCollectionCell : UICollectionViewCell


@property double humidity;
@property double temperature;
@property double visibility;
@property double windSpeed;
@property double cloudCover;
@property double precipitation;
@property NSString* weatherIconName;
@property NSString* summaryText;

@property NSDate* date;

@end

#endif /* WeatherCollectionCell_h */
