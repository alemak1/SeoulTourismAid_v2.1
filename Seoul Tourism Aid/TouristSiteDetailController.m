//
//  TouristSiteDetailController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/20/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteDetailController.h"
#import "DetailedInfoController.h"
#import "WVController.h"
#import "UserLocationManager.h"
#import "GoogleURLGenerator.h"
#import "Constants.h"

@import GoogleMaps;
@import GooglePlaces;

@interface TouristSiteDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

/** Region Monitoring Switch **/
@property (weak, nonatomic) IBOutlet UISwitch *regionMonitoringSwitch;

- (IBAction)changedRegionMonitoringStatus:(UISwitch *)sender;


/** Request Directions Buttons **/


- (IBAction)getGoogleDirections:(UIButton *)sender;
- (IBAction)getMapsDirections:(id)sender;

- (IBAction)loadFlickAuthorWebsite:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *flickrAuthorButton;


- (IBAction)loadWebsite:(UIButton *)sender;

/** Show Detail Info Controller **/

- (IBAction)showDetailOperatingHoursVC:(UIButton *)sender;
- (IBAction)showDetailedParkingInfoVC:(UIButton *)sender;
- (IBAction)showDetailedPriceInfoVC:(UIButton *)sender;


@end


@implementation TouristSiteDetailController

BOOL _alreadyPerformedPriceInfoSegue = false;
BOOL _alreadyPerformedOpHoursSegue = false;
BOOL _alreadyPerformedParkingInfoSegue = false;


-(void)viewWillAppear:(BOOL)animated{
    [self.descriptionLabel setText:self.descriptionText];

}

-(void)viewDidLoad{
    
   
    
    [self.titleLabel setText:self.titleText];
    [self.subTitleLabel setText:self.subtitleText];
    [self.descriptionLabel setText:self.descriptionText];
    [self.regionMonitoringSwitch setOn:self.regionMonitoringStatus];
    [self.detailImageView setImage:self.detailImage];
    
    NSString* buttonTitle = [NSString stringWithFormat:@"Image by: %@",self.flickrAuthor];
    
    [self.flickrAuthorButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    /**
     
     
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIUserInterfaceIdiomPhone] forKey:@"orientation"];
        
    } 
     
    **/
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [self.descriptionLabel setText:self.descriptionText];
        
        

}



-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self.descriptionLabel setText:self.descriptionText];
        
        
    });
   

}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self.descriptionLabel setText:self.descriptionText];
        
        
    });
   

    
}

- (IBAction)showDetailOperatingHoursVC:(UIButton *)sender {
    if(sender.tag != 3){
        return;
    }
    

    
    [self performSegueWithIdentifier:@"showDetailedOperatingHoursSegue" sender:nil];
    
   
    
    
    
}



- (IBAction)showDetailedParkingInfoVC:(UIButton *)sender {
    
    if(sender.tag != 2){
        return;
    }
    

    [self performSegueWithIdentifier:@"showParkingFeeInfoSegue" sender:nil];

   
    
    

}

- (IBAction)showDetailedPriceInfoVC:(UIButton *)sender {

    if(sender.tag != 1){
        return;
    }
    
    [self performSegueWithIdentifier:@"showPriceInfoSegue" sender:nil];
    


        
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showPriceInfoSegue"]){
        DetailedInfoController* detailInfoController = (DetailedInfoController*)segue.destinationViewController;
        
        detailInfoController.titleText = @"Admission Price Information";
        detailInfoController.detailStringList = self.touristSiteConfiguration.detailedPriceInfoArray;
        
        return;
    }
    
    if([segue.identifier isEqualToString:@"showDetailedOperatingHoursSegue"]){
        
        DetailedInfoController* detailInfoController = (DetailedInfoController*)segue.destinationViewController;
        
        detailInfoController.titleText = @"Operating Hours Information";
        detailInfoController.detailStringList = self.touristSiteConfiguration.detailedOperatingHoursInfoArray;
        
        return;

    }
    
    if([segue.identifier isEqualToString:@"showParkingFeeInfoSegue"]){
        DetailedInfoController* detailInfoController = (DetailedInfoController*)segue.destinationViewController;
        
        detailInfoController.titleText = @"Parking Fee Information";
        detailInfoController.detailStringList = self.touristSiteConfiguration.detailedParkingFeeInfoArray;
        
        return;

    }
}


- (IBAction)getGoogleDirections:(UIButton *)sender {
    
    WayPointConfiguration* destinationWayPoint = [[WayPointConfiguration alloc] initWithLocation:self.touristSiteConfiguration.location andWithName:self.touristSiteConfiguration.siteTitle];
    
    NSURL* directionsRequestURL = [GoogleURLGenerator getURLFromUserLocationToDestination:destinationWayPoint];
    
    NSLog(@"Making directions request to URL: %@",directionsRequestURL.absoluteString);
    
    NSURLSession* session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:directionsRequestURL completionHandler:^(NSData*data,NSURLResponse*response,NSError*error){
        
        if(error){
            NSLog(@"Failed to obtain JSON response for directions request due to error: %@",[error localizedDescription]);
        }
        
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            
            if(httpResponse.statusCode != 200){
                NSLog(@"Failed to obtain JSON response with status code: %ld",(long)httpResponse.statusCode);
            }
        }
        
        if(!data){
            NSLog(@"Failed to obtain JSON data.");
        }
        
        NSError* jsonError = nil;
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if(jsonError){
            NSLog(@"Failed to obtain JSON response with JSON error: %@",[jsonError localizedDescription]);
        }
        
        NSLog(@"JSON response info: %@",[jsonDict description]);
    
    }];
    
    [dataTask resume];
    
}

