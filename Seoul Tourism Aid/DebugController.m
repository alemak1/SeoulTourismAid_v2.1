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
    
    NSString* placeName = @"Sokcho Beach ";
    
    NSString* predicateString = [NSString stringWithFormat:@"title == '%@'",placeName];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateString];
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    
   // NSLog(@"All of the known time zones are: ");
    
   // for (NSString*timeZoneName in [NSTimeZone knownTimeZoneNames]) {
    //    NSLog(@"%@",timeZoneName);
   // }
    
    
    
    [publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>*records,NSError*error){
    
        if(error){
            NSLog(@"Error: failed to retrieve data from database: %@",[error localizedDescription]);
        }
        
        for (CKRecord*record in records) {
           // NSLog(@"Record debug info: %@",[record description]);
            
            TouristSiteConfiguration* siteConfiguration = [[TouristSiteConfiguration alloc] initSimpleWithCKRecord:record];
            
            [siteConfiguration showOperatingHoursForSite];

           
            /**
            if([siteConfiguration isOpen]){
                NSLog(@"The %@ is Open.",placeName);
                
                NSLog(@"There are %@ hours until closing",[siteConfiguration timeUntilClosingString]);
                
            } else {
                NSLog(@"The %@ is Closed.",placeName);
                
                NSLog(@"There are %@ hours until opening",[siteConfiguration timeUntilOpeningString]);

            }
             **/
            
        }
    
    }];
    
}

@end
