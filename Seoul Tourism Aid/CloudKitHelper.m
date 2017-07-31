//
//  CloudKitHelper.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "CloudKitHelper.h"
#import "WarMemorialNavigationController.h"

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



-(void)performFetchFromPublicDBforRecordID:(CKRecordID*)recordID andCompletionHandler:(void(^)(CKRecord*record,NSError*error))handler{
    
    [self.publicDB fetchRecordWithID:recordID completionHandler:^(CKRecord* record,NSError*error){
    
        if(error){
            
            NSLog(@"Error: unable to fetch record: %@",[error description]);
            handler(nil,error);
            return;
        }
        
        if(record){
            handler(record,nil);
            return;
        } else {
            NSLog(@"Error: no results available for recordID %@",recordID.recordName);
            handler(nil,nil);
            return;
        }
    }];
    
    
}

-(void)performLoopQueryForAllTouristSitesandWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler{
    
    
    self.batchCompletionHandler = batchCompletionHandler;
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    
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


-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName forWarMemorialNavigationController:(__weak WarMemorialNavigationController*)navigationController{
    
    NSLog(@"Preparing to perform query on CloudKit public database...");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"navigationArea == %@",navigationRegionName];
    
    NSLog(@"Predicate initialized. Initializing query...");
    
    CKQuery* query = [[CKQuery alloc] initWithRecordType:@"AbbreviatedAnnotation" predicate:predicate];
    
    
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    
    __block int progressCount = 0;
    __block int totalRecords = 35; //Depends on the RecordType, current number is arbitrary
    
    
    NSMutableArray* annotationsArray = [[NSMutableArray alloc] init];

    [queryOperation setQualityOfService:NSQualityOfServiceUserInitiated];
    [queryOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [queryOperation setTimeoutIntervalForRequest:10.00];
    [queryOperation setZoneID:nil];
    
    
    
    [queryOperation setRecordFetchedBlock:^(CKRecord*record){
        
        NSLog(@"Initializing an annotation from a CKRecord...");
        
        WarMemorialAnnotation* annotation = [[WarMemorialAnnotation alloc] initWithCKRecord:record];
        
        [annotationsArray addObject:annotation];
        
        NSLog(@"Updating the progress count...");
        
        progressCount++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Preparing to update the progress view of the navigation controller");
            
            [navigationController updateProgressViewWithProgress:(CGFloat)progressCount/(CGFloat)totalRecords];
                    
            
            
        });
       
        
        
    }];
    
    
    
    
    [queryOperation setCompletionBlock:^{
    
        NSLog(@"Annotations array results are %@",[annotationsArray debugDescription]);
        
        /** If the annotations array is empty upon completing the CKOperation, perhaps due to a timeout or a bad connection, then the annotations array (i.e. data source) for the WarMemorailNavigation aid controller can still be obtained from a back-up plist **/
        
        if(annotationsArray == nil){
            NSLog(@"Error: No results obtained from record fetching.");
            [navigationController loadWarMemorialAnnotationsArrayFromPlist];
            return;
        }
        
      
        
        /** Load the downloaded annotations array into the NavigationController **/
        
        NSLog(@"Checking the downloaded annotations...");
        
        navigationController.annotationStore = annotationsArray;
        
        for (WarMemorialAnnotation*annotation in annotationsArray) {
            NSLog(@"Annotation Information: %@",[annotation description]);
        }
        
        /** Load the annotations from the annotation store into the MapView **/
        
        [navigationController loadAnnotations];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Preparing to update the WarMemorialNavigationController on the main queue");
            
            [navigationController updateUserInterfaceUponDownloadCompletion];

        });
        
    }];
    
    [self.publicDB addOperation:queryOperation];
}

/**
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
