//
//  HostelAreaMapOptionsController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 7/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostelAreaMapOptionsController.h"
#import "HostelAreaMapViewController.h"
#import "HostelLocationAnnotation.h"
#import "SeoulLocationAnnotation+HelperMethods.h"
#import "DirectionsMenuController.h"

@implementation HostelAreaMapOptionsController

static void* SelectedOptionsContext = &SelectedOptionsContext;

-(void)viewWillLayoutSubviews{
    


}

-(void)viewDidLoad{
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView setAllowsSelection:YES];
    [self.tableView setAllowsMultipleSelection:YES];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    
   
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return LAST_LOCATION_TYPE_INDEX;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"HostelAreaOptionsCell"];
    
    NSString* title = [SeoulLocationAnnotation getTitleForLocationType:indexPath.row];
    
    [cell.textLabel setAttributedText:[[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:17.0],NSFontAttributeName, nil]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
    DirectionsMenuController* directionsMenuController = (DirectionsMenuController*)self.presentingViewController;
    
    [directionsMenuController.selectedOptions addObject:[NSNumber numberWithInt:indexPath.row]];
     **/
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
    DirectionsMenuController* directionsMenuController = (DirectionsMenuController*)self.presentingViewController;
    
    [directionsMenuController.selectedOptions removeObject:[NSNumber numberWithInt:indexPath.row]];
     **/
    
}
    



@end
