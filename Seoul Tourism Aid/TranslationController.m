//
//  TranslationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TranslationController.h"
#import "Constants.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>

#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>

#import "AppDelegate.h"
#import "Constants.h"
#import "WVController.h"

@interface TranslationController () <NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>


@property (readonly) NSURL* baseURL;

@property(nonatomic, strong, nullable) OIDAuthState* authState;
@property(nonatomic, nullable) GTMAppAuthFetcherAuthorization *authorization;

@property (nonatomic) NSOperationQueue* delegateQueue;

@end



@implementation TranslationController

@synthesize delegateQueue = _delegateQueue;
BOOL _authorizatonCompleted = false;

-(NSOperationQueue *)delegateQueue{
    if(_delegateQueue == nil){
        _delegateQueue = [[NSOperationQueue alloc] init];
    }
    
    return _delegateQueue;
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    //Client ID
    //625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com
    //625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com
    
    //com.googleusercontent.apps.625367767692-j16r3608poe8amocse5j6rb58i2i47aq
 
   
    /** Send request for authorization to Google's OAuth2.0 server **/

    
    
  //  NSString* authorizationRequestURL = [NSString stringWithFormat: @"https://accounts.google.com/o/oauth2/v2/auth?scope=email%@profile&response_type=code&redirect_uri=%@:/oauth2redirect&client_id=%@",@"%20",REDIRECT_URL,CLIENT_ID];
    

    
    //NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"bgSession"];
    
/**
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.delegateQueue];
    
    [[session dataTaskWithURL:authURL] resume];
    
    **/
    
    /**
    [[session dataTaskWithURL:authURL completionHandler:^(NSData*data,NSURLResponse*response,NSError*error){
    
        if(error){
            NSLog(@"Error with %@",[error localizedDescription]);
        }
  
        NSError* jsonError = nil;
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        
        if(jsonError){
            NSLog(@"JSON Error occurred: %@",[jsonError description]);
        }
        
        NSLog(@"JSON dict info: %@",[jsonDict description]);
        
    }] resume];
    **/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performDebugHTTPRequestWithOIDTokenResponse:) name:@"STAppLaunchedWithURLNotification" object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(!_authorizatonCompleted){
    NSURL *authorizationEndpoint =
    [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/v2/auth"];
    NSURL *tokenEndpoint =
    [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"];
    
    OIDServiceConfiguration *configuration =
    [[OIDServiceConfiguration alloc]
     initWithAuthorizationEndpoint:authorizationEndpoint
     tokenEndpoint:tokenEndpoint];
    
    // builds authentication request
    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
        clientId:@"625367767692-j16r3608poe8amocse5j6rb58i2i47aq.apps.googleusercontent.com"
        scopes:@[@"https://www.googleapis.com/auth/cloud-translation"]
        redirectURL:[NSURL URLWithString:@"com.googleusercontent.apps.625367767692-j16r3608poe8amocse5j6rb58i2i47aq:/oauthredirect"]
        responseType:OIDResponseTypeCode
        additionalParameters:nil];
    
    
    // performs authentication request
    
    NSLog(@"Preparing to make authorization request to Google authorization server...");
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.currentAuthorizationFlow =
    [OIDAuthState authStateByPresentingAuthorizationRequest:request presentingViewController:self callback:^(OIDAuthState *_Nullable authState,NSError *_Nullable error) {
        if (authState) {
            // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
            GTMAppAuthFetcherAuthorization *authorization =
            [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
            
            self.authorization = authorization;
            _authorizatonCompleted = true;
            NSLog(@"Got authorization tokens. Access token: %@",
                  authState.lastTokenResponse.accessToken);
            
        } else {
            NSLog(@"Authorization error: %@", [error localizedDescription]);
            self.authorization = nil;
        }
        
    }];
    
    } else {
        [self performDebugHTTPRequestWithOIDTokenResponse];
    }
}


-(void)performDebugHTTPRequestWithOIDTokenResponse{
    
    NSLog(@"Preparing to make API request..");
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = self.authorization;
    
    
    NSString* sourceText = @"나는 사과가 좋다";
    NSString* targetLanguage = @"en";
    
   NSDictionary* requestBodyDict = [NSDictionary dictionaryWithObjectsAndKeys:sourceText,@"q",targetLanguage,@"target", nil];
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    
    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:self.baseURL];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSString* authValue = [NSString stringWithFormat:@"Bearer %@",self.authorization.authState.lastTokenResponse.accessToken];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Checks for an error.
        /**
        if (error) {
            // OIDOAuthTokenErrorDomain indicates an issue with the authorization.
            if ([error.domain isEqual:OIDOAuthTokenErrorDomain]) {
                self.authorization = nil;
                NSLog(@"Authorization error during token refresh, clearing state. %@",
                      [error localizedDescription]);
                // Other errors are assumed transient.
            } else {
                NSLog(@"Transient error during token refresh. %@", [error localizedDescription]);
            }
            return;
        }
        **/
        
        // Parses the JSON response.
        NSError *jsonError = nil;
        id jsonDictionaryOrArray =
        [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        // JSON error.
        if (jsonError) {
            NSLog(@"JSON decoding error %@", jsonError);
            return;
        }
        
        // Success response!
        NSLog(@"Success: %@", jsonDictionaryOrArray);
    }];
    /**
    NSLog(@"Performing debug HTPP Request with sample translation data...");
    
    NSString* sourceText = @"나는 사과가 좋다";
    NSString* targetLanguage = @"en";
    
    NSDictionary* requestBodyDict = [NSDictionary dictionaryWithObjectsAndKeys:sourceText,@"q",targetLanguage,@"target", nil];
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        NSLog(@"Error occurred while serializing POST data %@",[error description]);
    }
    
    NSString* accessToken = self.authState.lastTokenResponse.accessToken;
    
    NSString* accessTokenParameter = [NSString stringWithFormat:@"&access_token=%@",accessToken];
    
    NSString* modifiedURLString = [self.baseURLString stringByAppendingString:accessTokenParameter];
    
    NSURL* modifiedURL = [NSURL URLWithString:modifiedURLString];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:modifiedURL];
    
    [urlRequest setHTTPMethod:@"POST"];
    
   // NSString* authorizationValue = [NSString stringWithFormat:@"Bearer %@",accessToken];
    
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-TYpe"];
   // [urlRequest setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    //NSURLSessionUploadTask* uploadTask = [urlSession uploadTaskWithRequest:urlRequest fromData:postData];
    
    
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
     **/
}


