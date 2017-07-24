//
//  AudioSampleCollectionController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "AudioSampleCollectionController.h"
#import "AudioSection.h"
#import "AudioSampleCell.h"
#import "AudioController.h"
#import "AudioHeaderView.h"

@interface AudioSampleCollectionController ()


@property AudioController* audioController;

@end

@implementation AudioSampleCollectionController

-(void)viewWillLayoutSubviews{
    
    self.audioController = [[AudioController alloc] init];
}

-(void)viewDidLoad{
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return TOTAL_NUMBER_OF_AUDIO_SECTIONS;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [AudioSectionHelper numberOfAudioPhrasesForSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AudioSampleCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AudioSampleCell" forIndexPath:indexPath];
    
    NSDictionary* audioDict = [AudioSectionHelper getAudioPhraseDictFor:indexPath];
    
    cell.phraseLabel.text = audioDict[kOriginalPhraseKey];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.audioController playSoundForIndexPath:indexPath];
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        AudioHeaderView* audioHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AudioHeaderView" forIndexPath:indexPath];
        
        AudioSection audioSection = (AudioSection)indexPath.section;
        
        switch (audioSection) {
            case CLOTHING:
                audioHeaderView.headerText = @"Clothing";
                audioHeaderView.headerImage = [UIImage imageNamed:@"red_shirt"];
                break;
            case RESTAURANTS:
                audioHeaderView.headerText = @"Restaurants";
                audioHeaderView.headerImage = [UIImage imageNamed:@"otherRestaurantsA"];
                break;
            case TRANSPORTATION:
                audioHeaderView.headerText = @"Transportation";
                audioHeaderView.headerImage = [UIImage imageNamed:@"undergroundA"];
                break;
            case MISCELLANEOUS:
                audioHeaderView.headerText = @"Miscellaneous";
                audioHeaderView.headerImage = [UIImage imageNamed:@"blenderA"];
                break;
            case FOOD:
                audioHeaderView.headerText = @"Food";
                audioHeaderView.headerImage = [UIImage imageNamed:@"cerealA"];
                break;
            case BASIC:
                audioHeaderView.headerText = @"Basic";
                audioHeaderView.headerImage = [UIImage imageNamed:@"chatA"];
                break;
            default:
                break;
        }
        
        
        return audioHeaderView;
        
    }
    
    return nil;
}

@end
