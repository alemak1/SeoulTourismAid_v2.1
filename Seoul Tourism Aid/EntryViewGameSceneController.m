//
//  EntryViewGameScene.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeneralGameSceneController.h"
#import "EntryViewGameSceneController.h"
#import "EntryGameScene.h"
#import "Constants.h"


@interface EntryViewGameSceneController ()

@property (readonly) SKView* skView;

@end


@implementation EntryViewGameSceneController


SKView* _skView;

-(void)viewWillLayoutSubviews{
    
    [self registerNotifications];
    
    SKScene* gameScene = [[EntryGameScene alloc] initWithSize:self.view.bounds.size];
    
    [self.skView presentScene:gameScene];
    
   
    

}



-(void)viewDidLoad{
    
}

-(SKView *)skView{
    
    
    if(_skView == nil){
        
        _skView = [[SKView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:_skView];
    }

    return _skView;
    
}


-(IBAction)unwindToEntryViewGameSceneController:(UIStoryboardSegue *)segue {
    
}


-(void)dealloc{
    [self removeNotifications];
}


-(void)presentNavigationAidControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Navigation Aids" message:@"Do you want to explore our navigation aids for the Seoul Area? Navigation aids help you get directions, search for interesting locations, and get detailed map info for select places." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    [self showViewController:alertController sender:nil];
}

-(void)presentWeatherInfoControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Weather Forecast" message:@"Do you want to get weather forecasts for major cities in Korea?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
    
        UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
        
        UINavigationController* weatherNavigationController = [storyboardD instantiateViewControllerWithIdentifier:@"WeatherNavigationController"];
        
        [self showViewController:weatherNavigationController sender:nil];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    [self showViewController:alertController sender:nil];
}

-(void)presentTouristSiteInfoControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Tourist Information Aids" message:@"Do you want to explore information about famous Tourist Sites in Korea?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
}

-(void)presentImageGalleryControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Explore Flickr Image Galleries" message:@"Do you want to explore image galleries with pictures of Korean food and K-pop stars?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
    
    
        UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
        
        UIViewController* viewController = [storyboardB instantiateViewControllerWithIdentifier:@"SeoulFlickrSearchController_iPad"];
        
        [self showViewController:viewController sender:nil];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
}

-(void)presentYouTubeVideoControllerRequestAlert{
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Explore YouTube Videos" message:@"Do you want to watch YouTube videos about tourism information and other fun things to do in Korea?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController* videoPreviewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainVideoPreviewController_iPad"];
        
        [self showViewController:videoPreviewController sender:nil];
    
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
    
}

-(void)presentProductInfoControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Product Price Info" message:@"Do you want to get information about common products in Korea?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
}

-(void)presentKoreanAudioControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Korean Language Aid" message:@"Do you want to hear authentic phrases in Korean or get translations for English phrases?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
}

-(void)presentAppInfoControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"App Information Aid" message:@"Do you want to learn more information about how to use this app or leave a review?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
    
}

-(void)presentMonitoredRegionsControllerRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"App Information Aid" message:@"Do you want to learn more information about how to use this app or leave a review?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
    
}

-(void)presentBunnyGameRequestAlert{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Brainy Bunny Learns Korean" message:@"Do you want to play Brainy Bunny Learns Korean?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"Let's Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
                
        UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
        
        GeneralGameSceneController* generalGameSceneController = [storyboardC instantiateViewControllerWithIdentifier:@"GeneralGameSceneController"];
        
        [self showViewController:generalGameSceneController sender:nil];
    
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No thanks." style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okay];
    [alertController addAction:cancel];
    
    
    [self showViewController:alertController sender:nil];
    
}

#pragma mark ****** HELPER METHODS FOR REGISTERING AND REMOVING NOTIFICATIONS

-(void) registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNavigationAidControllerRequestAlert) name:DID_REQUEST_NAVIGATION_AID_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentProductInfoControllerRequestAlert) name:DID_REQUEST_PRODUCT_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAppInfoControllerRequestAlert) name:DID_REQUEST_APP_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentYouTubeVideoControllerRequestAlert) name:DID_REQUEST_YOUTUBE_VIDEO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentTouristSiteInfoControllerRequestAlert) name:DID_REQUEST_TOURISM_SITE_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentImageGalleryControllerRequestAlert) name:DID_REQUEST_IMAGE_GALLERY_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentKoreanAudioControllerRequestAlert) name:DID_REQUEST_KOREAN_AUDIO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentWeatherInfoControllerRequestAlert) name:DID_REQUEST_WEATHER_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentBunnyGameRequestAlert) name:DID_REQUEST_BUNNY_GAME_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMonitoredRegionsControllerRequestAlert) name:DID_REQUEST_MONITORED_REGIONS_NOTIFICATION object:nil];
    
}

-(void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_WEATHER_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_KOREAN_AUDIO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_IMAGE_GALLERY_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_TOURISM_SITE_INFO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_YOUTUBE_VIDEO_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_APP_INFO_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_PRODUCT_INFO_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_NAVIGATION_AID_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_MONITORED_REGIONS_NOTIFICATION object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_REQUEST_BUNNY_GAME_NOTIFICATION object:nil];


    
}

@end
