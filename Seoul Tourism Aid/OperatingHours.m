//
//  OperatingHours.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperatingHours.h"


@interface OperatingHours ()

@property NSString* name;
@property NSDate* openingDate;
@property NSDate* closingDate;

@property NSDictionary* operatingHoursDict;


@end


@implementation OperatingHours


/** Default Initialization for Operating Hours: Default initialization represents year-round, all-day operating hours.  Opening Date is Jan. 1 of the current year, Closing Date is Dec. 31 of the current year;  Mutable arrays with operating hours from 0.00 to 24.00 are mapped to each key representing the day of the week in the operating hours dictionary. **/

-(instancetype)init{
    if(self = [super init]){
        
        NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Monday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Tuesday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Wednesday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Thursday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Friday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Saturday"];
        
        [mutableDict setObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.00],[NSNumber numberWithFloat:24.00], nil] forKey:@"Sunday"];
        
        self.operatingHoursDict = [NSDictionary dictionaryWithDictionary:mutableDict];
        
        
        
        NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents* currentDateComponents = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
        
        NSInteger currentYear = [currentDateComponents year];
        
        NSDateComponents* dateComponents1 = [[NSDateComponents alloc] init];
        
        [dateComponents1 setMonth:1];
        [dateComponents1 setDay:1];
        [dateComponents1 setYear:currentYear];
        
        self.openingDate = [gregorian dateFromComponents:dateComponents1];
        
        NSDateComponents* dateComponents2 = [[NSDateComponents alloc] init];
        
        [dateComponents2 setYear:currentYear];
        [dateComponents2 setMonth:12];
        [dateComponents2 setDay:31];
        
        self.closingDate =[gregorian dateFromComponents:dateComponents2];
        

    }
    
    return self;
}

-(instancetype)initWithCKRecord:(CKRecord*)record{
    
    if(self = [super init]){
        
        NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
        

        NSArray* monArray = record[@"Monday"];
        if(monArray){
            [mutableDict setObject:monArray forKey:@"Monday"];
        }

        NSArray* tuesArray = record[@"Tuesday"];
        if(tuesArray){
            [mutableDict setObject:tuesArray forKey:@"Tuesday"];
        }

        NSArray* wedArray = record[@"Wednesday"];
        if(wedArray){
        [mutableDict setObject:wedArray forKey:@"Wednesday"];
        }
        
        NSArray* thursArray = record[@"Thursday"];
        if(thursArray){
        [mutableDict setObject:thursArray forKey:@"Thursday"];
        }
        
        
        NSArray* friArray = record[@"Friday"];
        if(friArray){
            [mutableDict setObject:friArray forKey:@"Friday"];
        }
        
        NSArray* satArray = record[@"Saturday"];
        if(satArray){
        [mutableDict setObject:satArray forKey:@"Saturday"];
        }
        
        NSArray* sunArray = record[@"Sunday"];
        if(sunArray){
            [mutableDict setObject:sunArray forKey:@"Sunday"];
        }
        
        self.operatingHoursDict = [NSDictionary dictionaryWithDictionary:mutableDict];
        
        NSDate* closingDate = record[@"endDate"];

        if(closingDate){
            self.closingDate = [self getCurrentYearDateForDateWithMonthAndDay:closingDate];
        }
        
        NSDate* startingDate = record[@"startDate"];
        
        if(startingDate){
            self.openingDate = [self getCurrentYearDateForDateWithMonthAndDay:startingDate];

        }
      
        NSString* name =  record[@"name"];
        if(name){
            self.name = name;
        }

    }
    
    return self;
}

-(NSDate*)getOpeningDate{
    return self.openingDate;
}

-(NSDate*)getClosingDate{
    return self.closingDate;
}


-(double)getClosingTimeForDay:(NSString*)day{
    
    return [[[self.operatingHoursDict valueForKey:day] lastObject] doubleValue];
}

-(double)getOpeningTimeForDay:(NSString*)day{
    
    return [[[self.operatingHoursDict valueForKey:day] firstObject] doubleValue];

}

/** This function takes a date whoe month and day components are specified and returns a date with year,month, and day specified, the year being set to the current year **/

-(NSDate*)getCurrentYearDateForDateWithMonthAndDay:(NSDate*)rawDate{
    
    /** Get the component for current year from the current date **/
    
    NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents* currentDateComponents = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger currentYear = [currentDateComponents year];
    
    NSDateComponents* rawDateComponents = [gregorian components:NSCalendarUnitDay|NSCalendarUnitMonth fromDate:rawDate];
    
    NSInteger month = [rawDateComponents month];
    NSInteger day = [rawDateComponents day];
    
    NSDateComponents* modifiedDateComponents = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:rawDate];
    
    [modifiedDateComponents setYear:currentYear];
    [modifiedDateComponents setDay:day];
    [modifiedDateComponents setMonth:month];
    
    return [gregorian dateFromComponents:modifiedDateComponents];
    
}


-(void)showOperatingHoursSummary{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString* openingDateString = [dateFormatter stringFromDate:self.openingDate];
    NSString* closingDateString = [dateFormatter stringFromDate:self.closingDate];
    
    NSLog(@"Applicable dates for %@ are from %@ to %@",self.name,openingDateString,closingDateString);
    
    NSArray* daysOfWeek = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    
    NSLog(@"The per-day operating hours are: ");
    
    for (NSString*day in daysOfWeek) {
        double openingTime = [self getOpeningTimeForDay:day];
        double closingTime = [self getClosingTimeForDay:day];
        
        NSLog(@"%@ from %f to %f",day,openingTime,closingTime);
        
    }
}

@end
