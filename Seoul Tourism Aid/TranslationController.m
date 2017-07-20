//
//  TranslationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TranslationController.h"
#import "Constants.h"

#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import "AppDelegate.h"

@interface TranslationController () <OIDAuthorizationUICoordinator>


@property (readonly) NSURL* baseURL;

@property(nonatomic, strong, nullable) OIDAuthState* authState;

@end



@implementation TranslationController

-(void)viewDidLoad{
    //Client ID
    //625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com
    //625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com
    
    //com.googleusercontent.apps.625367767692-j16r3608poe8amocse5j6rb58i2i47aq
    
    NSURL *authorizationEndpoint =
    [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/v2/auth"];
    NSURL *tokenEndpoint =
    [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"];
    
    
    NSURL *issuer = [NSURL URLWithString:@"https://accounts.google.com"];
    
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
        completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
                                                            
        
        if (!configuration) {
        NSLog(@"Error retrieving discovery document: %@",[error localizedDescription]);
            return;
        }
                                                            
            // perform the auth request...
            
            // builds authentication request
        OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
            clientId:@""
            scopes:@[OIDScopeOpenID,OIDScopeProfile]
            redirectURL:@""
            responseType:OIDResponseTypeCode
            additionalParameters:nil];
            
            // performs authentication request
            AppDelegate *appDelegate =
            (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request UICoordinator:self callback:^(OIDAuthState *_Nullable authState,NSError *_Nullable error) {
                
                if (authState) {
                    NSLog(@"Got authorization tokens. Access token: %@",authState.lastTokenResponse);
                    [self setAuthState:authState];
                } else {
                    NSLog(@"Authorization error: %@", [error localizedDescription]);
                    [self setAuthState:nil];
                }
            }];
    }];
    

    NSString* sourceText = @"나는 사과가 좋다";
    NSString* targetLanguage = @"en";
    
    NSDictionary* requestBodyDict = [NSDictionary dictionaryWithObjectsAndKeys:sourceText,@"q",targetLanguage,@"target", nil];
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        NSLog(@"Error occurred while serializing POST data %@",[error description]);
    }
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:self.baseURL];
    
    [urlRequest setHTTPMethod:@"POST"];
    
   // NSString* accessToken = @"ya29.ElqLBJpHyK7YCUsmXTK7Na-kVMGZ8vwLSSJTDeRPPKscCkjoDqiG9x7Ganu6L2O3vP9xwKxHPfTk-Aw8oDvGQaPjB8ppErfYyyOUln0D-RgYpLuX5okkWpzhUII";
    
   // NSString* authorizationValue = [NSString stringWithFormat:@"Bearer %@",accessToken];
    
    
    [urlRequest setHTTPBody:postData];
    // [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-TYpe"];
    //[urlRequest setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData*data,NSURLResponse*response,NSError*error){
    
        if(error){
            NSLog(@"Error occurred getting translation data: %@",[error description]);
        }
        
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            
            if(!(httpResponse.statusCode == 200)){
                
                NSLog(@"Failed to get requested data with status code: %ld",(long)httpResponse.statusCode);
                
                NSLog(@"HTTP Response description: %@",[httpResponse description]);
                
                NSLog(@"HTTP Response debug description: %@",[httpResponse debugDescription]);
            }
        }
                   
        if(!data){
            NSLog(@"Error: no response data available");
        }
        
        NSError* jsonError = nil;
        
        NSDictionary* reponseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if(error){
            NSLog(@"Error occurred converting JSON data to dictionary: %@",[jsonError description]);
        }
        
        NSArray* translations = [[reponseDict valueForKey:@"data"] valueForKey:@"translations"];
        
        for (NSDictionary*jsonDict in translations) {
            NSLog(@"Translated text available: %@",[jsonDict description]);
        }
        
        
    }];
    
    [dataTask resume];
}

-(NSURL *)baseURL{
    
    NSString* apiKey = @"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg";
    
    NSString* baseURLString = [NSString stringWithFormat:@"https://translation.googleapis.com/language/translate/v2?key=%@",apiKey];
    
    return [NSURL URLWithString:baseURLString];
}


- (BOOL)presentAuthorizationWithURL:(NSURL *)URL session:(id<OIDAuthorizationFlowSession>)session{
    
    return YES;
}

/*! @brief Dimisses the authorization UI and calls completion when the dismiss operation ends.
 @param animated Wheter or not the dismiss operation should be animated.
 @remarks Has no effect if no authorization UI is presented.
 @param completion The block to be called when the dismiss operations ends
 */
- (void)dismissAuthorizationAnimated:(BOOL)animated completion:(void (^)(void))completion{
    
}


@end
