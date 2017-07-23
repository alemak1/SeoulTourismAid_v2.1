//
//  LanguageTranslationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "LanguageTranslationController.h"

#import "OCRController.h"
#import "Constants.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>
#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>


@interface LanguageTranslationController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *sourceLanguageTextView;

@property (weak, nonatomic) IBOutlet UILabel *translatedTextLabel;

@property NSString* sourceText;

- (IBAction)translateToKorean:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


@implementation LanguageTranslationController

-(void)viewDidLoad{
    
    [self.activityIndicator setHidden:YES];
    
    
    
}


-(void)performTranslationsOnSourceText:(NSString*)text andTargetLanguage:(NSString*)targetLanguage{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    /** Convert the captured image into a base64encoded string which can be submitted via the HTTP body to Google Servers **/
    
   
   
    NSDictionary* requestBodyDict = @{
                                  @"q":text,
                                  @"target":targetLanguage
                                  };
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURL* url = [NSURL URLWithString:GOOGLE_TRANSLATE_BASE_URL_ENDPOINT];
    
    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    /** Set the HTTP Method as POST **/
    
    [request setHTTPMethod:@"POST"];
    
    /** Set Content-Type Header to 'application/json' **/
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    /** Set the Request Data in the HTTP Body **/
    
    [request setHTTPBody:postData];
    
    /** Set the access key as the value for 'authorizaiton' in a separate authorization header **/
    NSString* authValue = [NSString stringWithFormat:@"Bearer %@",fromKeychainAuthorization.authState.lastTokenResponse.accessToken];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    /** Initialize fetcher object with an NSURL request **/
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    [fetcher setUseUploadTask:YES];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Checks for an error.
        
        
        
        // Parses the JSON response.
        NSError *jsonError = nil;
        NSDictionary* jsonDict =
        [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        // JSON error.
        if (jsonError) {
            NSLog(@"JSON decoding error %@", jsonError);
            return;
        }
        
        NSString* translatedText = [self parseJSONResponseForTranslatedText:jsonDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.translatedTextLabel setText:translatedText];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            [self.translatedTextLabel setHidden:NO];
            
        });
        
        // Success response!
        NSLog(@"Success: %@", jsonDict);
    }];
    
}


- (IBAction)translateToKorean:(UIButton *)sender {
    
    if(!self.sourceText){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No text entered." message:@"Please enter the text that you want to translate in the text box in order to translate into Korean." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString* sourceText = self.sourceText;
    
    NSLog(@"Source text is: %@",sourceText);
    
    [self performTranslationsOnSourceText:sourceText andTargetLanguage:@"ko"];
    
    [self.sourceLanguageTextView resignFirstResponder];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.translatedTextLabel setHidden:YES];
}

-(NSString*)parseJSONResponseForTranslatedText:(NSDictionary*)jsonDict{
    
    NSString* unavailableMessage = @"No translation available for entered text";
    
    NSDictionary* dataDict = jsonDict[@"data"];
    
    if(!dataDict){
        return unavailableMessage;
    }
    
    NSArray* translationsArray = dataDict[@"translations"];
    
    if(!translationsArray){
        return unavailableMessage;
    }
    
    NSDictionary* translationDict = [translationsArray firstObject];
    
    if(!translationDict){
        
        return unavailableMessage;
    }
    
    NSString* translatedText = translationDict[@"translatedText"];
    
    if(translatedText){
        return translatedText;
    } else {
        return unavailableMessage;
    }
    
}

#pragma mark ***** TEXTVIEW DELEGATE METHODS

-(void)textViewDidChange:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];
    
    [self.sourceLanguageTextView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];

}

@end
