//
//  AudioController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AudioController.h"
@import AVFoundation;

@interface AudioController () <AVAudioPlayerDelegate>


@property (strong, nonatomic) AVAudioSession *audioSession;

/** C-Style arrays for organizing sound files organized in different sound categories **/

@property SystemSoundID* basicPhraseSounds;
@property SystemSoundID* transportationSounds;
@property SystemSoundID* restaurantSounds;
@property SystemSoundID* foodSounds;
@property SystemSoundID* miscellaneousSounds;
@property SystemSoundID* clothingSounds;

@end


@implementation AudioController


-(instancetype)init{
    
    self = [super init];
    
    if(self){
        [self configureSystemSound];
        
    }
    
    return self;
}





-(void) playSoundForIndexPath:(NSIndexPath*)indexPath{
    
    if(self.audioSession.isOtherAudioPlaying){
        return;
    }
    
    AudioSection audioSection = (int)indexPath.section;
    
    switch (audioSection) {
        case BASIC:
            AudioServicesPlaySystemSound(_basicPhraseSounds[indexPath.row]);
            break;
        case RESTAURANTS:
            AudioServicesPlaySystemSound(_restaurantSounds[indexPath.row]);
            break;
        case FOOD:
            AudioServicesPlaySystemSound(_foodSounds[indexPath.row]);
            break;
        case MISCELLANEOUS:
            AudioServicesPlaySystemSound(_miscellaneousSounds[indexPath.row]);
            break;
        case TRANSPORTATION:
            AudioServicesPlaySystemSound(_transportationSounds[indexPath.row]);
            break;
        case CLOTHING:
            AudioServicesPlaySystemSound(_clothingSounds[indexPath.row]);
            break;
        default:
            break;
    }
    
}


- (void)configureSystemSound {
    // This is the simplest way to play a sound.
    // But note with System Sound services you can only use:
    // File Formats (a.k.a. audio containers or extensions): CAF, AIF, WAV
    // Data Formats (a.k.a. audio encoding): linear PCM (such as LEI16) or IMA4
    // Sounds must be 30 sec or less
    // And only one sound plays at a time!
    
    
    NSLog(@"Determine the number of sounds files for each section...");
    
    int numberOfTransportationSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:TRANSPORTATION];
    
    int numberOfRestaurantSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:RESTAURANTS];
    
    int numberOfFoodSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:FOOD];
    
    int numberOfMiscellaneousSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:MISCELLANEOUS];
    
    int numberOfBasicPhraseSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:BASIC];

    int numberOfClothingSounds = (int)[AudioSectionHelper numberOfAudioPhrasesForSection:CLOTHING];
    
    NSLog(@"Allocating memory for sound files in each section...");

    _transportationSounds = calloc(sizeof(SystemSoundID), numberOfTransportationSounds);
    _foodSounds = calloc(sizeof(SystemSoundID), numberOfFoodSounds);
    _restaurantSounds = calloc(sizeof(SystemSoundID), numberOfRestaurantSounds);
    _miscellaneousSounds = calloc(sizeof(SystemSoundID), numberOfMiscellaneousSounds);
    _basicPhraseSounds = calloc(sizeof(SystemSoundID), numberOfBasicPhraseSounds);
    _clothingSounds = calloc(sizeof(SystemSoundID), numberOfClothingSounds);

    NSLog(@"Loading transportation sounds...");

    for (int i = 0; i < numberOfTransportationSounds; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:TRANSPORTATION];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(!fileName){
            fileName = @"foodAudio1";
        }
        
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_transportationSounds[i]);
    }
    
    NSLog(@"Loading food sounds...");

    
    for (int i = 0; i < numberOfFoodSounds; i++) {
        
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:FOOD];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(fileName == nil){
            fileName = @"foodAudio1";
        }
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_foodSounds[i]);
    }
    
    NSLog(@"Loading restaurant sounds...");

    
    for (int i = 0; i < numberOfRestaurantSounds; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:RESTAURANTS];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(fileName == nil){
            fileName = @"foodAudio1";
        }
        
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_restaurantSounds[i]);
    }
    
    NSLog(@"Loading basic phrase sounds...");

    
    for (int i = 0; i < numberOfBasicPhraseSounds; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:BASIC];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(fileName == nil){
            fileName = @"foodAudio1";
        }
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_basicPhraseSounds[i]);
    }
    
    NSLog(@"Loading miscellaneous phrase sounds...");

    
    for (int i = 0; i < numberOfMiscellaneousSounds; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:MISCELLANEOUS];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(fileName == nil || indexPath == nil){
            fileName = @"foodAudio1";
        }
        
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_miscellaneousSounds[i]);
    }
    
    for (int i = 0; i < numberOfClothingSounds; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:CLOTHING];
        
        NSString* fileName = [AudioSectionHelper getFilePathFor:indexPath];
        
        if(fileName == nil || indexPath == nil){
            fileName = @"foodAudio1";
        }
        
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_clothingSounds[i]);
    }
    
    
}


#pragma CLEANUP_METHODS

-(void) releaseSoundFiles{
    free(_transportationSounds);
    _transportationSounds = nil;
    
    free(_basicPhraseSounds);
    _basicPhraseSounds = nil;
    
    free(_restaurantSounds);
    _restaurantSounds = nil;
    
    free(_foodSounds);
    _foodSounds = nil;
    
    free(_miscellaneousSounds);
    _miscellaneousSounds = nil;
}

-(void)dealloc{
    
    [self releaseSoundFiles];
    
}





@end
