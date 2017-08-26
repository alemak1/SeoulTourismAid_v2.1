//
//  MonitoredRegionsMenuController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonitoredRegionMenuController.h"
#import "UserLocationManager.h"
#import "Constants.h"

@interface MonitoredRegionsMenuController () <UITableViewDelegate,UITableViewDataSource>

typedef enum TABLEVIEW_TAG{
    ALL_REGIONS_TABLEVIEW_TAG = 1000,
    MONITORED_REGIONS_TABLEVIEW_TAG = 2000
}TABLEVIEW_TAG;

@property NSMutableArray<NSDictionary*>* allRegionsArray;
@property NSMutableArray<NSString*>* monitoredRegionsArray;

@property NSMutableArray* toAddCurrentlySelected;
@property NSMutableArray* toRemoveCurrentlySelected;

- (IBAction)addSelectedRegions:(id)sender;

- (IBAction)removeSelectedRegions:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *allRegionsTable;



@property (weak, nonatomic) IBOutlet UITableView *monitoredRegionsTable;



@end

@implementation MonitoredRegionsMenuController


-(void)viewWillLayoutSubviews{
    
    
    [self loadTableViewDataSources];
    [self initializeUserSelectionCache];
}

-(void)viewDidLoad{
    
    [self configureTableViewProperties];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == ALL_REGIONS_TABLEVIEW_TAG){
        
        return [self.allRegionsArray count];
    }
    
    
    if(tableView.tag == MONITORED_REGIONS_TABLEVIEW_TAG){
        
        return [self.monitoredRegionsArray count];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Dequeing another table view data cell....");

    UITableViewCell* cell;
    
    if(tableView.tag == ALL_REGIONS_TABLEVIEW_TAG){
        
        cell = [self.allRegionsTable dequeueReusableCellWithIdentifier:@"AllRegionsCell"];
        NSDictionary* dict = [self.allRegionsArray objectAtIndex:indexPath.row];
        NSString* title = dict[@"RegionIdentifier"];
        
        [cell.textLabel setText:title];
    }
    
    if(tableView.tag == MONITORED_REGIONS_TABLEVIEW_TAG){
        
        cell = [self.monitoredRegionsTable dequeueReusableCellWithIdentifier:@"MonitoredRegionsCell"];
        NSString* title = [self.monitoredRegionsArray objectAtIndex:indexPath.row];

        [cell.textLabel setText:title];


    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == ALL_REGIONS_TABLEVIEW_TAG){
        
        NSDictionary* dict = [self.allRegionsArray objectAtIndex:indexPath.row];
        NSString* newSelection = dict[@"RegionIdentifier"];
        
        [self.toAddCurrentlySelected addObject:newSelection];
    }
    
    if(tableView.tag == MONITORED_REGIONS_TABLEVIEW_TAG){
     
        NSString* newSelection = [self.monitoredRegionsArray objectAtIndex:indexPath.row];
        
        [self.toRemoveCurrentlySelected addObject:newSelection];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == ALL_REGIONS_TABLEVIEW_TAG){
        
        NSDictionary* selectedDict = [self.allRegionsArray objectAtIndex:indexPath.row];
        
        NSString*selection = [selectedDict valueForKey:@"RegionIdentifier"];
        
        if([self.toAddCurrentlySelected containsObject:selection]){
            [self.toAddCurrentlySelected removeObject:selection];

        }
        
        
    }
    
    if(tableView.tag == MONITORED_REGIONS_TABLEVIEW_TAG){
        
        NSString* selection = [self.monitoredRegionsArray objectAtIndex:indexPath.row];
        
        
        if([self.toRemoveCurrentlySelected containsObject:selection]){
            
            [self.toRemoveCurrentlySelected removeObject:selection];
            
        }
       
        
    }

}

- (IBAction)addSelectedRegions:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self addSelectedRegionsForRegionMonitoring];
        
        for (NSString* toAddSiteName in self.toAddCurrentlySelected) {
            
            if(![self.monitoredRegionsArray containsObject:toAddSiteName]){
                [self.monitoredRegionsArray addObject:toAddSiteName];

            }
        }
        
        self.toAddCurrentlySelected = nil;
        self.toAddCurrentlySelected = [[NSMutableArray alloc] init];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
        
            [self.allRegionsTable reloadData];
            [self.monitoredRegionsTable reloadData];
        });
    
    });
    
}

