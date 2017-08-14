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

- (IBAction)toggleVisitedSites:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleVisitedSitesButton;

@end

@implementation VisitedSitesController

BOOL _shouldSeeVisitedSitesOnly = false;


-(void)viewWillLayoutSubviews{
    
   
}

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
    
    NSString* title = [visitedSites objectAtIndex:indexPath.row];
    
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
    
    NSMutableSet* allSites = [[NSMutableSet alloc] init];
    
    NSMutableSet* visitedSites = [[NSMutableSet alloc] init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
    
    NSArray* regionDictArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary* regionDict in regionDictArray) {
        
        
        NSString* regionIdentifier = regionDict[@"RegionIdentifier"];
        
        
        [allSites addObject:regionIdentifier];
        
        NSDate* siteVisitation = [[NSUserDefaults standardUserDefaults] valueForKey:regionIdentifier];
        
        if(siteVisitation){
            
            [visitedSites addObject:regionIdentifier];
        
        }

        
    }
    
    if(_shouldSeeVisitedSitesOnly){
        
        return visitedSites;
    } else {
        
        return allSites;
    }

    
    
}

- (IBAction)toggleVisitedSites:(UIBarButtonItem *)sender {
    _shouldSeeVisitedSitesOnly = !_shouldSeeVisitedSitesOnly;
    
    if(_shouldSeeVisitedSitesOnly){
        
        [self.toggleVisitedSitesButton setTitle:@"See All Sites"];
        
    } else {
        
        [self.toggleVisitedSitesButton setTitle:@"See Visited Sites Only"];
        
    }
    
    [self.tableView reloadData];
}



@end
