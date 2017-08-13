//
//  LanguageRecordingController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

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


@interface LanguageRecordingController () <SFSpeechRecognizerDelegate>

@property (readonly) SFSpeechRecognizer* speechRecognizer;
@property (readonly) AVAudioEngine* audioEngine;

@property SFSpeechAudioBufferRecognitionRequest* recognitionRequest;
@property SFSpeechRecognitionTask* recognitionTask;

@property AVAudioRecorder* recorder;
@property NSString* recorderFilePath;
@property NSData* audioData;
@property NSString* sourceText;

/** IBOutlets **/

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)toggleRecordButton:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UIButton *translateToKorean;

- (IBAction)translateToKorean:(UIButton *)sender;


@end

@implementation LanguageRecordingController

@synthesize speechRecognizer = _speechRecognizer;
@synthesize audioEngine = _audioEngine;



-(void)viewDidLoad{
    
    [self.recordButton setEnabled:NO];
    [self.textView setHidden:NO];
    [self.activityIndicator setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.speechRecognizer setDelegate:self];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authStatus){
    
    
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
            switch (authStatus) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    [self.recordButton setEnabled:YES];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    [self.recordButton setEnabled:NO];
                    [self.recordButton setTitle:@"User denied access to speech recognition" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    [self.recordButton setEnabled:YES];
                    [self.recordButton setTitle:@"Speech recognition restricted on this device" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    [self.recordButton setEnabled:NO];
                    [self.recordButton setTitle:@"Speech recognition not yet authorized" forState:UIControlStateDisabled];
                    break;
                default:
                    break;
            }
        
        }];
    }];
}


-(void)startRecording{
    
    [self.textView setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    if(self.recognitionTask){
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    
    NSError* audioSessionError = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&audioSessionError];
    
    if(audioSessionError){
        NSLog(@"Error configuring audio session: %@",[audioSessionError localizedDescription]);
    }
    
    [audioSession setMode:AVAudioSessionModeMeasurement error:&audioSessionError];
    
    if(audioSessionError){
        NSLog(@"Error configuring audio session: %@",[audioSessionError localizedDescription]);
    }
    
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&audioSessionError];
    
    if(audioSessionError){
        NSLog(@"Error configuring audio session: %@",[audioSessionError localizedDescription]);
    }
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    AVAudioInputNode* inputNode = [self.audioEngine inputNode];
    
    if(!inputNode){
        NSLog(@"Audio Engine has no input node");
        return;
    }
    
    if(!self.recognitionRequest){
        NSLog(@"Unable to create an audio buffer recognition request");

        return;
    }
    
    [self.recognitionRequest setShouldReportPartialResults:YES];
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult*result,NSError*error){
    
        BOOL isFinal = false;
        
        if(result){
            [self.textView setText:result.bestTranscription.formattedString];
            self.sourceText = result.bestTranscription.formattedString;
            
            isFinal = result.isFinal;
        }
    
        if(error || isFinal){
            
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
            
            [self.recordButton setEnabled:YES];
            [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        
            
        }
    
    }];
    
    
     AVAudioFormat* outputFormat = [inputNode outputFormatForBus:0];
    
    [inputNode installTapOnBus:0 bufferSize:1024 format:outputFormat block:^(AVAudioPCMBuffer*buffer,AVAudioTime*when){
    
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
        
        
    }];
    
    [self.audioEngine prepare];
    
    NSError* audioEngineError = nil;
    
    [self.audioEngine startAndReturnError:&audioEngineError];
    
    if(audioEngineError){
        NSLog(@"Error configuring audio engine while instaling tap on bus: %@",[audioEngineError localizedDescription]);
        return;
    }
    
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self.textView setHidden:NO];
    
    [self.textView setText:@"Speech recognizer activated.  Your recorded speech will appear here.  Start recording speech...."];
    

}


#pragma mark ****** SFSpeechRecognizer Delegate

-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    
    if(available){
        [self.recordButton setEnabled:YES];
        [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
    } else {
        [self.recordButton setEnabled:NO];
        [self.recordButton setTitle:@"Recognition not available" forState:UIControlStateDisabled];
   }

}


- (IBAction)translateToKorean:(UIButton *)sender {
    
    [self.recognitionTask cancel];

    if(!self.sourceText){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No text recorded." message:@"Please record your speech before using translation services." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    NSString* sourceText = self.sourceText;
    
    NSLog(@"Source text is: %@",sourceText);
    
    [self.activityIndicator setHidden:NO];
    [self.textView setHidden:YES];
    [self.activityIndicator startAnimating];
    
    [self performTranslationsOnSourceText:sourceText andTargetLanguage:@"ko"];
    
    
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
        
        
        
        if(data){
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
            
                [self.activityIndicator setHidden:YES];
                [self.activityIndicator stopAnimating];

                [self.textView setHidden:NO];
                [self.textView setText:translatedText];
           
            
            });
        
            // Success response!
            NSLog(@"Success: %@", jsonDict);
        } else {
            
            UIAlertController* alertController;
            
            if(error){
                alertController = [UIAlertController alertControllerWithTitle:@"Eror!" message:@"Unable to translate text.  Check that a WiFi/Internet connection is available, or try again later when the servers might be available" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
            alertController = [UIAlertController alertControllerWithTitle:@"Eror!" message:@"Unable to translate text.  Check that a WiFi/Internet connection is available, or try again later when the servers might be available" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
    
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


#pragma mark ****** Configure AVAudioEngine and SFSpeechRecognizer

-(AVAudioEngine *)audioEngine{
    if(_audioEngine == nil){
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    
    return _audioEngine;
}


-(SFSpeechRecognizer *)speechRecognizer{
    
    if(_speechRecognizer == nil){
        _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
    }
    
    return _speechRecognizer;
}


#pragma mark ***** Interface builder actions

- (IBAction)toggleRecordButton:(UIButton *)sender {
    
    if([self.audioEngine isRunning]){
        [self.audioEngine stop];
        
        if(self.recognitionRequest){
            [self.recognitionRequest endAudio];
        
        }
        
        [self.recordButton setEnabled:NO];
        [self.recordButton setTitle:@"Stopping" forState:UIControlStateDisabled];
        
    } else {
        
        [self startRecording];
        [self.recordButton setTitle:@"Stop Recording" forState:UIControlStateSelected];
    }
}
@end
