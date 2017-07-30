//
//  ProductPriceController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "ProductPriceController.h"
#import "ProductPriceDisplayController.h"
#import "ProductCategory.h"
#import "NSString+CurrencyHelperMethods.h"
#import "KoreanProduct.h"
#import "KoreanProductCell.h"
#import "UserLocationManager.h"

@interface ProductPriceController ()


@property NSDictionary* currencyExchangeData;
@property NSURLSession* apiRequestSession;
@property (readonly) double currentExchangeRate;

@property NSArray<KoreanProduct*>* koreanProductsArray;

@end

@implementation ProductPriceController

AssortedProductCategory _currentAssortedProductCategory = 0;

static void* ProductPriceControllerContext = &ProductPriceControllerContext;
static void* CurrencyCodeContext = &CurrencyCodeContext;

@synthesize currentExchangeRate = _currentExchangeRate;


-(void)viewWillLayoutSubviews{
    UserLocationManager* sharedLocationManager = [UserLocationManager sharedLocationManager];
    
    [sharedLocationManager requestAuthorizationAndStartUpdates];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadCurrencyExchangeData];
    
    [self loadKoreanProductsArray];

    [self addObserver:self forKeyPath:@"currencyExchangeData" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:ProductPriceControllerContext];
    
    [self addObserver:self forKeyPath:@"currentCurrencyCode" options:NSKeyValueObservingOptionNew context:CurrencyCodeContext];
}



-(void)viewDidLoad{
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDataSource:self];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if(context == ProductPriceControllerContext){
        
     NSLog(@"The value of the currency exchange dictionary changed. It's value is now: %@",[self.currencyExchangeData description]);
        
        NSDictionary* ratesDict = [self.currencyExchangeData valueForKey:@"rates"];
        
        _currentExchangeRate = [[ratesDict valueForKey:self.currentCurrencyCode] doubleValue];
    }
    
    if(context == CurrencyCodeContext){
        
        NSDictionary* ratesDict = [self.currencyExchangeData valueForKey:@"rates"];
        
        _currentExchangeRate = [[ratesDict valueForKey:self.currentCurrencyCode] doubleValue];
        
        
    
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.apiRequestSession invalidateAndCancel];
    
    [self removeObserver:self forKeyPath:@"currencyExchangeData"];
    
    [self removeObserver:self forKeyPath:@"currentCurrencyCode"];
}


#pragma mark TABLEVIEW DATASOURCE AND DELEGATE METHODS

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return LAST_ASSORTED_PRODUCT_INDEX;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    KoreanProductCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"KoreanProductCell" forIndexPath:indexPath];
    
   
    NSString* imagePath = [NSString getAssortedProductImagePathFor:indexPath.row];
    

    cell.image = [UIImage imageNamed:imagePath];
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductPriceDisplayController* productPriceDisplayController = (ProductPriceDisplayController*)self.parentViewController;
    
    if(!productPriceDisplayController.didSelectCurrency){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No currency selected!" message:@"Please first select a currency in order to see product prices" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    KoreanProduct* randomlySelectedProduct = [self getRandomKoreanProductForIndexPath:indexPath];
    
    CGFloat productPrice = [[randomlySelectedProduct priceInKRW] floatValue];
   
    [self setProductDescriptionLabelWithProduct:randomlySelectedProduct];
    
    [self setProductPriceWithKRWPrice:productPrice];
    
    
    [self setCurrentAssortedProductCategory:(AssortedProductCategory)indexPath.row];
}




-(void)setCurrentAssortedProductCategory:(AssortedProductCategory)assortedProductCategory{
    _currentAssortedProductCategory = assortedProductCategory;
}

-(AssortedProductCategory)getCurrentAssortedProductCategory{
    return _currentAssortedProductCategory;
}

#pragma mark NSURL SESSION/NSURL DATA TASK UTILITY FUNCTIONS

