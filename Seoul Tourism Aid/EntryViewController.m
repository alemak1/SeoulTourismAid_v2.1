//
//  HostelInformationController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CloudKit/CloudKit.h>

#import "EntryViewController.h"
#import "UserLocationManager.h"
#import "AuthorizationController.h"
#import "LanguageHelpOptionsController.h"
#import "GeneralGameSceneController.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>

#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>

#import "Constants.h"



@interface EntryViewController ()

@property UIImageView* backgroundImageView;
@property UIImageView* seoulTowerImageView;

- (void)showMenu:(UIGestureRecognizer *)gestureRecognizer;


@end



@implementation EntryViewController

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    
    [[UserLocationManager sharedLocationManager] requestAuthorizationAndStartUpdates];
    
 

    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.seoulTowerImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.seoulTowerImageView setImage:[UIImage imageNamed:@"guanghuamun"]];
    [self.seoulTowerImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.seoulTowerImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:self.seoulTowerImageView];
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:[[self.seoulTowerImageView topAnchor] constraintEqualToAnchor:[self.view topAnchor]],[[self.seoulTowerImageView bottomAnchor] constraintEqualToAnchor:[self.view bottomAnchor]],[[self.seoulTowerImageView rightAnchor] constraintEqualToAnchor:[self.view rightAnchor]],[[self.seoulTowerImageView leftAnchor] constraintEqualToAnchor:[self.view leftAnchor]], nil]];
   
    UISwipeGestureRecognizer *showMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    
    showMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:showMenuGesture];
    
    CGRect desiredMenuFrame = CGRectMake(0.0, 0.0, 300.0, self.view.frame.size.height);
    self.menuComponent = [[MenuComponent alloc] initMenuWithFrame:desiredMenuFrame
                    targetView:self.view
                    direction:menuDirectionRightToLeft
                    options:@[@"About the App", @"Explore Nearby", @"Visited Sites", @"Seoul Tourism",@"Weather",@"Survival Korean", @"Product Prices",@"Monitored Regions",@"Tourism Videos",@"Image Galleries",@"Brainy Bunny Game"]
                    optionImages:@[@"informationB", @"compassB", @"city1", @"templeB",@"cloudyA",@"chatA", @"shoppingCartB",@"mapAddressB",@"tvB",@"paintingB",@"bunny2_walk1"]];
    
  

}

-(IBAction)unwindBacktoEntryViewController:(UIStoryboardSegue *)segue {
    
}

- (void)showMenu:(UIGestureRecognizer *)gestureRecognizer {
    [self.menuComponent showMenuWithSelectionHandler:^(NSInteger selectedOptionIndex) {
        

        UIViewController* requestedViewController;
        
        switch (selectedOptionIndex) {
            case 0:
                //App information controller
                requestedViewController = [self getInformationControllerFromStoryBoard];
                
                [self presentViewController:requestedViewController animated:YES completion:nil];
                NSLog(@"You selected option %d",(int)selectedOptionIndex);
                return;
            case 1:
                //Directions
                requestedViewController = [self getNavigationAidMenuController];
                break;
            case 2:
                //Contact info
                requestedViewController = [self getVisitedSitesController];
                break;
            case 3:
                //Seoul tourism
                requestedViewController = [self getSeoulTouristSiteInformationController];
                [self presentViewController:requestedViewController animated:YES completion:nil];
                return;
            case 4:
                //Weather
                requestedViewController = [self getWeatherNavigationController];

                break;
            case 5:
                //Language Help Menu Options
                requestedViewController = [self getLanguageHelpMenuOptions];
                break;
            case 6:
                //Korean Product Prices
                requestedViewController = [self getProductPriceController];
                break;
            case 7:
                //Monitored Regions
                requestedViewController = [self getMonitoredRegionsControllerFromStoryboard];
                break;
            case 8:
                //YouTubeTourism Videos
                requestedViewController = [self getYouTubeVideoController];
                [self presentViewController:requestedViewController animated:YES completion:nil];

                break;
            case 9:
                //Flickr Image Galleries
                requestedViewController = [self getSeoulFlickrSearchController];
                break;
            case 10:
                //Brainy Bunny Learns Korean
                requestedViewController = [self getBunnyGameController];
                [self presentViewController:requestedViewController animated:YES completion:nil];
                break;
            default:
                break;
        }
        
        [self showViewController:requestedViewController sender:nil];

    }];
}


-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self.menuComponent resetMenuView:[self traitCollection]];
}


