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


-(void)viewDidLoad{
    
    _alreadyPerformedPriceInfoSegue = false;
    _alreadyPerformedOpHoursSegue = false;
    _alreadyPerformedParkingInfoSegue = false;

    
    [self.titleLabel setText:self.titleText];
    [self.subTitleLabel setText:self.subtitleText];
    [self.descriptionLabel setText:self.descriptionText];
    [self.regionMonitoringSwitch setOn:self.regionMonitoringStatus];
    [self.detailImageView setImage:self.detailImage];
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


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString:@"showPriceInfoSegue"]){
        return !_alreadyPerformedPriceInfoSegue;
    }
    
    if([identifier isEqualToString:@"showParkingFeeInfoSegue"]){
        return !_alreadyPerformedParkingInfoSegue;
    }
    
    if([identifier isEqualToString:@"showDetailedOperatingHoursSegue"]){
        return !_alreadyPerformedOpHoursSegue;
    }
    
    return YES;
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
}
@end
