//
//  FlickrSearchResults.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/10/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import "FlickrSearchResults.h"

@implementation FlickrSearchResults

-(instancetype)initWithSearchTerm:(NSString*)searchTerm andWithSearchResults:(NSMutableArray*)searchResults{
    
    if(self = [super init]){
        
        self.searchTerm = searchTerm;
        self.searchResults = searchResults;
    }
    
    return self;
    
    
}


-(instancetype)init{
    
    if(self = [super init]){
        
        self.searchTerm = [[NSString alloc] init];
        self.searchResults = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
