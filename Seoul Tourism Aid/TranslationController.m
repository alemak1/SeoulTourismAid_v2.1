//
//  TranslationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TranslationController.h"
#import "Constants.h"



@interface TranslationController ()


@property (readonly) NSURL* baseURL;

@end



@implementation TranslationController

-(void)viewDidLoad{

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
@end
