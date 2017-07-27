//
//  CloudKitHelper.h
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef CloudKitHelper_h
#define CloudKitHelper_h

#import <CloudKit/CloudKit.h>
#import "TouristSiteConfiguration.h"
#import "WarMemorialAnnotation.h"
#import "WarMemorialNavigationController.h"

@interface CloudKitHelper : NSObject


/** Wrapper methods for CloudKit database query requests **/

-(void)performAnnotationQueryForAllTouristSitesWithCompletionHandler:(void(^)(NSArray<CKRecord*>*results,NSError*error))completion;

-(void)performAnnotationQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithCompletionHandler:(void(^)(NSArray<CKRecord*>*results,NSError*error))completion;

-(void)performQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler;

-(void)performLoopQueryForAllTouristSitesandWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler;

-(void)performLoopQueryWithTouristSiteCategory:(TouristSiteCategory)category andWithBatchCompletionHandler:(void(^)(CKRecord*record))batchCompletionHandler;

-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName forWarMemorialNavigationController:(WarMemorialNavigationController*)navigationController;

/**
-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName andWithCompletionHandler:(void(^)(NSMutableArray<WarMemorialAnnotation*>*results))completion;


-(void)performQueryOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion;

-(void)performQueryOnPublicDBForLookupField:(NSString*)lookupField andWithLookupValue:(NSString*)lookupValue andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion;

**/

@end

#endif /* CloudKitHelper_h */
