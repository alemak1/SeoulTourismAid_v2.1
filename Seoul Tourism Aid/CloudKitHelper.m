//
//  CloudKitHelper.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "CloudKitHelper.h"


@interface CloudKitHelper ()


@property CKContainer* container;
@property CKDatabase* publicDB;
@property CKDatabase* privateDB;

@property NSOperationQueue* dbOperationQueue;
@property CKQueryCursor* queryCursor;

typedef void(^BatchCompletionHandler)(CKRecord*);
@property BatchCompletionHandler batchCompletionHandler;

@end


@implementation CloudKitHelper

NSOperationQueue* _dbOperationQueue;

-(instancetype)init{
    
    if(self = [super init]){
        self.container = [CKContainer containerWithIdentifier:@"iCloud.SeoulTourism"];
    
        self.publicDB = [self.container publicCloudDatabase];
        self.privateDB = [self.container privateCloudDatabase];
        
    }
    
    return self;
}

-(void)performLoopQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler{
    
    
    self.batchCompletionHandler = batchCompletionHandler;
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"category == %d",category];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    CKQueryOperation* operation = [[CKQueryOperation alloc] initWithQuery:query];
    
    [operation setResultsLimit:2];
    
    [operation setRecordFetchedBlock:^(CKRecord* record){
        
        batchCompletionHandler(record);
        
    }];
    
    [operation setQueryCompletionBlock:^(CKQueryCursor*cursor,NSError*error){
        
        
        if(error){
            NSLog(@"Error occurred during recursive iteration of query cursor: %@",[error localizedDescription]);
        }
        _queryCursor = cursor;
        
        
        [self performNextFetchOperation:_queryCursor andWithCompletionHandler:self.batchCompletionHandler];
        
        
    }];
    
    [self.publicDB addOperation:operation];
    
    
    
}




-(void)performQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler{
    
    
    self.batchCompletionHandler = batchCompletionHandler;
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"category == %d",category];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    CKQueryOperation* operation = [[CKQueryOperation alloc] initWithQuery:query];
    
    [operation setResultsLimit:2];
    
    [operation setRecordFetchedBlock:^(CKRecord* record){
    
        batchCompletionHandler(record);
    
    }];
    
    [operation setQueryCompletionBlock:^(CKQueryCursor*cursor,NSError*error){
    
        
        _queryCursor = cursor;
        
        [self addObserver:self forKeyPath:@"batchCompletionHandler" options:NSKeyValueObservingOptionNew context:nil];
        

    
        
    }];
    
    [self.publicDB addOperation:operation];
    
  
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"batchCompletionHandler"]){
        
        if(_queryCursor != nil){
            _queryCursor = [self performNextFetchOperation:_queryCursor andWithCompletionHandler:self.batchCompletionHandler];
        } else {
            [self removeObserver:self forKeyPath:@"batchCompletionHandler"];
            _queryCursor = nil;
        }
    }
}


-(CKQueryCursor*)performNextFetchOperation:(CKQueryCursor*)cursor andWithCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler{
    
    _queryCursor = cursor;

    CKQueryOperation* nextOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
    
    [nextOperation setResultsLimit:2];
    
    [nextOperation setRecordFetchedBlock:^(CKRecord* record){
        
        batchCompletionHandler(record);
        
    }];
    
    [nextOperation setQueryCompletionBlock:^(CKQueryCursor*cursor, NSError*error){
        
        _queryCursor = cursor;
        
       
    }];
    
    [self.publicDB addOperation: nextOperation];
    
    return _queryCursor;
}



-(void)performAnnotationQueryForAllTouristSitesWithCompletionHandler:(void(^)(NSArray<CKRecord*>*results,NSError*error))completion{
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    NSLog(@"Query initialized %@. Preparing to perform query...",[query description]);
    
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError*error){
        
        if(error){
            NSLog(@"Query failed with error: %@",[error localizedDescription]);
            completion(nil,error);
        }
        
        if(!results){
            NSLog(@"Error: results failed to load. No results available.");
            completion(nil,nil);
        }
        
        
        completion(results,nil);
        
        
    }];
}



-(void)performAnnotationQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithCompletionHandler:(void(^)(NSArray<CKRecord*>*results,NSError*error))completion{
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"category == %d",category];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"Annotation" predicate:predicate];
    
    NSLog(@"Query initialized %@. Preparing to perform query...",[query description]);
    

    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError*error){
    
        if(error){
            NSLog(@"Query failed with error: %@",[error localizedDescription]);
            completion(nil,error);
        }
        
        if(!results){
            NSLog(@"Error: results failed to load. No results available.");
            completion(nil,nil);
        }
        
        
        completion(results,nil);
    
    
    }];
}


-(NSOperationQueue *)dbOperationQueue{
    if(_dbOperationQueue == nil){
        _dbOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _dbOperationQueue;
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
