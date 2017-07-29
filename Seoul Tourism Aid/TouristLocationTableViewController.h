//
//  TouristLocationTableViewController.h
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef TouristLocationTableViewController_h
#define TouristLocationTableViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SeoulLocationAnnotation+HelperMethods.h"

@interface TouristLocationTableViewController : UITableViewController

@property NSString* annotationFilePath;

-(void) reloadTableViewToShowAddresses;

-(SeoulLocationAnnotation*)getUserSelectedAnnotation;

@property BOOL canOnlySeeNameForTableViewCells;


@end

#endif /* TouristLocationTableViewController_h */
