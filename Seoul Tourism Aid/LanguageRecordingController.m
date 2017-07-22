//
//  LanguageRecordingController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "LanguageRecordingController.h"
#import "Constants.h"

#import "Constants.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>
#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>


@interface LanguageRecordingController () <AVAudioRecorderDelegate>

@property AVAudioRecorder* recorder;
@property NSString* recorderFilePath;
@property NSData* audioData;

/** IBOutlets **/

- (IBAction)startRecording:(UIButton *)sender;

- (IBAction)stopRecording:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *translateToKorean;

- (IBAction)translateToKorean:(UIButton *)sender;


@end

@implementation LanguageRecordingController

CGFloat _recordingSampleRate = 44100.0;

-(void)viewDidLoad{
    
    _recordingSampleRate = 44100.0;
}


-(void)startRecording{
    
    /**
    if([self.recorder isRecording]){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Recording already in progress. Would you like to stop the current recording?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* stopRecording = [UIAlertAction actionWithTitle:@"Stop Recording" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        
            [self stopRecording];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:stopRecording];
        [alertController addAction:cancel];

        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        return;
    }
    
    **/
    
    
    NSLog(@"Staring recording...");
    
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    
    NSError* audioError = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&audioError];
    
    if(audioError){
        NSLog(@"AudioSession: %@ %ld %@", [audioError domain], [audioError code], [[audioError userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&audioError];
    
    if(audioError){
        NSLog(@"AudioSession: %@ %ld %@", [audioError domain], [audioError code], [[audioError userInfo] description]);
        return;
    }
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    
    // Create a new dated file
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    self.recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate];
    
    NSURL *url = [NSURL fileURLWithPath:self.recorderFilePath];
    
    NSError* err = nil;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    
    if(!self.recorder){
        NSLog(@"Recorder: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = [audioSession isInputAvailable];
    
    if (!audioHWAvailable) {
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Audio input hardware not available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    // start recording
    [self.recorder recordForDuration:(NSTimeInterval) 10];
}



- (void) stopRecording{
    /**
    if(![self.recorder isRecording]){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No recording in progress." message:@"Press the play button to start recording." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    **/
    
    [self.recorder stop];
    
    NSURL *url = [NSURL fileURLWithPath: self.recorderFilePath];
    
    NSError *err = nil;
    
    self.audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    
    if(!self.audioData)
        NSLog(@"audio data: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    err = nil;
    [fm removeItemAtPath:[url path] error:&err];
    
    if(err){
        NSLog(@"File Manager: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
    
    }
    
    self.recorder = nil;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    NSLog(@"Audio data info: %@",[self.audioData description]);
    
    
    //Perform speech translation here
    
    if(self.audioData){
        [self performAnalysisOnRecordedAudio:self.audioData];
    }
    
}
- (IBAction)startRecording:(UIButton *)sender {
    
    [self startRecording];
}

- (IBAction)stopRecording:(UIButton *)sender {
    [self stopRecording];
}

- (IBAction)translateToKorean:(UIButton *)sender {
    

}


-(void)performAnalysisOnRecordedAudio:(NSData*)recordedAudio{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    /** Convert the captured image into a base64encoded string which can be submitted via the HTTP body to Google Servers **/
    
    NSString* audioStr = [recordedAudio base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    NSDictionary* requestBodyDict = @{
        @"config":@{
            @"encoding":@"LINEAR16",
            @"sampleRateHertz":[NSNumber numberWithFloat:16000],
            @"languageCode":@"en-US",
            @"maxAlternatives":@5
                },
        @"audio":@{
               @"content":audioStr
            },
        
    
    };
    
    NSError* error = nil;
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:requestBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"Data submitted to GoogleCloud endpoint");
    
    NSURL* url = [NSURL URLWithString:GOOLE_SPEECH_RECOGNIZTION_BASE_URL_ENDPOINT];
    
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
        
        if(data){
            NSDictionary* jsonDict =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
            // Success response!
            NSLog(@"Success: %@", jsonDict);
        }
        // JSON error.
        if (jsonError) {
            NSLog(@"JSON decoding error %@", jsonError);
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                //Update the UI
        });
        
       
    }];
    
}


@end
