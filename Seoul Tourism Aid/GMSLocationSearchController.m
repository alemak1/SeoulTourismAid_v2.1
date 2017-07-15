//
//  GMSLocationSearchController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMSLocationSearchController.h"

@import GoogleMaps;
@import GooglePlaces;

/**
@interface GMSLocationSearchController () <GMSPlacePickerViewControllerDelegate>



- (IBAction)pickPlace:(UIButton *)sender;





@end



@implementation GMSLocationSearchController

-(void)viewDidLoad{
    
    
}


- (IBAction)pickPlace:(UIButton *)sender {
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    GMSPlacePickerViewController *placePicker =
    [[GMSPlacePickerViewController alloc] initWithConfig:config];
    placePicker.delegate = self;
    
    [self presentViewController:placePicker animated:YES completion:nil];
    
}


- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
    // Dismiss the place picker, as it cannot dismiss itself.
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"No place selected");
}


@end
 
 **/
