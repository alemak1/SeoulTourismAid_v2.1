//
//  SeoulVideoCollectionViewController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeoulVideoCollectionViewController.h"
#import "VideoThumbnailCell.h"

@interface SeoulVideoCollectionViewController () <YTPlayerViewDelegate,UICollectionViewDelegateFlowLayout>


typedef enum VIDEO_SECTION_1_CATEGORY{
    SEOUL_VIDEO_1,
    SEOUL_VIDEO_2,
    SEOUL_VIDEO_3,
    SEOUL_VIDEO_4,
    SEOUL_VIDEO_5,
    TOTAL_NUMBER_OF_SECTION1_VIDS
}VIDEO_SECTION_1_CATEGORY;

typedef enum VIDEO_SECTION_2_CATEGORY{
    KOREA_VIDEO_1,
    KOREA_VIDEO_2,
    KOREA_VIDEO_3,
    KOREA_VIDEO_4,
    KOREA_VIDEO_5,
    TOTAL_NUMBER_OF_SECTION2_VIDS
}VIDEO_SECTION_2_CATEGORY;


typedef enum VIDEO_SECTION_3_CATEGORY{
    KOREA_FOOD_VIDEO_1,
    KOREA_FOOD_VIDEO_2,
    KOREA_FOOD_VIDEO_3,
    KOREA_FOOD_VIDEO_4,
    KOREA_FOOD_VIDEO_5,
    TOTAL_NUMBER_OF_SECTION3_VIDS
}VIDEO_SECTION_3_CATEGORY;

typedef enum VIDEO_SECTION_4_CATEGORY{
    KOREA_NATURE_VIDEO_1,
    KOREA_NATURE_VIDEO_2,
    KOREA_NATURE_VIDEO_3,
    KOREA_NATURE_VIDEO_4,
    KOREA_NATURE_VIDEO_5,
    TOTAL_NUMBER_OF_SECTION4_VIDS
}VIDEO_SECTION_4_CATEGORY;






@end

@implementation SeoulVideoCollectionViewController


-(void)viewWillLayoutSubviews{
    
    [self.collectionView setDelegate:self];
}


-(void)viewDidLoad{
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self getRowsForVideoSection:self.currentVideoSection];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoThumbnailCell* videoThumbnailCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"VideoThumbnailCell" forIndexPath:indexPath];
    
    NSString* videoID = [self getVideoIDforRow:indexPath.row];
    
    [videoThumbnailCell.cellPlayerView loadWithVideoId:videoID];
    
    [videoThumbnailCell.cellPlayerView setDelegate:self];
    
    
    return videoThumbnailCell;

}




-(NSInteger)getRowsForVideoSection:(VIDEO_SECTION)video_section{
    switch (video_section) {
        case VIDEO_SECTION_1:
            return TOTAL_NUMBER_OF_SECTION1_VIDS;
        case VIDEO_SECITON_2:
            return TOTAL_NUMBER_OF_SECTION2_VIDS;
        case VIDEO_SECTION_3:
            return TOTAL_NUMBER_OF_SECTION3_VIDS;
        case VIDEO_SECTION_4:
            return TOTAL_NUMBER_OF_SECTION4_VIDS;
        default:
            break;
    }
    
    return -1;
}

-(NSString*)getVideoIDforRow:(NSInteger)row{
    switch (self.currentVideoSection) {
        case VIDEO_SECTION_1:
            return [self getVideoIDforSection1:row];
        case VIDEO_SECITON_2:
            return [self getVideoIDforSection2:row];
        case VIDEO_SECTION_3:
            return [self getVideoIDforSection3:row];
        case VIDEO_SECTION_4:
            return [self getVideoIDforSection4:row];
        default:
            break;
    }
    
    
    return nil;
    
}


-(NSString*)getVideoIDforSection1:(NSInteger)row{
    
    VIDEO_SECTION_1_CATEGORY video_section_1_choice = (VIDEO_SECTION_1_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case SEOUL_VIDEO_1:
            return @"5_2dFjpoClk";
        case SEOUL_VIDEO_2:
            return @"KfNaSyiA23U";
        case SEOUL_VIDEO_3:
            return @"2twwUxzndd4";
        case SEOUL_VIDEO_4:
            return @"zn5BlL-nN7M";
        case SEOUL_VIDEO_5:
            return @"J86Hx7RTnIQ";
        case TOTAL_NUMBER_OF_SECTION1_VIDS:
            return nil;
        default:
            break;
    }
    
    return nil;

}

-(NSString*)getVideoIDforSection2:(NSInteger)row{
    
    VIDEO_SECTION_2_CATEGORY video_section_1_choice = (VIDEO_SECTION_2_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case KOREA_VIDEO_1:
            return @"UJVlHwpS6Nw";
        case KOREA_VIDEO_2:
            return @"F8me1vDYdkY";
        case KOREA_VIDEO_3:
            return @"aEO-R4m5gmc";
        case KOREA_VIDEO_4:
            return @"lL3obqJ5s7w";
        case KOREA_VIDEO_5:
            return @"WoDsc4IubDQ";
        default:
            break;
    }
    
    return nil;
}

-(NSString*)getVideoIDforSection3:(NSInteger)row{
    
    VIDEO_SECTION_3_CATEGORY video_section_1_choice = (VIDEO_SECTION_3_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case KOREA_FOOD_VIDEO_1:
            return @"H2ZQa8834Qw";
        case KOREA_FOOD_VIDEO_2:
            return @"pgnkD91vcoc";
        case KOREA_FOOD_VIDEO_3:
            return @"BcHWw5pkCxE";
        case KOREA_FOOD_VIDEO_4:
            return @"6QQ67F8y2b8";
        case KOREA_FOOD_VIDEO_5:
            return @"rJgb92JWMCE";
        default:
            break;
    }
    
    return nil;

}

-(NSString*)getVideoIDforSection4:(NSInteger)row{
    
    VIDEO_SECTION_4_CATEGORY video_section_1_choice = (VIDEO_SECTION_4_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case KOREA_NATURE_VIDEO_1:
            return @"_4-slWw26gQ";
        case KOREA_NATURE_VIDEO_2:
            return @"ADQY5B1nQFg";
        case KOREA_NATURE_VIDEO_3:
            return @"hvEUjl0GoTI";
        case KOREA_NATURE_VIDEO_4:
            return @"0CwPlSVQ2NM";
        case KOREA_NATURE_VIDEO_5:
            return @"xoeYr_T75BQ";
        default:
            break;
    }
    
    return nil;

}




@end
