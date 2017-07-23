//
//  AudioSection.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef AudioSection_h
#define AudioSection_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AudioSectionHelper : NSObject

extern NSString* const kAudioPhraseFilePathKey;
extern NSString* const kOriginalPhraseKey;

typedef enum AudioSection{
    BASIC = 0,
    RESTAURANTS,
    TRANSPORTATION,
    FOOD,
    MISCELLANEOUS,
    TOTAL_NUMBER_OF_AUDIO_SECTIONS
}AudioSection;

+(NSString*)getStringForAudioSection:(AudioSection)audioSection;
+(NSArray<NSDictionary*>*)getAudioPhraseDictFrom:(AudioSection)audioSection;
+(NSInteger)numberOfAudioPhrasesForSection:(AudioSection)audioSection;

+(NSDictionary*)getAudioPhraseDictFor:(NSIndexPath*)indexPath;
+(NSString*)getFilePathFor:(NSIndexPath*)indexPath;
+(NSString*)getOriginalPhraseFor:(NSIndexPath*)indexPath;

@end

#endif /* AudioSection_h */
