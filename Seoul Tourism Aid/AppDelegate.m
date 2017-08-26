//
//  AppDelegate.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import <UserNotifications/UserNotifications.h>

#import "AppDelegate.h"
#import "SpecificLocationMapController.h"
#import "EntryViewController.h"
#import "EntryViewGameSceneController.h"
#import "GeneralGameSceneController.h"
#import "GMSLocationSearchController.h"
#import "LocationSearchController.h"
#import "OCRController.h"

#import "VideoScrollViewController.h"
#import "MainVideoPreviewController.h"
#import "TranslationController.h"
#import "DebugController.h"
#import "TouristSiteCollectionViewController.h"
#import "WVController.h"


#import "GooglePlaceCollectionViewController.h"
#import "VideoSearchController.h"
#import "IAPHelper.h"
#import "UserLocationManager.h"
#import "Constants.h"

@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()



@end

@implementation AppDelegate

static BOOL willInstantiateRVCFromStoryboard = true;
static BOOL isFirstLaunch = YES;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /** Service Account Key: f00b9c3b783e0d8f5ea26fcbb59188dda8a11bee **/
    /** API Key: AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg**/

    [GMSServices provideAPIKey:@"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg"];
    
    /** Set Korea as the default time zone for the application i.e. 9h + UTC **/
    
    NSTimeZone* koreaTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*9];
    [NSTimeZone setDefaultTimeZone:koreaTimeZone];
    
    // Override point for customization after application launch.
    
    
    if(willInstantiateRVCFromStoryboard){
        
        self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

        
        UIViewController* rootViewController;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            
            rootViewController = [[EntryViewGameSceneController alloc] init];
            
        } else {
            
            rootViewController = [[EntryViewController alloc] init];
        }
        
        
        if(isFirstLaunch){
            
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
        
            NSArray* regionDictArray = [NSArray arrayWithContentsOfFile:path];
        
            for (NSDictionary* regionDict in regionDictArray) {
            
                NSString* regionIdentifier = regionDict[@"RegionIdentifier"];
            
                [[NSUserDefaults standardUserDefaults] setObject:[NSNull null] forKey:regionIdentifier];
            
            
            }
            
          

            [[UserLocationManager sharedLocationManager] clearMonitoredRegions];
            
            isFirstLaunch = NO;
        }
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center setDelegate:[UserLocationManager sharedLocationManager]];
    
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionSound+UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError*error){
        
            //Completion handler goes here
            
        }];
        
        UNNotificationAction* getDirectionsAction = [UNNotificationAction actionWithIdentifier:NOTIFICATION_ACTION_IDENTIFIER_GET_DIRECTIONS title:@"Get Directions" options:UNNotificationActionOptionForeground];
        
        UNNotificationAction* getDistanceAction = [UNNotificationAction actionWithIdentifier:NOTIFICATION_ACTION_IDENTIFIER_GET_DISTANCE title:@"Get Distance" options:UNNotificationActionOptionNone];
        
        UNNotificationCategory* regionMonitoringAlertCategory = [UNNotificationCategory categoryWithIdentifier:NOTIFICATION_CATEGORY_REGION_MONITORING actions:@[getDirectionsAction,getDistanceAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        [center setNotificationCategories:[NSSet setWithObjects:regionMonitoringAlertCategory, nil]];
        
        
        /** Clear delivered notifications that are over one day old **/
        
        /**
         
        [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification*>*notifications){
        
        
            NSMutableArray<NSString*>* toRemoveIdentifiers = [[NSMutableArray alloc] init];
            
            for (UNNotification*notification in notifications) {
                
                if(![notification.date isEqualToDate:[NSDate date]]){
                    
                    [toRemoveIdentifiers addObject:notification.request.identifier];
                    
                }
            }
            
            [center removeDeliveredNotificationsWithIdentifiers:toRemoveIdentifiers];
        
        }];
         
         **/
        
        /** Consider using for future releases of the app: 
         
        IAPHelper* sharedIAPHelper = [IAPHelper sharedHelper];
        
        [sharedIAPHelper requestKoreanLanguageFeatureProductList];
        
        [sharedIAPHelper restorePurchases];
         
         **/
        
        [self.window setRootViewController:rootViewController];
        
        [self.window makeKeyAndVisible];
    }
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    // Sends the URL to the current authorization flow (if any) which will
    // process it if it relates to an authorization response.

    if ([_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]) {
        _currentAuthorizationFlow = nil;
        
        NSLog(@"Authorization redirect complete. Posting notification to perform API request....");
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"STAppLaunchedWithURLNotification" object:nil];
        return YES;
    }
    
   
    
    
  
    // Your additional URL handling (if any) goes here.
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
}






@end
