//
//  ProductPriceDisplayController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "ProductPriceDisplayController.h"
#import "ProductPriceController.h"
#import "NSString+CurrencyHelperMethods.h"
#import "CurrencyType.h"
#import "ProductSearchController.h"

@interface ProductPriceDisplayController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;


@property (weak, nonatomic) IBOutlet UILabel *koreanPriceNumber;

@property (weak, nonatomic) IBOutlet UILabel *foreignPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *foreignPriceNumber;

@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;


@property (readonly) UIFont* defaultLabelFont;


@property (weak, nonatomic) IBOutlet UIButton *iPadMainMenuButton;

@property (weak, nonatomic) IBOutlet UIButton *iPhoneMainMenuButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation ProductPriceDisplayController

BOOL _didSelectCurrency = false;

@synthesize foreignPrice = _foreignPrice;
@synthesize  koreanPrice = _koreanPrice;
@synthesize productPriceDescription = _productPriceDescription;


-(BOOL)didSelectCurrency{
    return _didSelectCurrency;
}


-(void)viewDidLoad{
    
    BOOL _didSelectCurrency = false;

    [self.currencyPickerView setDelegate:self];
    [self.currencyPickerView setDataSource:self];
    
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
      
        [self.iPhoneMainMenuButton setHidden:YES];
        [self.iPhoneMainMenuButton setEnabled:NO];
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        
        [self.iPadMainMenuButton setEnabled:NO];
        [self.iPadMainMenuButton setHidden:YES];
    }
    
}


#pragma mark ********** PICKER VIEW DELEGATE AND DATA SOURCE METHODS

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString* currencyAbbreviation = [NSString getCurrencyAbbreviationForCurrencyType:(int)row];
    
    [self configureForeignCurrencyDisplayWithCurrencyAbbreviation:currencyAbbreviation];
    
    _didSelectCurrency = true;
    
}


-(void)configureForeignCurrencyDisplayWithCurrencyAbbreviation:(NSString*)currencyAbbreviation{
    
    [self setForeignCurrencyAbbreviation:currencyAbbreviation];
    
    ProductPriceController* priceCollectionController = [self.childViewControllers firstObject];
    
    [priceCollectionController setCurrentCurrencyCode:currencyAbbreviation];
    
    
    
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return 200;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return LAST_CURRENCY_INDEX;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [NSString getCurrencyNameForCurrencyType:(CurrencyType)row];
}

#pragma mark *********** ACCESSOR METHODS FOR EXPOSED PROPERTIES 

-(void)setForeignCurrencyAbbreviation:(NSString *)foreignCurrencyAbbreviation{
    
    
    NSString* foreignPriceString = [NSString stringWithFormat:@"Price(%@)",foreignCurrencyAbbreviation];
    
    NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.defaultLabelFont,NSFontAttributeName, nil];
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:foreignPriceString attributes:stringAttributes];
    
    [self.foreignPriceLabel setAttributedText:attributedString];
}


-(NSString *)foreignCurrencyAbbreviation{
    return [self.foreignPriceLabel text];
}

-(void)setForeignPrice:(NSNumber *)foreignPrice{
    
    CurrencyType currencyType =  (int)[self.currencyPickerView selectedRowInComponent:0];
    
    NSString* currencyAbbreviation = [NSString getCurrencyAbbreviationForCurrencyType:currencyType];
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setCurrencySymbol:currencyAbbreviation];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSString* numberString = [numberFormatter stringFromNumber:foreignPrice];
    
    NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.defaultLabelFont,NSFontAttributeName, nil];
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:numberString attributes:stringAttributes];
    
    [self.foreignPriceNumber setAttributedText:attributedString];
}

-(NSNumber *)foreignPrice{
    return _foreignPrice;
    
}



-(void)setKoreanPrice:(NSNumber *)koreanPrice{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setCurrencySymbol:@"KRW"];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSString* numberString = [numberFormatter stringFromNumber:koreanPrice];
    
    NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.defaultLabelFont,NSFontAttributeName, nil];
    
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:numberString attributes:stringAttributes];
    
    [self.koreanPriceNumber setAttributedText:attributedString];
}

-(void)setProductPriceDescription:(NSString *)productPriceDescription{
    
    [self.productDescriptionLabel setText:productPriceDescription];
    
    _productPriceDescription = productPriceDescription;
}

-(NSString *)productPriceDescription{
    return _productPriceDescription;
}

-(NSNumber *)koreanPrice{
    return _koreanPrice;
}


-(UIFont *)defaultLabelFont{
    return [UIFont fontWithName:@"Futura-Bold" size:17.0];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ProductSearchController* productSearchController = (ProductSearchController*)segue.destinationViewController;
    
    
    /** Get reference to the ProductPriceController childviewcontroller **/
    ProductPriceController* productPriceController = (ProductPriceController*)[self.childViewControllers firstObject];
    
    AssortedProductCategory currentAssortedProductCategory = [productPriceController getCurrentAssortedProductCategory];
    
   
    if([segue.identifier isEqualToString:@"showProductSearchControllerSegue"]){
        
        
        productSearchController.shouldPerformGoogleSearch = NO;
        
        productSearchController.assortedProductCategory = currentAssortedProductCategory;
        
        
        
        
    }
    
    if([segue.identifier isEqualToString:@"showProductSearchControllerSegue_googlePlaces"]){
        
        productSearchController.shouldPerformGoogleSearch = YES;
        
        productSearchController.assortedProductCategory = currentAssortedProductCategory;
        
    }
    
    
}



@end

