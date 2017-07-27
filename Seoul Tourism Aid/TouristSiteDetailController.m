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
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.descriptionLabel setText:self.descriptionText];

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
}

- (IBAction)loadWebsite:(UIButton *)sender {
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    WVController*webViewController = [storyboardC instantiateViewControllerWithIdentifier:@"WVController"];
    
    webViewController.webURLString = self.touristSiteConfiguration.webAddress;
    // @"https://english.visitkorea.or.kr/enu/index.kto";
    
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
        
    } else {
        
        [[UserLocationManager sharedLocationManager] stopMonitoringForSingleRegion:region];
        
    }
    
}
@end
