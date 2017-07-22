//
//  OCRController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "OCRController.h"
#import "Constants.h"
#import "MediaPickerManagerDelegate.h"
#import "MediaPickerManager.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>
#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>


@interface OCRController () <MediaPickerManagerDelegate>



- (IBAction)presentImagePickerController:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UILabel *translatedTextLabel;



@property (readonly) MediaPickerManager* mediaPickerManager;

@property (nonatomic,weak)id<MediaPickerManagerDelegate> delegate;



@end


@implementation OCRController

@synthesize delegate;
@synthesize mediaPickerManager = _mediaPickerManager;


-(void)viewDidLoad{
    

    
    
}


-(void)mediaPickerManager:(MediaPickerManager *)manager didFinishPickingImage:(UIImage *)image{
    
    
    //Perform API call to Google Vision API
    
    [self performOCRAnalysisOnJPEGImage:image];

    
    //Use core image to crop the bounding box containing the relevant text
    
    
    [manager dismissImagePickerController:YES withCompletionHandler:^{
    
        //Store reference to image
        
        //Set text display with text in image
        
        [self.imageView setImage:image];
    
    }];
}

- (IBAction)presentImagePickerController:(UIButton *)sender {
    
    [self.mediaPickerManager presentImagePickerController:YES];
}

-(MediaPickerManager *)mediaPickerManager{
    
    if(_mediaPickerManager == nil){
        
        _mediaPickerManager = [[MediaPickerManager alloc] initWithPresentingViewController:self];
        
        [_mediaPickerManager setDelegate:self];
    }
    
    return _mediaPickerManager;
    
}


-(void)performOCRAnalysisOnJPEGImage:(UIImage*)image{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    /** Convert the captured image into a base64encoded string which can be submitted via the HTTP body to Google Servers **/
    
    self.imageView.image = image;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    NSData* imgData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
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

@end
