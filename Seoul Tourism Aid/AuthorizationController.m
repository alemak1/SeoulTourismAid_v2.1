//
//  AuthorizationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "AuthorizationController.h"
#import "Constants.h"
#import "AppDelegate.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>

#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>

#import "LanguageHelpOptionsController.h"

@interface AuthorizationController ()

@property(nonatomic, strong, nullable) OIDAuthState* authState;
@property(nonatomic, nullable) GTMAppAuthFetcherAuthorization *authorization;


@end

@implementation AuthorizationController

-(void)viewDidAppear:(BOOL)animated{
    
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    if(fromKeychainAuthorization){
        [self dismissViewControllerAnimated:YES completion:^{
        
            [self.presentingViewController showViewController:self.nextViewController sender:nil];
        
        }];
        return;
    } else {
        
        
        /** Get authentication request **/
        
        NSURL *authorizationEndpoint = [NSURL URLWithString:kGoogleAuthorizationEndpoint];
        NSURL *tokenEndpoint = [NSURL URLWithString:kGoogleTokenEndpoint];
        
        /** Get service configuration object **/
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc]
         initWithAuthorizationEndpoint:authorizationEndpoint
         tokenEndpoint:tokenEndpoint];
        
        /** Build authentication request **/
        
        OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
            clientId:kClientID
            scopes:@[kGoogleTranslationAPIScope,kGoogleCloudServicesScope]
            redirectURL:[NSURL URLWithString:kRedirectURL]
            responseType:OIDResponseTypeCode
            additionalParameters:nil];
        
        /** Perform authentication request **/
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.currentAuthorizationFlow =
        [OIDAuthState authStateByPresentingAuthorizationRequest:request presentingViewController:self callback:^(OIDAuthState *_Nullable authState,NSError *_Nullable error) {
            if (authState) {
                // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
                GTMAppAuthFetcherAuthorization *authorization =
                [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:authState];
                
                self.authorization = authorization;
                
                /** Serialize authorization in iOS keychain **/
                
                [GTMAppAuthFetcherAuthorization saveAuthorization:self.authorization toKeychainForName:kGTMAppAuthAuthorizerKey];
                
                NSLog(@"Got authorization tokens. Access token: %@",
                      authState.lastTokenResponse.accessToken);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        
                        UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
                        
                        LanguageHelpOptionsController* languageOptionsController = [storyboardC instantiateViewControllerWithIdentifier:@"LanguageOptionsController"];
                        
                        [self.presentingViewController presentViewController:languageOptionsController animated:YES completion:nil];
                        
                        //[[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_USER_AUTHORIZATION_NOTIFICATION object:nil];

                    }];
                    
                    
               
                });
                
                
            } else {
                NSLog(@"Authorization error: %@", [error localizedDescription]);
                self.authorization = nil;
            }
            
        }];
        
    }

    
    
}


-(void)viewDidLoad{
    
    
}


-(OIDAuthorizationRequest*)getOIDAuthorizationRequeset{
    NSURL *authorizationEndpoint = [NSURL URLWithString:kGoogleAuthorizationEndpoint];
    NSURL *tokenEndpoint = [NSURL URLWithString:kGoogleTokenEndpoint];
    
    /** Get service configuration object **/
    OIDServiceConfiguration *configuration =
    [[OIDServiceConfiguration alloc]
     initWithAuthorizationEndpoint:authorizationEndpoint
     tokenEndpoint:tokenEndpoint];
    
    /** Build authentication request **/
    
    OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
        clientId:kClientID
        scopes:@[kGoogleTranslationAPIScope,kGoogleCloudServicesScope]
        redirectURL:[NSURL URLWithString:kRedirectURL]
        responseType:OIDResponseTypeCode
        additionalParameters:nil];
    
    return request;
    
}



@end