-(void) loadCurrencyExchangeData{
    
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.apiRequestSession = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    
    NSURL* urlAddress = [NSURL URLWithString:@"https://api.fixer.io/latest?base=KRW"];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:urlAddress];
    
    NSURLSessionDataTask* dataTask = [self.apiRequestSession dataTaskWithRequest:urlRequest completionHandler:^(NSData* data, NSURLResponse* response, NSError* error){
        
        
        if(error){
            NSLog(@"Error: failed to download data with error description: %@",[error description]);
        }
        
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            
            if(httpResponse.statusCode == 200){
                
                self.currencyExchangeData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Currency exchange data %@",[_currencyExchangeData description]);
                    
                    
                });

                
                
            } else {
                NSLog(@"Unable to access data from server, status code: %ld",httpResponse.statusCode);
            }
        }
        
    }];
    
    [dataTask resume];
}


-(void) loadKoreanProductsArray{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"KoreanProducts" ofType:@"plist"];
    
    NSArray* dictArray = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray* koreanProductsArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dict in dictArray){
        
        [koreanProductsArray addObject:[[KoreanProduct alloc] initWithDictionary:dict]];
        
    }
    
    self.koreanProductsArray = [NSArray arrayWithArray:koreanProductsArray];
    
}

-(KoreanProduct*)getRandomKoreanProductForIndexPath:(NSIndexPath*)indexPath{
    
    AssortedProductCategory selectedCategory = (AssortedProductCategory)indexPath.row;
    
    NSArray* productArrayForCategory = [self.koreanProductsArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(KoreanProduct* koreanProduct, NSDictionary* bindings){
        
        
        NSLog(@"Korean product info %@",koreanProduct);
        NSLog(@"Assorted Category is: %d",koreanProduct.assortedCategory);
        
        return koreanProduct.assortedCategory == selectedCategory;
        
    }]];
    
    
    
    NSInteger numberOfProductsInCategory = [productArrayForCategory count];
    
    NSInteger randomIndex = arc4random_uniform((UInt32)numberOfProductsInCategory);
    
    
    return [productArrayForCategory objectAtIndex:randomIndex];
    
}

-(void)setProductDescriptionLabelWithProduct:(KoreanProduct*)product{
    
    NSString* productName = [product name];
    NSString* productBrand = [product brand];
    NSString* productQuantity = [product unityQuantity];
    
    NSString* description = [NSString stringWithFormat:@"Product Name: %@ (%@), Info: %@",productName,productBrand,productQuantity];
    
    [self setProductDescriptionLabelWithText:description];
    
}

-(void)setProductDescriptionLabelWithText:(NSString*)labelText{
    
    ProductPriceDisplayController* productPriceDisplayController = (ProductPriceDisplayController*)self.parentViewController;
    
    productPriceDisplayController.productPriceDescription = labelText;
}

-(void)setProductPriceWithKRWPrice:(CGFloat)krwPrice{
    //Test Code (for debug purposes)
    
    ProductPriceDisplayController* parentController = (ProductPriceDisplayController*)self.parentViewController;
    
    [parentController setKoreanPrice:[NSNumber numberWithFloat:krwPrice]];
    [parentController setForeignPrice:[NSNumber numberWithFloat:krwPrice*self.currentExchangeRate]];
    
}

-(double)currentExchangeRate{
    return _currentExchangeRate;
}

@end

/**
 
 MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
 request.naturalLanguageQuery = [self.locationSearchBar text];
 
 request.region = [self.mainMapView region];
 
 // Create and initialize a search object.
 MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
 
 // Start the search and display the results as annotations on the map.
 [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
 {
 NSMutableArray *placemarks = [NSMutableArray array];
 for (MKMapItem *item in response.mapItems) {
 [placemarks addObject:item.placemark];
 }
 
 [self.mainMapView removeAnnotations:[self.mainMapView annotations]];
 [self.mainMapView showAnnotations:placemarks animated:NO];
 }
 
 ];

 
 
 **/


/** This code is for use in iOS education tutorials:

 NSLog(@"From viewDidLoad, currencyExchangeData %@",[self.currencyExchangeData description]);
 
 [NSThread sleepForTimeInterval:3.00];
 
 NSLog(@"From viewDidLoad, after 3 second sleep, currencyExchangeData %@",[self.currencyExchangeData description]);
 
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.00 * NSEC_PER_SEC));
 
 dispatch_after(popTime, dispatch_get_main_queue(), ^{
 
 NSLog(@"From viewDidLoad, after 3 second wait period, currencyExchangeData %@",[self.currencyExchangeData description]);
 
 
 });

**/
