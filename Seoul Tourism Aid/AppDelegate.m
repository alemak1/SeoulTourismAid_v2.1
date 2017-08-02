//
//  AppDelegate.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

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

@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()



@end

@implementation AppDelegate

static BOOL willInstantiateRVCFromStoryboard = true;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /** Service Account Key: f00b9c3b783e0d8f5ea26fcbb59188dda8a11bee **/
    /** API Key: AIzaSyDYMTsEqV2iwISMUFxKPwZNqAcu-yw8SSg**/

    [GMSServices provideAPIKey:@"AIzaSyB7VFJsPM5YP2q4SKzl_utgD9QRGWEddyg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyB7VFJsPM5YP2q4SKzl_utgD9QRGWEddyg"];
    
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
        
        /**
        UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
        
        TouristSiteCollectionViewController* touristSiteCVC = [storyboardC instantiateViewControllerWithIdentifier:@"TouristSiteCSCNavController"];
     
        DebugController* debugController = [[DebugController alloc] init];
        **/
        
        /**TranslationController* translationController = [[TranslationController alloc] init]; **/
        
        
        UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
        
        GooglePlaceCollectionViewController* cvc = [storyboardC instantiateViewControllerWithIdentifier:@"GooglePlaceCollectionViewController"];
        
        cvc.placeCategory = Outdoor_NaturalSite;
        
        [self.window setRootViewController:cvc];
        
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
    [self saveContext];
}




#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Seoul_Tourism_Aid"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
