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
//#import "WarMemorialAnnotation.h"
//#import "WarMemorialNavigationController.h"

@interface CloudKitHelper : NSObject

/**
-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName forWarMemorialNavigationController:(WarMemorialNavigationController*)navigationController;


-(void)executeQueryOperationOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName andWithCompletionHandler:(void(^)(NSMutableArray<WarMemorialAnnotation*>*results))completion;


-(void)performQueryOnPublicDBWithNavigationRegionName:(NSString*)navigationRegionName andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion;

-(void)performQueryOnPublicDBForLookupField:(NSString*)lookupField andWithLookupValue:(NSString*)lookupValue andWithCompletionHandler: (void(^)(NSArray<WarMemorialAnnotation*>*results,NSError*error))completion;

**/

@end

#endif /* CloudKitHelper_h */
