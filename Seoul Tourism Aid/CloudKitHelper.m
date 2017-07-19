//
//  CloudKitHelper.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "CloudKitHelper.h"
//#import "WarMemorialNavigationController.h"

@interface CloudKitHelper ()


@property CKContainer* container;
@property CKDatabase* publicDB;
@property CKDatabase* privateDB;

@end


@implementation CloudKitHelper

-(instancetype)init{
    
    if(self = [super init]){
        self.container = [CKContainer defaultContainer];
    
        self.publicDB = [self.container publicCloudDatabase];
        self.privateDB = [self.container privateCloudDatabase];
        
    }
    
    return self;
}




/**

-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName forWarMemorialNavigationController:(__weak WarMemorialNavigationController*)navigationController{
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"navigationRegionName == %@",navigationRegionName];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"NavigationAidSite" predicate:predicate];
    
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    
    __block int progressCount = 0;
    __block int totalRecords = 30; //TODO: Depends on the recordType, can be preset based on the string identifier for the record type
    
    
    NSMutableArray* annotationsArray = [[NSMutableArray alloc] init];

    [queryOperation setQualityOfService:NSQualityOfServiceUserInitiated];
    [queryOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [queryOperation setTimeoutIntervalForRequest:10.00];
    [queryOperation setZoneID:nil];
    
    
    
    [queryOperation setRecordFetchedBlock:^(CKRecord*record){
        
        WarMemorialAnnotation* annotation = [[WarMemorialAnnotation alloc] initWithCKRecord:record];
        [annotationsArray addObject:annotation];
        progressCount++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [navigationController updateProgressViewWithProgress:(CGFloat)progressCount/(CGFloat)totalRecords];
                    
            
            
        });
       
        
        
    }];
    
    
    
    
    [queryOperation setCompletionBlock:^{
    
        NSLog(@"Annotations array results are %@",[annotationsArray debugDescription]);
        
        
        
        if(annotationsArray == nil){
            NSLog(@"Error: No results obtained from record fetching.");
            [navigationController loadWarMemorialAnnotationsArrayFromPlist];
            return;
        }
        
        
        if(annotationsArray.count < totalRecords*0.70){
            
            [navigationController loadWarMemorialAnnotationsArrayFromPlist];
            return;
        }
        
        navigationController.annotationStore = annotationsArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [navigationController updateUserInterfaceOnMainQueue];

        });
        
    }];
    
    [self.publicDB addOperation:queryOperation];
}

-(void)performQueryOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion{
    
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"navigationRegionName == %@",navigationRegionName];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"NavigationAidSite" predicate:predicate];
    
    NSLog(@"Query initialized %@. Preparing to perform query...",[query description]);
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError* error){
        
        NSLog(@"Communication with server established. Fetching results....");
        
        if(error){
            //If an error occurs in attempting to fetch the NavigationAidSite record, the plist with identical data can be used as a backup, and the images replaced with generic icons
            
            NSLog(@"An error occurred while fetching NavigationAidSite records: %@",[error localizedDescription]);
            completion(nil,error);
            return;
        }
        
        if(!results){
            NSLog(@"CKQuery failed: no results availalbe");
            return;
        }
        
        NSLog(@"Results obtained %@. Preparing to process records into annotations...",[results description]);
        
        NSMutableArray* annotationsArray = [[NSMutableArray alloc] init];
        
        for(CKRecord* record in results){
            WarMemorialAnnotation* annotation = [[WarMemorialAnnotation alloc] initWithCKRecord:record];
            
            NSLog(@"Processed new annotation with description %@",[annotation annotationDescription]);
            [annotationsArray addObject:annotation];
        }
        
        NSLog(@"The annotations have been downloaded from CloudKit with description: %@",[annotationsArray description]);
        
        completion(annotationsArray,nil);
        
    }];
    

}

-(void)performQueryOnPublicDBForLookupField:(NSString*)lookupField andWithLookupValue:(NSString*)lookupValue andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion{
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@",lookupField,lookupValue];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"NavigationAidSite" predicate:predicate];
    
    NSLog(@"Query initialized %@. Preparing to perform query...",[query description]);
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError* error){
    
        NSLog(@"Communication with server established. Fetching results....");
        
        if(error){
            //If an error occurs in attempting to fetch the NavigationAidSite record, the plist with identical data can be used as a backup, and the images replaced with generic icons
            
            NSLog(@"An error occurred while fetching NavigationAidSite records: %@",[error localizedDescription]);
            completion(nil,error);
            return;
        }
        
        if(!results){
            NSLog(@"CKQuery failed: no results availalbe");
            return;
        }
        
        NSLog(@"Results obtained %@. Preparing to process records into annotations...",[results description]);
        
        NSMutableArray* annotationsArray = [[NSMutableArray alloc] init];
        
        for(CKRecord* record in results){
            WarMemorialAnnotation* annotation = [[WarMemorialAnnotation alloc] initWithCKRecord:record];
            
            [annotationsArray addObject:annotation];
        }
        
        NSLog(@"The annotations have been downloaded from CloudKit with description: %@",[annotationsArray description]);
        
        completion(annotationsArray,nil);
    
    }];
    
}

**/


@end
