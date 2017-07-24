//
//  LanguageTranslationController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

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

#import <MessageUI/MessageUI.h>

@interface LanguageTranslationController () <UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *sourceLanguageTextView;

@property (weak, nonatomic) IBOutlet UILabel *translatedTextLabel;

@property NSString* sourceText;

- (IBAction)translateToKorean:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)showMailPicker:(UIButton *)sender;

- (IBAction)showSMSPicker:(UIButton *)sender;


@end


@implementation LanguageTranslationController

-(void)viewDidLoad{
    
    [self.activityIndicator setHidden:YES];
    
    
    
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
        
            [self.translatedTextLabel setText:translatedText];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            [self.translatedTextLabel setHidden:NO];
            
        });
        
        // Success response!
        NSLog(@"Success: %@", jsonDict);
    }];
    
}


- (IBAction)translateToKorean:(UIButton *)sender {
    
    if(!self.sourceText){
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No text entered." message:@"Please enter the text that you want to translate in the text box in order to translate into Korean." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okay];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString* sourceText = self.sourceText;
    
    NSLog(@"Source text is: %@",sourceText);
    
    [self performTranslationsOnSourceText:sourceText andTargetLanguage:@"ko"];
    
    [self.sourceLanguageTextView resignFirstResponder];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.translatedTextLabel setHidden:YES];
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

#pragma mark ***** TEXTVIEW DELEGATE METHODS

-(void)textViewDidChange:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];
    
    [self.sourceLanguageTextView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.sourceText = [self.sourceLanguageTextView text];

}

- (IBAction)showMailPicker:(UIButton *)sender {
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Failed to send mail!" message:@"The current device is not configured to send mail." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okay];
        
    }
}

- (IBAction)showSMSPicker:(UIButton *)sender {
    
    // You must check that the current device can send SMS messages before you
    // attempt to create an instance of MFMessageComposeViewController.  If the
    // device can not send SMS messages,
    // [[MFMessageComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet];
    }
    else
        // The device can not send email.
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Failed to send SMS!" message:@"The current device is not configured to send SMS." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okay];
    }
}


#pragma mark - Compose Mail/SMS

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Hello from California!"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    /**
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
    **/
    
    NSString* messageToSend = [self.translatedTextLabel text];
    
    if(messageToSend == nil){
        messageToSend = self.sourceText;
    }
    
    // Fill out the email body text
    NSString *emailBody = messageToSend;
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//  displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    
    NSString* messageToSend = [self.translatedTextLabel text];
    
    if(messageToSend == nil){
        messageToSend = self.sourceText;
    }
    
    picker.body = messageToSend;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//  mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString* alertMessage = nil;
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertMessage = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            alertMessage = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            alertMessage = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            alertMessage = @"Result: Mail sending failed";
            break;
        default:
            alertMessage = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    
}

// -------------------------------------------------------------------------------
//  messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString* alertMessage = nil;
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            alertMessage = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            alertMessage = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            alertMessage = @"Result: SMS sending failed";
            break;
        default:
            alertMessage = @"Result: SMS not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];

    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:alertMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
}


@end
