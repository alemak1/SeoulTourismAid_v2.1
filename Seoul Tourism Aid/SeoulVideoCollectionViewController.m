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
            return @"yfRjP1nfynA"; //Mark Wiens: Bangkok to Seoul (Day 1)
        case SEOUL_VIDEO_2:
            return @"QZcVXkkhVH0"; //Mark Wiens: Amazing Korean Food and Attractions in Seoul (Day 2)
        case SEOUL_VIDEO_3:
            return @"b38wnCBfbbU"; //Mark Wiens: Korean BBQ (Day 3)
        case SEOUL_VIDEO_4:
            return @"3qfLdficgRI";  //Mark Wiens: Giant Dak Galbi & Day Trip to Nami Island (Day 4)
        case SEOUL_VIDEO_5:
            return @"1N2loINKkTA"; //Mark Wiens: Best Korean Street Food in Seoul at Gwangjang Market (Day 5)
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
            return @"_ihNezZ1xF8"; //Mark Wiens: Korean Food in Seoul - Spicy Hairtail Fish Stew 갈치조림 (Day 6)
        case KOREA_VIDEO_2:
            return @"jVLGXDjrQ0Q"; //Mark Wiens: The Ultimate Korean Bibimbap and Attractions in Jeonju (Day 7)
        case KOREA_VIDEO_3:  //Mark Wiens: Exotic Korean Seafood in Gunsan, South Korea! (Day 8)
            return @"LFjL6ek6gY4";
        case KOREA_VIDEO_4: //Mark Wiens: Korean Food - Premium Korean JANGSU BEEF! (Day 9)
            return @"s6VSAgLf0l4";
        case KOREA_VIDEO_5: //Mark Wiens: Live Octopus & Chicken Ginseng Soup (Day 10)
            return @"9YLiCOhlHQI";
        default:
            break;
    }
    
    return nil;
}

-(NSString*)getVideoIDforSection3:(NSInteger)row{
    
    VIDEO_SECTION_3_CATEGORY video_section_1_choice = (VIDEO_SECTION_3_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case KOREA_FOOD_VIDEO_1:
            return @"FGCfKM5B7D8"; //Grrl Traveler: WHAT TO BUY IN KOREA ♥ (Part I of 2) ♥
        case KOREA_FOOD_VIDEO_2:
            return @"H1haMA1yQlI"; //Grrl Traveler: WHAT TO BUY IN KOREA ♥ Part 2 ♥ SOUVENIR SHOPPING KOREA
        case KOREA_FOOD_VIDEO_3:
            return @"QLt0Bu4u7-Y";  //Grrl Traveler: TOP 5 TRAVEL TIPS : SURVIVING KOREAN CULTURE
        case KOREA_FOOD_VIDEO_4:
            return @"Y5JtIVVX5oc"; //Grrl Traveler: MY KOREAN APARTMENT TOUR | TEACH WITH EPIK
        case KOREA_FOOD_VIDEO_5:
            return @"LV47A4iaDOw"; //Grrl Traveler: Odeng 오뎅 | Eomuk 어묵 | Korean Food
        default:
            break;
    }
    
    return nil;

}

-(NSString*)getVideoIDforSection4:(NSInteger)row{
    
    VIDEO_SECTION_4_CATEGORY video_section_1_choice = (VIDEO_SECTION_4_CATEGORY)row;
    
    switch (video_section_1_choice) {
        case KOREA_NATURE_VIDEO_1:
            return @"KfNaSyiA23U";  //Selinas Inspiration
        case KOREA_NATURE_VIDEO_2:
            return @"N-zrjBpKGiI"; //Mark Wiens: 25 Best Things to Do In Seoul
        case KOREA_NATURE_VIDEO_3:
            return @"RVQvg-jc0H4"; //Grrl Traveler: TOP 5 TRAVEL TIPS FOR SEOUL, KOREA | TRIP PLANNING ESSENTIALS
        case KOREA_NATURE_VIDEO_4:  //Grrl Traveler: PATBINGSU & Why Koreans Share? | 팥빙수
            return @"laNvMrtPo1A";
        case KOREA_NATURE_VIDEO_5: //Grrl Traveler: Teach in Korea: EPIK Fears!!!
            return @"06FopHAb34U";
        default:
            break;
    }
    
    return nil;

}




@end
