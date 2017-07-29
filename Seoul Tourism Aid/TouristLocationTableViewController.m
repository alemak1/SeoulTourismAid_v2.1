//
//  TouristLocationTableViewController.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouristLocationTableViewController.h"
#import "HeaderViewConfiguration.h"
#import "HostelLocationAnnotation.h"
#import "AnnotationManager.h"
#import "SeoulLocationAnnotation+HelperMethods.h"

@interface TouristLocationTableViewController ()

@property AnnotationManager* annotationManager;

@property SeoulLocationAnnotation* selectedAnnotation;





@end

@implementation TouristLocationTableViewController


BOOL _seeNameOnly = true;

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    /** Set table view delegate and register table view cells **/
    
    [self.tableView setDelegate:self];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    /** Initialize placemark dictionary from plist file **/
    
    self.annotationManager = [[AnnotationManager alloc] initWithFilename:self.annotationFilePath];
    
}


-(void)dismissNavigationController{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)popToRootViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    
    /** Possible use in future iOS tutorials:
     
    UIBarButtonItem* backToMenu = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemRewind target:self action:@selector(dismissNavigationController)];
    
    UIBarButtonItem*viewAddressButton = [[UIBarButtonItem alloc]initWithTitle:@"See Full Description" style:UIBarButtonItemStylePlain target:self action:@selector(reloadTableViewToShowAddresses)];
    

    self.navigationItem.leftBarButtonItem = backToMenu;
    self.navigationItem.rightBarButtonItem = viewAddressButton;
     **/
    
}

-(void) reloadTableViewToShowAddresses{
    
    _seeNameOnly = !_seeNameOnly;
    
    if(_seeNameOnly){
        [self.navigationItem.rightBarButtonItem setTitle:@"See Full Description"];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"See Name Only"];
    }
    
    [self.tableView reloadData];
}


#pragma mark ******* TABLEVIEW DATA SOURCE METHODS


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return LAST_LOCATION_TYPE_INDEX;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray* annotationsArray = [self.annotationManager getAnnotationsOfType:section];
    
    return [annotationsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    tableViewCell.textLabel.attributedText = [self getAttributedStringForTitleAt:indexPath];
    
    return tableViewCell;
    
}

#pragma mark *********** TABLEVIEW DELEGATE METHODS


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SeoulLocationAnnotation* annotation = [self.annotationManager getAnnotationForIndexPath:indexPath];
    
    
    self.selectedAnnotation = annotation;
}


-(SeoulLocationAnnotation *)getUserSelectedAnnotation{
    return self.selectedAnnotation;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString* headerTitle = [SeoulLocationAnnotation getTitleForLocationType: section];
    
    return headerTitle;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* headerView = [[UIView alloc]init];
    
    HeaderViewConfiguration* headerViewConfiguration = [HeaderViewConfiguration getHeaderViewConfigurationForSection:section];
    
    NSString* imageName = [headerViewConfiguration imageName];
    UIFont* titleFont = [headerViewConfiguration titleFont];
    UIColor* textColor = [headerViewConfiguration textColor];
    NSString* text = [headerViewConfiguration text];
    
    UIImageView* headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    [headerImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:headerImageView];
    
    UILabel* labelView = [[UILabel alloc]init];
    [labelView setFont:titleFont];
    [labelView setText:text];
    [labelView setTextColor:textColor];
    
    [labelView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:labelView];
    
    
    
    NSArray<NSLayoutConstraint*>* headerViewConstraint = [NSArray arrayWithObjects:[[headerImageView centerYAnchor] constraintEqualToAnchor:[headerView centerYAnchor]],
        [[headerImageView leftAnchor] constraintEqualToAnchor:[headerView leftAnchor] constant:15.00],
        [[labelView centerYAnchor] constraintEqualToAnchor:[headerImageView centerYAnchor]],
        [[labelView leftAnchor] constraintEqualToAnchor:[headerImageView leftAnchor] constant:30.0], nil];
    
    [NSLayoutConstraint activateConstraints:headerViewConstraint];

    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}







- (NSMutableAttributedString*) getAttributedStringForTitleAt:(NSIndexPath*)indexPath{
    SeoulLocationAnnotation* annotation = [self.annotationManager getAnnotationForIndexPath:indexPath];
    
    NSString* name = annotation.title;
    
    NSString* address = annotation.address;
    
    NSString* fullString;
    
    if(_seeNameOnly){
        fullString = [NSString stringWithFormat:@"%@",name];

    } else {
        fullString = [NSString stringWithFormat:@"%@ on %@",name,address];

    }
    
    NSMutableAttributedString* cellString = [[NSMutableAttributedString alloc]initWithString:fullString];
    
    
    [cellString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"IowanOldStyle-BoldItalic" size:15.0] range:NSMakeRange(0, [name length])];
    
    NSShadow* shadowConfiguration = [[NSShadow alloc]init];
    
    [shadowConfiguration setShadowOffset:CGSizeMake(1.0, 1.0)];
    [shadowConfiguration setShadowBlurRadius:1.00];
    
    [cellString addAttribute:NSShadowAttributeName value:shadowConfiguration range:NSMakeRange(0, [name length])];
    
    [cellString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Cochin" size:13.0] range:NSMakeRange([name length], [cellString length] - [name length])];
    
    return cellString;
}


-(BOOL)canOnlySeeNameForTableViewCells{
    return _seeNameOnly;
}

-(void)setCanOnlySeeNameForTableViewCells:(BOOL)canOnlySeeNameForTableViewCells{
    _seeNameOnly = canOnlySeeNameForTableViewCells;
}

@end
