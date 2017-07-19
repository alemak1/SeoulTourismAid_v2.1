//
//  DebugController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "DebugController.h"
#import "OperatingHours.h"
#import "TouristSiteConfiguration.h"
#import "CloudKitHelper.h"

@implementation DebugController

-(void)viewDidLoad{
    
    CKDatabase* publicDB = [[CKContainer containerWithIdentifier:@"iCloud.SeoulTourism"] publicCloudDatabase];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"title == 'The 4th Tunnel'"];
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    
    [publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>*records,NSError*error){
    
        if(error){
            NSLog(@"Error: failed to retrieve data from database: %@",[error localizedDescription]);
        }
        
        for (CKRecord*record in records) {
           // NSLog(@"Record debug info: %@",[record description]);
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initSimpleWithCKRecord:record];
            
           
            [siteConfiguration showTouristSiteDebugInfo];
            
        }
    
    }];
    
}

@end
