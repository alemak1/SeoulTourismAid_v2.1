//
//  AudioSection.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "AudioSection.h"

@implementation AudioSectionHelper

 NSString* const kAudioPhraseFilePathKey = @"filePath";
 NSString* const kOriginalPhraseKey = @"originalPhrase";


+(NSString*)getStringForAudioSection:(AudioSection)audioSection{
    
    switch (audioSection) {
        case BASIC:
            return @"Basic Phrases";
        case RESTAURANTS:
            return @"Restaurants";
        case TRANSPORTATION:
            return @"Transportation";
        case FOOD:
            return @"Food";
        case MISCELLANEOUS:
            return @"Miscellaneous";
        default:
            break;
    }
    
    return nil;
}

+(NSArray<NSDictionary*>*)getAudioPhraseDictFrom:(AudioSection)audioSection{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AudioPhrases" ofType:@"plist"];
    
    NSDictionary* audioPhraseDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString* sectionName = [AudioSectionHelper getStringForAudioSection:audioSection];
    
    return [audioPhraseDict valueForKey:sectionName];
}


+(NSInteger)numberOfAudioPhrasesForSection:(AudioSection)audioSection{
    
    NSArray* audioPhraseArray = [AudioSectionHelper getAudioPhraseDictFrom:audioSection];
    
    return [audioPhraseArray count];
}

+(NSDictionary*)getAudioPhraseDictFor:(NSIndexPath*)indexPath{
    AudioSection audioSection = (AudioSection)indexPath.section;
    
    NSArray* audioPhraseArray = [AudioSectionHelper getAudioPhraseDictFrom:audioSection];
    
    return [audioPhraseArray objectAtIndex:indexPath.row];
    
}

+(NSString*)getFilePathFor:(NSIndexPath*)indexPath{
    
    AudioSection audioSection = (AudioSection)indexPath.section;
    
    NSArray* audioPhraseArray = [AudioSectionHelper getAudioPhraseDictFrom:audioSection];
    
    NSDictionary* audioPhraseDict = [audioPhraseArray objectAtIndex:indexPath.row];
    
    return audioPhraseDict[kAudioPhraseFilePathKey];
    
}

+(NSString*)getOriginalPhraseFor:(NSIndexPath*)indexPath{
    
    AudioSection audioSection = (AudioSection)indexPath.section;
    
    NSArray* audioPhraseArray = [AudioSectionHelper getAudioPhraseDictFrom:audioSection];
    
    NSDictionary* audioPhraseDict = [audioPhraseArray objectAtIndex:indexPath.row];
    
    return audioPhraseDict[kOriginalPhraseKey];
}


@end
