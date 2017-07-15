//
//  MenuComponent.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef MenuComponent_h
#define MenuComponent_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MenuComponent : NSObject<UITableViewDataSource,UITableViewDelegate>

typedef enum MenuDirectionOptionTypes{
    menuDirectionLeftToRight,
    menuDirectionRightToLeft
} MenuDirectionOptions;

@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) NSMutableDictionary *tableSettings;
@property (nonatomic) CGFloat optionCellHeight;
@property (nonatomic) CGFloat acceleration;

- (id)initMenuWithFrame:(CGRect)frame targetView:(UIView *)targetView direction:(MenuDirectionOptions)direction options:(NSArray *)options optionImages:(NSArray *)optionImages;

- (void)showMenuWithSelectionHandler:(void(^)(NSInteger selectedOptionIndex))handler;
-(void)resetOptionsTableView:(UITraitCollection*)newTraitCollection;
-(void)resetMenuView:(UITraitCollection*)newTraitCollection;

@property (nonatomic,strong) UIImage* cachedPortraitImage;
@property (nonatomic,strong) UIImage* cachedLandscapeImage;


@end

#endif /* MenuComponent_h */
