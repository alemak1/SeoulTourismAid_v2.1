//
//  LanguageHelpOptionsController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "LanguageHelpOptionsController.h"
#import "AuthorizationController.h"

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

#import "GooglePlaceManager.h"

@interface LanguageHelpOptionsController ()

@property(readonly)GTMAppAuthFetcherAuthorization* authorization;

@end

@implementation LanguageHelpOptionsController



-(void)viewDidLoad{

 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewControllerIfUnauthorized) name:DID_RECEIVE_USER_AUTHORIZATION_NOTIFICATION object:nil];
    
    if(!self.authorization){
        AuthorizationController* authorizationController = [[AuthorizationController alloc] init];
        
        [self presentViewController:authorizationController animated:YES completion:nil];
        
    }
    
    
   
    GooglePlaceManager* googlePlaceManager = [GooglePlaceManager sharedManager];
    
    [googlePlaceManager loadCategoryArrayWithUserDefinedCategory:Outdoor_NaturalSite andWithSinglePlaceItemCompletionHandler:^{
        NSLog(@"Another Natural Site finished loading");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.00 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [googlePlaceManager showDebugInfoForNaturalSites];
        
    });

    
}


-(void)dismissViewControllerIfUnauthorized{
    
    /** If the user is still unauthorized after providing the information to the Google OAuth consent-request screen, then the current view controller should be dismissed and services made unavailable to the user **/
    
    if(!self.authorization){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Translation Services Unavailable" message:@"Translation services (whether for recorded speech, photographed characters, or written text) are unavailable unless user is authorized through their Google Account" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:okay];
    
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)performDebugHTTPRequestForCloudVisionAPI{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    UIImage* jpegImg = [UIImage imageNamed:@"korean_road_sign"];
    NSData* imgData = UIImageJPEGRepresentation(jpegImg, 1.0);
    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary* contentDict = @{
                                  @"content":imgStr
                                  };
    
    NSDictionary* featureDict = @{
                                  @"type":@"TEXT_DETECTION",
                                  @"maxResults":@1
                                  };
    
    
    NSDictionary* request1 = @{
                               @"image":contentDict,
                               @"features": @[featureDict]
                               
                               };
    
    NSDictionary* postDict = @{@"requests":@[request1]};
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURL* url = [NSURL URLWithString:@"https://vision.googleapis.com/v1/images:annotate"];
    
    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString* authValue = [NSString stringWithFormat:@"Bearer %@",fromKeychainAuthorization.authState.lastTokenResponse.accessToken];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    [fetcher setUseUploadTask:YES];
    
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
}

-(GTMAppAuthFetcherAuthorization *)authorization{
    return [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
}

-(IBAction)unwindToLanguageHelpOptions:(UIStoryboardSegue *)segue{
    
}

@end
