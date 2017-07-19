//
//  OperatingHours.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#ifndef OperatingHours_h
#define OperatingHours_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface OperatingHours : UIViewController

-(instancetype)init;
-(instancetype)initWithCKRecord:(CKRecord*)record;

-(NSDate*)getOpeningDate;
-(NSDate*)getClosingDate;
-(double)getClosingTimeForDay:(NSString*)day;
-(double)getOpeningTimeForDay:(NSString*)day;


-(void)showOperatingHoursSummary;

@end

#endif /* OperatingHours_h */
