//
//  VideoSearchController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/3/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "VideoSearchController.h"

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

#import "AuthorizationController.h"
#import "AppDelegate.h"

@interface VideoSearchController ()

@property(nonatomic, strong, nullable) OIDAuthState* authState;
@property(nonatomic, nullable) GTMAppAuthFetcherAuthorization *authorization;


@end



@implementation VideoSearchController


-(void)viewDidAppear:(BOOL)animated{
    
  
    
}

-(void)viewDidLoad{
    
   
    if(!self.authorization){
        AuthorizationController* authorizationController = [[AuthorizationController alloc] init];
        
        [self presentViewController:authorizationController animated:YES completion:nil];
        
    }
    
    [self performYouTubeAPIRequest];

}


-(void)performYouTubeAPIRequest{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    /** Convert the captured image into a base64encoded string which can be submitted via the HTTP body to Google Servers **/
    
    
    NSString* baseURL = GOOGLE_YOUTUBE_BASE_URL_ENDPOINT;
    
    NSString* partVal = @"snippet";
    int maxResults = 25;
    NSString* keyword = @"Food";
    NSString* topicID = @"/m/07bxq";
    NSString* type = @"video";
    NSString* videoLicense = @"youtube";
    
    NSString* queryParameterString = [NSString stringWithFormat:@"part=%@&q=%@&maxResults=%d&type=video",partVal,keyword,maxResults];
    
    queryParameterString = [queryParameterString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

    NSString* modifiedURLString = [baseURL stringByAppendingString:queryParameterString];
    
    
    NSLog(@"Final url with query parameters: %@",modifiedURLString);
    
    NSURL* url = [NSURL URLWithString:modifiedURLString];
    
    
    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    /** Set the HTTP Method as POST **/
    
    [request setHTTPMethod:@"GET"];
    
    /** Set Content-Type Header to 'application/json' **/
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    /** Set the access key as the value for 'authorizaiton' in a separate authorization header **/
    NSString* authValue = [NSString stringWithFormat:@"Bearer %@",fromKeychainAuthorization.authState.lastTokenResponse.accessToken];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    /** Initialize fetcher object with an NSURL request **/
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    [fetcher setUseUploadTask:NO];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Checks for an error.
        
        
        
        // Parses the JSON response.
        NSError *jsonError = nil;
        
        if(data){
            NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableLeaves error:&jsonError];
            
            
            
            NSLog(@"jsonDict has following info: %@",[jsonDict description]);
            
            // JSON error.
            if (jsonError) {
                NSLog(@"JSON decoding error %@", jsonError);
                return;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                
            });
            
            // Success response!
            NSLog(@"Success: %@", jsonDict);
        } else {
            UIAlertController* alertController;
            
            if(error){
                
                NSLog(@"Error description: %@",[error localizedDescription]);
                NSLog(@"Error reason for failure key: %@",[error localizedFailureReason]);

                
                alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"An error occurred while trying to search for videos with the specified query parameters." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
            /**
            alertController = [UIAlertController alertControllerWithTitle:@"Unable to peform translation!" message:@"Check to make sure that an Internet/WiFi connection is available" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:YES completion:nil];
             **/
        }
        
        
    }];
    
}


-(GTMAppAuthFetcherAuthorization *)authorization{
    return [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
}

@end
