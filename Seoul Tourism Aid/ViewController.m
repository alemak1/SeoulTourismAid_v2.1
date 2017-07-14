//
//  ViewController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController () <YTPlayerViewDelegate>


@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

- (IBAction)playVideo:(id)sender;


- (IBAction)stopVideo:(id)sender;



@end

@implementation ViewController

-(void)viewWillLayoutSubviews{
    
    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?id=7lCDEYXw3mM&key=%@",GOOGLE_API_KEY];
    
    urlString = [urlString stringByAppendingString:@"&part=snippet,contentDetails,statistics,status"];
    
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    NSURLRequest* requestObject = [NSURLRequest requestWithURL:requestURL];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestObject completionHandler:^(NSData* data, NSURLResponse* response, NSError* error){
    
        //Do error handling
        
        //Validate the response
        
        //Check if data is null
        
        //Process the data
        
        NSError* jsonError;
        
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSLog(@"JSON response is: %@",[jsonResponse description]);
        
    }] resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.playerView setDelegate:self];
    
   
    [self.playerView loadWithVideoId:@"zn5BlL-nN7M" playerVars:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}


- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        default:
            break;
    }
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
}



- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{
    
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    
}

@end