-(NSURL *)baseURL{
    
    //NSString* apiKey = @"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg";
    
    //NSString* baseURLString = [NSString stringWithFormat:@"https://translation.googleapis.com/language/translate/v2?key=%@",apiKey];
    
    //return [NSURL URLWithString:baseURLString];
    
    NSString* rawString = @"사과";
    NSString* encodedString = [rawString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString* webURL = [NSString stringWithFormat:@"https://translation.googleapis.com/language/translate/v2?target=en&source=ko&q=%@",encodedString];
    
    return [NSURL URLWithString:webURL];
}


-(NSString*)baseURLString{
    
   // NSString* apiKey = @"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg";
    
    //return [NSString stringWithFormat:@"https://translation.googleapis.com/language/translate/v2?key=%@",apiKey];
 
    return @"https://translation.googleapis.com/language/translate/v2";
}

/**
- (BOOL)presentAuthorizationWithURL:(NSURL *)URL session:(id<OIDAuthorizationFlowSession>)session{
    NSLog(@"Will present authorization with URL: %@",[URL absoluteString]);

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSDictionary* urlOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"com.AlexMakedonski.Seoul-Tourism-Aid",UIApplicationOpenURLOptionsSourceApplicationKey, nil];
    
    [appDelegate application:[UIApplication sharedApplication] openURL:URL options:urlOptions];
    
    return YES;
}
**/
/*! @brief Dimisses the authorization UI and calls completion when the dismiss operation ends.
 @param animated Wheter or not the dismiss operation should be animated.
 @remarks Has no effect if no authorization UI is presented.
 @param completion The block to be called when the dismiss operations ends
 */

/**
- (void)dismissAuthorizationAnimated:(BOOL)animated completion:(void (^)(void))completion{
    
}

**/
@end