#pragma mark HELPER FUNCTIONS FOR GETTING VIEWCONTROLLER CORRESPONDING TO MENU OPTION CHOICE

-(UIViewController*)getWeatherNavigationController{
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    UIViewController* requestedViewController = [storyboardD instantiateViewControllerWithIdentifier:@"WeatherNavigationController"];

    return requestedViewController;
}



-(UIViewController*)getDirectionsMenuController{
    
    UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    UIViewController* requestedViewController = [storyBoardA instantiateViewControllerWithIdentifier:@"DirectionsMenuController"];
    
    return requestedViewController;

}

-(UIViewController*)getProductPriceController{
    
    UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];

     UIViewController* requestedViewController = [storyboardB instantiateViewControllerWithIdentifier:@"ProductPriceNavigationController"];
    
    return requestedViewController;
}

-(UIViewController*)getLanguageHelpMenuOptions{
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    NSLog(@"Authorization token is %@",fromKeychainAuthorization.authState.lastTokenResponse.accessToken);
    
    UIViewController* nextViewController;
    
    if(fromKeychainAuthorization == nil){
        AuthorizationController* authorizationController = [[AuthorizationController alloc] init];
        
        nextViewController = authorizationController;
    } else {
        
        UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
        
        
        nextViewController = [storyboardC instantiateViewControllerWithIdentifier:@"LanguageOptionsController"];
        
        NSLog(@"Authorization already obtained...");
    }
    
    return nextViewController;
}


-(UIViewController*)getNavigationAidMenuController{
    UIStoryboard* storyboardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    UIViewController* gameSceneController = [storyboardA instantiateViewControllerWithIdentifier:@"DirectionsMenuController"];
    
    return gameSceneController;
}

-(UIViewController*)getBunnyGameController{
    

    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    UIViewController* gameSceneController = [storyboardC instantiateViewControllerWithIdentifier:@"GeneralGameSceneController"];

    
    
    return gameSceneController;
}


-(UIViewController*)getYouTubeVideoController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"MainVideoPreviewController_iPad";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        storyBoardIdentifier = @"MainVideoPreviewController_iPhone";
    }
    
    
    return [mainStoryboard instantiateViewControllerWithIdentifier:storyBoardIdentifier];

}

-(UIViewController*)getSeoulFlickrSearchController{
    
    UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"SeoulFlickrSearchController_iPad";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        storyBoardIdentifier = @"SeoulFlickrSearchController";
    }
    
    
    return [storyboardB instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
}

-(UIViewController*)getMonitoredRegionsControllerFromStoryboard{
    
    UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"MonitoredRegionsController_iPad";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        storyBoardIdentifier = @"MonitoredRegionsController";
    }
    
    
    return [storyboardB instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
}

-(UIViewController*)getInformationControllerFromStoryBoard{
    
    // decide which kind of content we need based on the device idiom,
    // when we load the proper storyboard, the "ContentController" class will take it from here
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    
   
    NSString* storyBoardIdentifier = @"ScrollableInfoController";
    
    
    
    return [storyboardD instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
}

-(UIViewController*)getVisitedSitesController{
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"VisitedSitesController";
    
  
    return [storyboardC instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
}

-(UIViewController*)getSeoulTouristSiteInformationController{
    
    // decide which kind of content we need based on the device idiom,
    // when we load the proper storyboard, the "ContentController" class will take it from here
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"TouristSiteCategorySelectionController";
    
    
    return [storyboardD instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
}



-(IBAction)unwindBackToHostelIndexPage:(UIStoryboardSegue *)unwindSegue{
    
}

@end


/**
 
 
 
 
 __block CLLocation* userLocation = [userLocationManager getLastUpdatedUserLocation];
 
 if(userLocation == nil){
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6.00*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
 
 userLocation = [userLocationManager getLastUpdatedUserLocation];
 
 
 NSLog(@"The user location after 6.00 secondss is lat: %f, long: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
 
 
 TouristSiteConfiguration* site = [siteManager getTouristSiteClosestToUser];
 
 NSLog(@"The tourist site closest to the user is: %@",[site title]);
 
 NSArray* closeSitesArray = [siteManager getArrayForTouristSiteCategory:KOREAN_WAR_MEMORIAL];
 
 
 NSLog(@"The museums are:");
 
 for (TouristSiteConfiguration*site in closeSitesArray) {
 NSLog(@"Name: %@",site.title);
 }
 });
 }
 
**/