- (IBAction)getMapsDirections:(id)sender {
    
    CLLocationDegrees toLatitude = self.touristSiteConfiguration.location.coordinate.latitude;
    CLLocationDegrees toLongitude = self.touristSiteConfiguration.location.coordinate.longitude;
    
    MKPlacemark* toPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(toLatitude, toLongitude)];
    
    MKMapItem* toMapItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    toMapItem.name = self.touristSiteConfiguration.siteTitle;
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];

    
    MKMapItem* fromMapItem = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    fromMapItem.name = @"Current Location";
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(toPlacemark.coordinate, 10000, 10000);
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromMapItem,toMapItem, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
}

- (IBAction)loadFlickAuthorWebsite:(UIButton *)sender {
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    WVController*webViewController = [storyboardC instantiateViewControllerWithIdentifier:@"WVController"];
    
    NSLog(@"Loading website with address...");
    
    NSString *webURLStr = [self.touristSiteConfiguration.flickrWebAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    webViewController.webURLString = webURLStr;
    
    [self showViewController:webViewController sender:nil];
}

- (IBAction)loadWebsite:(UIButton *)sender {
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    WVController*webViewController = [storyboardC instantiateViewControllerWithIdentifier:@"WVController"];
    
    webViewController.webURLString = self.touristSiteConfiguration.webAddress;
    
    [self showViewController:webViewController sender:nil];

}

- (IBAction)changedRegionMonitoringStatus:(UISwitch *)sender {
    
    __block CLLocationDistance monitoringRadius;
    
    if([sender isOn]){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Monitor Region?" message:@"If you would like to receive notifications when you are close to this tourist site, select from the options below for proximity radius. A smaller proximity radius means you must be closer to the site in order to receive notifications" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* intermediateRadiusChoice = [UIAlertAction actionWithTitle:@"Intermediate Range Monitoring (100 m)" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            monitoringRadius = 100.0;
        }];
        
        UIAlertAction* longRangeRadius = [UIAlertAction actionWithTitle:@"Long Range Monitoring (200 m)" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            monitoringRadius = 200.0;
        }];
        
        UIAlertAction* shortRadiusChoice = [UIAlertAction actionWithTitle:@"Short Range Monitoring (50 m)" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            monitoringRadius = 50.0;
        }];
        
        [alertController addAction:shortRadiusChoice];
        [alertController addAction:intermediateRadiusChoice];
        [alertController addAction:longRangeRadius];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:self.touristSiteConfiguration.location.coordinate radius:monitoringRadius identifier:self.touristSiteConfiguration.siteTitle];
    
    if([sender isOn]){
        
        
        [[UserLocationManager sharedLocationManager] startMonitoringForSingleRegion:region];
        
        
        [[UserLocationManager sharedLocationManager] checkAuthoriationStatusWithCompletionHandler:^(NSNumber* authorizationStatus){
            
            
            if(authorizationStatus && [authorizationStatus boolValue] == YES){
                
                [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings* settings){
                    
                    
                    if(settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                        
                        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                        
                        content.title = [NSString localizedUserNotificationStringForKey:@"Tourist Site Nearby" arguments:@[]];
                        
                        content.body = [NSString localizedUserNotificationStringForKey:@"You are close to %@" arguments:@[self.touristSiteConfiguration.siteTitle]];
                        
                        content.categoryIdentifier = NOTIFICATION_CATEGORY_REGION_MONITORING;
                        
                        content.sound = [UNNotificationSound defaultSound];
                        
                        content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:monitoringRadius],@"monitoringRadius",[NSNumber numberWithDouble:self.touristSiteConfiguration.coordinate.latitude],@"latitude",[NSNumber numberWithDouble:self.touristSiteConfiguration.coordinate.longitude],@"longitude", nil];
                        
                        UNLocationNotificationTrigger* trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
                        
                        region.notifyOnEntry = YES;
                        region.notifyOnExit = YES;
                        
                        
                        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:self.touristSiteConfiguration.siteTitle content:content trigger:trigger];
                        
                        
                        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            if (error != nil) {
                                NSLog(@"%@", error.localizedDescription);
                            }
                        }];
                    }
                    
                }];
                
            }
            
            
            
        }];
        
        
    } else {
        
        [[UserLocationManager sharedLocationManager] stopMonitoringForSingleRegion:region];
        
          [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObject:region.identifier]];
    }
    
}
@end
