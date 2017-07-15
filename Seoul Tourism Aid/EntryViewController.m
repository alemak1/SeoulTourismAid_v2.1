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


@interface EntryViewController ()

@property UIImageView* backgroundImageView;
@property UIImageView* seoulTowerImageView;

- (void)showMenu:(UIGestureRecognizer *)gestureRecognizer;


@end

@implementation EntryViewController

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    

    
 
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.seoulTowerImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.seoulTowerImageView setImage:[UIImage imageNamed:@"north_seoul_tower"]];
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
                    options:@[@"About the App", @"Explore Nearby", @"Visited Sites", @"Seoul Tourism",@"Weather",@"Survival Korean", @"Product Prices",@"Monitored Regions",@"Image Galleries"]
                    optionImages:@[@"informationB", @"compassB", @"city1", @"templeB",@"cloudyA",@"chatA", @"shoppingCartB",@"mapAddressB",@"paintingB"]];
    
  

}


- (void)showMenu:(UIGestureRecognizer *)gestureRecognizer {
    [self.menuComponent showMenuWithSelectionHandler:^(NSInteger selectedOptionIndex) {
        
        UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
        
        UIStoryboard* storyBoardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
        
        UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController* requestedViewController;
        
        switch (selectedOptionIndex) {
            case 0:
                //Information about hostel
                requestedViewController = [self getInformationControllerFromStoryBoard];
                NSLog(@"You selected option %d",(int)selectedOptionIndex);
                break;
            case 1:
                //Directions
                 requestedViewController = [storyBoardA instantiateViewControllerWithIdentifier:@"DirectionsMenuController"];
                    NSLog(@"You selected option %d",(int)selectedOptionIndex);

                break;
            case 2:
                //Contact info
                 requestedViewController = [storyBoardA instantiateViewControllerWithIdentifier:@"DirectionsMenuController"];
                    NSLog(@"You selected option %d",(int)selectedOptionIndex);

                break;
            case 3:
                //Seoul tourism
                 requestedViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SeoulTourismNavigationController"];
                    NSLog(@"You selected option %d",(int)selectedOptionIndex);

                break;
            case 4:
                //Weather
                 requestedViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WeatherNavigationController"];
                NSLog(@"You selected option %d",(int)selectedOptionIndex);

                break;
            case 5:
                //Korean Phrases Audio
                break;
            case 6:
                //Korean Product Prices
                requestedViewController = [storyBoardB instantiateViewControllerWithIdentifier:@"ProductPriceNavigationController"];
                break;
            case 7:
                requestedViewController = [self getMonitoredRegionsControllerFromStoryboard];
                break;
            case 8:
                //Seoul Picture Gallery
                requestedViewController = [self getSeoulFlickrSearchController];
                
                NSLog(@"You selected option %d",(int)selectedOptionIndex);

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
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    NSString *storyBoardIdentifier = @"PadInformationController";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        storyBoardIdentifier = @"PhoneInformationController";
    }
    
    
    return [mainStoryBoard instantiateViewControllerWithIdentifier:storyBoardIdentifier];
    
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
