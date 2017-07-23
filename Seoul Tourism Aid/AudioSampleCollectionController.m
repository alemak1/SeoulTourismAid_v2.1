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


@end
