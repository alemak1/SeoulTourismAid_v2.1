//
//  FlickrSearchResults.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef FlickrSearchResults_h
#define FlickrSearchResults_h

#import <Foundation/Foundation.h>
#import "FlickrPhoto.h"



@interface FlickrSearchResults : NSObject

@property NSString* searchTerm;
@property NSMutableArray<FlickrPhoto*>*searchResults;

-(instancetype)initWithSearchTerm:(NSString*)searchTerm andWithSearchResults:(NSMutableArray*)searchResults;

-(instancetype)init;

@end


#endif /* FlickrSearchResults_h */
