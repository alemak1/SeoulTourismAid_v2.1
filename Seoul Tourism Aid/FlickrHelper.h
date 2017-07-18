//
//  FlickrHelper.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef FlickrHelper_h
#define FlickrHelper_h


#import <Foundation/Foundation.h>
#import "FlickrSearchResults.h"

@interface FlickrHelper : NSObject

-(void)searchFlickrForTerm:(NSString*)searchTerm andWithCompletionHandler:(void(^)(FlickrSearchResults* flickrSearchResults, NSError*error))completion;

-(NSURL*)getFlickrSearchURLForSearchTerm:(NSString*)searchTerm;


-(void)searchFlickrWithDataTaskForTerm:(NSString*)searchTerm andWithCompletionHandler:(void(^)(FlickrSearchResults*, NSError*))backgroundTaskCompletionHandler;

@end

#endif /* FlickrHelper_h */
