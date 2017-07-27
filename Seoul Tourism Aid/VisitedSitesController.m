//
//  VisitedSitesController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "VisitedSitesController.h"
#import "UserLocationManager.h"

@interface VisitedSitesController ()


@property (readonly) NSSet* visitedSites;

@end

@implementation VisitedSitesController

-(void)viewDidLoad{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.visitedSites count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"VisitedSiteCell"];
    
    NSArray* visitedSites = [self.visitedSites allObjects];
    
    CLRegion* region = [visitedSites objectAtIndex:indexPath.row];
    
    NSString* title = region.identifier;

    [cell.textLabel setText:title];
    
    NSDate* siteVisitation = [[NSUserDefaults standardUserDefaults] valueForKey:title];
    
    if(!siteVisitation){
        NSLog(@"There are no visitations recorded for that site");
        
        [cell.detailTextLabel setText:@"Region has not been entered yet"];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Futura" size:7.00]];
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_boxCross"]];

    } else {
        NSLog(@"That site has been visited");

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterLongStyle];
        NSString* dateString = [formatter stringFromDate:siteVisitation];
        
        
        NSString* detailString = [NSString stringWithFormat:@"Date of last visitation: %@",dateString];
        
        [cell.detailTextLabel setText:detailString];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Futura" size:7.00]];

        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_boxCheckmark"]];

    }
    
    
    
    return cell;
}

-(NSSet*)visitedSites{
    
    return [[UserLocationManager sharedLocationManager] monitoredRegions];

    
    
}

@end
