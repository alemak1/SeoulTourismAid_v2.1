//
//  OCRController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "OCRController.h"
#import "Constants.h"


@interface OCRController () <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>

@end

@implementation OCRController

-(void)viewDidLoad{
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://vision.googleapis.com/v1/images:annotate?key=%@",GOOGLE_API_KEY];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    UIImage* image = [UIImage imageNamed:@"korean_road_sign"];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    
    NSString* base64encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    NSLog(@"The base64encoded string for the image is: %@",base64encodedString);
    
    NSDictionary* requestBodyDict = [self createRequestBodyDictionaryWith:base64encodedString];
    
    NSLog(@"The request body for the upload task is: %@",[requestBodyDict description]);
    
    NSData* requestBodyJSON = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSLog(@"The URL request object has been created: %@",[urlRequest description]);
    
    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionUploadTask* uploadTask = [urlSession uploadTaskWithRequest:urlRequest fromData:requestBodyJSON];
    
    
    
    [uploadTask resume];
    
    
}



#pragma mark NSURLSessionDelegate methods

/** Session-level authentication challenge **/

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    
    NSLog(@"Session became invalid with error: %@",[error localizedDescription]);
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    
}

#pragma mark NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
}



#pragma mark NSURLSessionDataTask delegate

/** Task-Level authentication challenge **/

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSURLProtectionSpace* protectionSpace = challenge.protectionSpace;

    NSString* host = protectionSpace.host;
    NSInteger port = protectionSpace.port;
    NSString* realm = protectionSpace.realm;
    
    NSLog(@"Attempting to authenticate with server with host name: %@, at port: %d, and at realm: %@",host,port,realm);
    
    NSURLCredential* proposedCredential = challenge.proposedCredential;
    
    if(proposedCredential){
        NSLog(@"Credentials are required for initiating session and data task.");
        
        NSLog(@"Information about proposed credential: %@",[proposedCredential description]);
        
        NSArray* certificatesArray = proposedCredential.certificates;

        
        if(!proposedCredential.hasPassword){
            NSLog(@"Prompt user for password.");
        }
    }

    
    NSError* authenticationError = challenge.error;
    
    if(authenticationError){
        NSLog(@"Authentication failed due to authentication error: %@",[authenticationError localizedDescription]);
        
        return;
    
    }
    
    NSURLResponse* failtureResponse = challenge.failureResponse;
    
    if(failtureResponse){
        
        NSString* responseURL = failtureResponse.URL.absoluteString;
        
        NSLog(@"Authentication failed with NSURL Failure Response info: %@. URL for failureResponse is %@",[failtureResponse description],responseURL);
        
        return;
    }

    
    
    
   
    /**
    protectionSpace.receivesCredentialSecurely
    
    protectionSpace.serverTrust
    **/
    
}


-(NSDictionary*)createRequestBodyDictionaryWith:(NSString*)base64encodedImageString{
    
    NSDictionary* imageDict = [NSDictionary dictionaryWithObjectsAndKeys:base64encodedImageString,@"content", nil];
    
    NSDictionary* featuresDict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"TEXT_DETECTION",@"type",@1,@"maxResults", nil];
    
    NSArray* featuresArray = [NSArray arrayWithObjects:featuresDict1, nil];
    
    NSDictionary* imageContextDict = [NSDictionary dictionaryWithObjectsAndKeys:@[@"ko"],@"languageHints", nil];
    
    NSDictionary* nestedDictionary = [NSDictionary dictionaryWithObjectsAndKeys:imageDict,@"image",featuresArray,@"features",imageContextDict,@"imageContext", nil];
    
    NSArray* array = [NSArray arrayWithObjects:nestedDictionary, nil];
    
    NSDictionary* requestBodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:array,@"requests", nil];
    
    return requestBodyDictionary;
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if(error){
        NSLog(@"Session completed with error: %@",[error description]);
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    NSLog(@"Already sent total bytes: %lld, Expected to send %lld more total bytes",totalBytesSent,totalBytesExpectedToSend);
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics{
    
    
}



-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
}



-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSLog(@"Data received",[data description]);
}


@end
