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
#import "LocalAreaNavController.h"

@interface HostelAreaMapViewController ()


@end


@implementation HostelAreaMapOptionsController

static void* SelectedOptionsContext = &SelectedOptionsContext;



-(void)viewDidAppear:(BOOL)animated{
    self.selectedOptions = [[NSMutableArray alloc] init];

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
    
    
    LocalAreaNavController* localAreaNavController = (LocalAreaNavController*)self.presentingViewController;
    
    [localAreaNavController.selectedOptions addObject:[NSNumber numberWithInt:(int)indexPath.row]];
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LocalAreaNavController* localAreaNavController = (LocalAreaNavController*)self.presentingViewController;
    
    [localAreaNavController.selectedOptions removeObject:[NSNumber numberWithInt:(int)indexPath.row]];

   
}


    
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(void)dismissMapOptionsViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
        [backButton setTitle:@"Back to Map View" forState:UIControlStateNormal];
    
        [backButton addTarget:self action:@selector(dismissMapOptionsViewController) forControlEvents:UIControlEventTouchDown];
    
    
    
        return backButton;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

-(void)setSelectedOptions:(NSMutableArray *)selectedOptions{
    LocalAreaNavController* localAreaNavController = (LocalAreaNavController*)self.presentingViewController;
    
    localAreaNavController.selectedOptions = selectedOptions;
}

-(NSMutableArray<NSNumber *> *)selectedOptions{
    LocalAreaNavController* localAreaNavController = (LocalAreaNavController*)self.presentingViewController;
    
    return localAreaNavController.selectedOptions;
}

@end