-(void)addSelectedRegionsForRegionMonitoring{
    
    
   
    __block CLLocationDistance monitoringRadius = 50.0;
    
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Monitor Regions?" message:@"If you would like to receive notifications when you are close to the selected tourist sites, select from the options below for a proximity radius. A smaller proximity radius means you must be closer to the site in order to receive notifications" preferredStyle:UIAlertControllerStyleAlert];
        
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
        
    [self presentViewController:alertController animated:YES completion:^{
    
        
    
    }];
    
    
    for(NSString*selection in self.toAddCurrentlySelected){
        
        for (NSDictionary*regionDict in self.allRegionsArray) {
            
            NSString* regionId = regionDict[@"RegionIdentifier"];
            
            if([regionId isEqualToString:selection]){
                NSString* coordStr = regionDict[@"Coord"];
                CGPoint p = CGPointFromString(coordStr);
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(p.x, p.y);
                
                NSLog(@"Will begin monitoring for region with name %@",selection);
                
                CLCircularRegion* region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:monitoringRadius identifier:selection];
                
                
                [[UserLocationManager sharedLocationManager] startMonitoringForSingleRegion:region];
                
                
                [[UserLocationManager sharedLocationManager] checkAuthoriationStatusWithCompletionHandler:^(NSNumber* authorizationStatus){
                
                
                    if(authorizationStatus && [authorizationStatus boolValue] == YES){

                        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings* settings){
                            
                            
                            if(settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                            
                                UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                                
                                content.title = [NSString localizedUserNotificationStringForKey:@"Tourist Site Nearby" arguments:@[]];
                                
                                content.body = [NSString localizedUserNotificationStringForKey:@"You are close to %@" arguments:@[regionId]];
                                
                                content.categoryIdentifier = NOTIFICATION_CATEGORY_REGION_MONITORING;
                                
                                content.sound = [UNNotificationSound defaultSound];
                                
                                content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:monitoringRadius],@"monitoringRadius",[NSNumber numberWithDouble:coordinate.latitude],@"latitude",[NSNumber numberWithDouble:coordinate.longitude],@"longitude", nil];
                                
                                UNLocationNotificationTrigger* trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
                                
                                region.notifyOnEntry = YES;
                                region.notifyOnExit = YES;
                                
                                
                                UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:regionId content:content trigger:trigger];
                                
                                
                                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                    if (error != nil) {
                                        NSLog(@"%@", error.localizedDescription);
                                    }
                                }];
                            }
                            
                        }];
                        
                    }
                    
                 
                
                }];
                
                
            }
            
        }
        
    }

}

- (IBAction)removeSelectedRegions:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        for (NSString* toRemoveSiteName in self.toRemoveCurrentlySelected) {
            
            if([self.monitoredRegionsArray containsObject:toRemoveSiteName]){
                
                [self.monitoredRegionsArray removeObject:toRemoveSiteName];
                
                for (CLRegion*region in [[UserLocationManager sharedLocationManager] monitoredRegions]) {
                    
                    if([region.identifier isEqualToString:toRemoveSiteName]){
                        
                        [[UserLocationManager sharedLocationManager] stopMonitoringForSingleRegion:region];
                        
                         [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObject:region.identifier]];
                    }
                    
                }
                
            }

        }
        
        self.toRemoveCurrentlySelected = nil;
        self.toRemoveCurrentlySelected = [[NSMutableArray alloc] init];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.allRegionsTable reloadData];
            [self.monitoredRegionsTable reloadData];
        });
        
    });
}



-(void)configureTableViewProperties{
    
    NSLog(@"Configuring table view properties....");

    [self.allRegionsTable setAllowsMultipleSelection:YES];
    [self.allRegionsTable setTag:ALL_REGIONS_TABLEVIEW_TAG];
    [self.allRegionsTable setDataSource:self];
    [self.allRegionsTable setDelegate:self];
    [self.allRegionsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AllRegionsCell"];

    [self.monitoredRegionsTable setAllowsMultipleSelection:YES];
    [self.monitoredRegionsTable setTag:MONITORED_REGIONS_TABLEVIEW_TAG];
    [self.monitoredRegionsTable setDelegate:self];
    [self.monitoredRegionsTable setDataSource:self];
    [self.monitoredRegionsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MonitoredRegionsCell"];
    
}



-(void)loadTableViewDataSources{
    
    NSLog(@"Loading table view data sources....");
    
    //Load the data source for all tourist sites available for monitoring
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
    self.allRegionsArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    //Load the data source for currently monitored tourist sites
    
    NSSet* monitoredRegions = [[UserLocationManager sharedLocationManager] monitoredRegions];
    
    self.monitoredRegionsArray = [[NSMutableArray alloc] init];
    
    
    for (CLRegion* region in monitoredRegions) {
            
        [self.monitoredRegionsArray addObject:region.identifier];
            
    }

    
    
    
    self.monitoredRegionsArray = [[NSMutableArray alloc] init];
    
    for (CLRegion* region in monitoredRegions) {
        
        [self.monitoredRegionsArray addObject:region.identifier];
        
    }
    
}

-(void) initializeUserSelectionCache{
    
    self.toRemoveCurrentlySelected = [[NSMutableArray alloc] init];
    self.toAddCurrentlySelected = [[NSMutableArray alloc] init];
}

@end
