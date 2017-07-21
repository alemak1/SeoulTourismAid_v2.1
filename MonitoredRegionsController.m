//
//  MonitoredRegionsController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/3/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MonitoredRegionsController.h"
#import "TouristSiteManager.h"
#import "UserLocationManager.h"
#import "UIView+HelperMethods.h"

@interface MonitoredRegionsController ()


@property TouristSiteManager* touristSiteManager;
@property NSArray<NSDictionary*>* regionDictArray;

@end



@implementation MonitoredRegionsController



-(void)viewWillAppear:(BOOL)animated{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
    
    self.regionDictArray = [NSArray<NSDictionary*> arrayWithContentsOfFile:path];
    
  
}


-(void)viewDidLoad{
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MonitoredRegionCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.regionDictArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MonitoredRegionCell"];
    
    
    NSDictionary* regionDict = [self.regionDictArray objectAtIndex:indexPath.row];
    
    NSString* regionIdentifier = [regionDict valueForKey:@"RegionIdentifier"];
    NSString* address = [regionDict valueForKey:@"Address"];
    
    BOOL hasSwitch = false;
    
    for (UIView*subview in cell.contentView.subviews) {
        if([subview isKindOfClass:[UISwitch class]]){
            hasSwitch = true;
        }
    }
    
    
    if(!hasSwitch){
        CGRect toggleFrame = [cell.contentView getFrameAdjustedRelativeToContentViewWithXCoordOffset:0.87 andWithYCoordOffset:0.10 andWithWidthMultiplier:0.20 andWithHeightMultiplier:0.90];
    
        UISwitch* monitoringToggle = [[UISwitch alloc] initWithFrame:toggleFrame];
    
        [monitoringToggle setTag:indexPath.row];
    
        BOOL isBeingMonitored = [[UserLocationManager sharedLocationManager] isUnderRegionMonitoring:regionIdentifier];
    
        [monitoringToggle setOn:isBeingMonitored];
    
        [monitoringToggle addTarget:self action:@selector(adjustToggleSwitch:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:monitoringToggle];
    }

    
    
    [cell.textLabel setText:regionIdentifier];
    [cell.textLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:12.0]];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.textLabel setMinimumScaleFactor:0.50];
    
    [cell.detailTextLabel setText:address];
    
    return cell;
    
}


-(void)adjustToggleSwitch:(UISwitch*)sender{
    
    NSLog(@"Toggled switch with tag %d",[sender tag]);
    
    NSDictionary* regionDict = [self.regionDictArray objectAtIndex:sender.tag];
    
    NSString* regionIdentifier = regionDict[@"RegionIdentifier"];
    
    NSString* coordStr = regionDict[@"Coord"];
    CGPoint p = CGPointFromString(coordStr);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(p.x, p.y);
    
    __block CLLocationDistance monitoringRadius = 50.0;
    
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
    
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:monitoringRadius identifier:regionIdentifier];

    if([sender isOn]){
        
        
        [[UserLocationManager sharedLocationManager] startMonitoringForSingleRegion:region];
        
    } else {
        
        [[UserLocationManager sharedLocationManager] stopMonitoringForSingleRegion:region];
        
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
