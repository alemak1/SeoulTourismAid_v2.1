//
//  IAPHelper.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"
#import "Constants.h"

@interface IAPHelper () <SKProductsRequestDelegate,SKPaymentTransactionObserver>



typedef void (^ProductsRequestCompletionHandler)(BOOL, NSArray<SKProduct*>*);

@property NSSet<NSString*>* productIdentifiers;
@property NSMutableSet<NSString*>* purchasedProductIdentifiers;
@property SKProductsRequest* productsRequest;
@property ProductsRequestCompletionHandler productsRequestCompletionHandler;
@property NSArray<SKProduct*>* availableProducts;
@property BOOL productListAvailable;

@end


@implementation IAPHelper

static NSString* const productIDforKoreanLanguageHelpAccess = @"com.AlexMakedonski.SeoulTourismAid.KoreanLanguageHelpAccessAlpha";



+(IAPHelper *)sharedHelper{
    static IAPHelper* sharedIAPHelper = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
    
        sharedIAPHelper = [[IAPHelper alloc] initWithProductIdentifier:[NSSet setWithObject:productIDforKoreanLanguageHelpAccess]];
        
    
    
    });
    
    return sharedIAPHelper;
    
}



-(instancetype)initWithProductIdentifier:(NSSet<NSString*>*)productIDs{
    
    self = [super init];
    
    if(self){
        
        self.productIdentifiers = productIDs;
        
        self.purchasedProductIdentifiers = [[NSMutableSet alloc] init];
        
        for (NSString*productIdentifier in productIDs) {
            
            BOOL purchased = [[NSUserDefaults standardUserDefaults] valueForKey:productIdentifier];
            
            if(purchased){
                [self.purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@",productIdentifier);
            } else {
                NSLog(@"Not yet purchased: %@",productIdentifier);

            }
            
        }
        
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    }
    
    return self;
}


-(void)requestKoreanLanguageFeatureProductList{
    
    [self requestProducts:^(BOOL hasProductList,NSArray<SKProduct*>*products){
    
        self.productListAvailable = hasProductList;

        self.availableProducts = hasProductList ? products : nil;
        
    }];
    
    
}

-(BOOL)purchaseFullKoreanLanguageHelpAccess{
    
    
    if(self.productListAvailable){
    
        SKProduct* product = [self.availableProducts firstObject];
    
        SKPayment* payment = [SKPayment paymentWithProduct:product];
    
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        return true;
        
    } else {
        
        [self requestKoreanLanguageFeatureProductList];
        
        [self purchaseFullKoreanLanguageHelpAccess];
        
        return false;
    }
}


-(void)purchaseKoreanLanguageHelpAccess:(SKProduct*)product{
    NSLog(@"Buying product %@",product.productIdentifier);

    SKPayment* payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)restorePurchases{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(BOOL)canMakePayments{
    
    return [SKPaymentQueue canMakePayments];

}

-(BOOL)isProductPurchased:(NSString*)productIdentifier{
    
    return [self.purchasedProductIdentifiers containsObject:productIdentifier];
}

-(void)requestProducts:(ProductsRequestCompletionHandler)completionHandler{
    [self.productsRequest cancel];
    
    self.productsRequestCompletionHandler = completionHandler;
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    
    self.productsRequest.delegate = self;
    
    [self.productsRequest start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    
    NSLog(@"Load list of products...");
    
     NSArray<SKProduct*>* products = response.products;
    
    if(self.productsRequestCompletionHandler){
        self.productsRequestCompletionHandler(YES, products);

    }
    
    [self clearRequestAndHandler];
    
    for (SKProduct*p in products) {
        NSLog(@"Found product: %@, %@, %f",p.productIdentifier,p.localizedTitle,p.productIdentifier.floatValue);
    }
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"Failed to load list of products.");
    
    NSLog(@"Error: %@",[error localizedDescription]);
    
    if(self.productsRequestCompletionHandler){
        self.productsRequestCompletionHandler(NO, nil);

    }
    
    [self clearRequestAndHandler];
}


-(void)clearRequestAndHandler{
    self.productsRequest = nil;
    self.productsRequestCompletionHandler = nil;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    for (SKPaymentTransaction*transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self complete:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self fail:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                break;
            case SKPaymentTransactionStateRestored:
                [self restore:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            default:
                break;
        }
    }
}

-(void)complete:(SKPaymentTransaction*)transaction{
    
    NSLog(@"complete...");
    
    [self deliverPurchaseNotificationFor:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}

-(void)restore:(SKPaymentTransaction*)transaction{
    
    NSLog(@"restore...%@",transaction.payment.productIdentifier);
    
    [self deliverPurchaseNotificationFor:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];


}

-(void)fail:(SKPaymentTransaction*)transaction{
    
    NSLog(@"fail...");

    if(transaction.error && transaction.error.code != SKErrorPaymentCancelled){
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


-(void)deliverPurchaseNotificationFor:(NSString*)identifier{
    if(identifier){
        
        [self.purchasedProductIdentifiers addObject:identifier];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:identifier];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IAP_HELPER_PURCHASE_NOTIFICATION object:identifier];
        
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    NSLog(@"Finished restoring previously completed transaciton");
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
    if(error){
        NSLog(@"Failed to restore previously completed transaciton");
        NSLog(@"Error: %@",[error localizedDescription]);

    }
}

@end
