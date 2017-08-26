//
//  IAPHelper.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef IAPHelper_h
#define IAPHelper_h

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPHelper : NSObject

+(IAPHelper*)sharedHelper;

-(void)requestKoreanLanguageFeatureProductList;

-(BOOL)purchaseFullKoreanLanguageHelpAccess;

-(BOOL)isProductPurchased:(NSString*)productIdentifier;

-(void)restorePurchases;

-(BOOL)canMakePayments;

@end

#endif /* IAPHelper_h */
