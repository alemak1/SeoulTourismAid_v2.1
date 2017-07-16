//
//  TouristSiteConfiguration.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/25/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

/**
#import <Foundation/Foundation.h>
#import "TouristSiteConfiguration.h"
#import "NSString+HelperMethods.h"
#import "UserLocationManager.h"
#import "MKDirectionsRequest+HelperMethods.h"

@interface TouristSiteConfiguration () <NSCoding>

@property (readonly) NSDate* currentDateForKorea;
@property (readonly) NSTimeInterval currentDateForKoreaInSeconds;

@property (readonly) NSTimeInterval openingTimeInSeconds;
@property (readonly) NSTimeInterval closingTimeInSeconds;



@end

@implementation TouristSiteConfiguration
 
 **/

/**
@synthesize midCoordinate = _midCoordinate;
@synthesize overlayBottomLeftCoordinate = _overlayBottomLeftCoordinate;
@synthesize overlayBottomRightCoordinate = _overlayBottomRightCoordinate;
@synthesize overlayTopLeftCoordinate = _overlayTopLeftCoordinate;
@synthesize overlayTopRightCoordinate = _overlayTopRightCoordinate;
@synthesize overlayBoundingMapRect = _overlayBoundingMapRect;
@synthesize boundaryPointsCount = _boundaryPointsCount;
@synthesize boundary = _boundary;


NSUInteger _numberOfDaysClosed = 0;
CLLocation* _lastUpdatedUserLocation;



-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super init]){
        
    }
    
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
}

**/

/** Tourist Objects can also be initialized from file directly, with the initializer implementation overriding that of the base class

- (instancetype)initWithFilename:(NSString *)filename{
    
    self = [super initWithFilename:filename];
    
    if(self){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *configurationDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        _title = [configurationDictionary valueForKey:@"title"];
        
        _siteDescription = [configurationDictionary valueForKey:@"description"];
        _admissionFee = [[configurationDictionary valueForKey:@"admissionFee"] doubleValue];
        _touristSiteCategory = (int)[[configurationDictionary valueForKey:@"category"] integerValue];
        _imagePath = [configurationDictionary valueForKey:@"imagePath"];
        
        _openingTime = [configurationDictionary valueForKey:@"openingTime"];
        _closingTime = [configurationDictionary valueForKey:@"closingTime"];
        
        _physicalAddress = [configurationDictionary valueForKey:@"physicalAddress"];
        _webAddress = [configurationDictionary valueForKey:@"webAddress"];
        _specialNote = [configurationDictionary valueForKey:@"specialNote"];
        
        
        
        NSArray* daysClosedArray = [configurationDictionary valueForKey:@"daysClosed"];
        NSLog(@"Days Closed Array: %@",[daysClosedArray description]);
        
        _numberOfDaysClosed = [daysClosedArray count];
        
        _daysClosed = calloc(sizeof(int), _numberOfDaysClosed);
        
        for(int i = 0; i < _numberOfDaysClosed; i++){
            NSLog(@"Value from daysClosedArray",[daysClosedArray[i] integerValue]);
            _daysClosed[i] = [daysClosedArray[i] integerValue];
            NSLog(@"%@ is closed on: %d",_title,_daysClosed[i]);
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocation:) name:@"userLocationDidUpdateNotification" object:nil];
        
        
       
    }
    
    return self;
}

 **/

/** Since the TouristSiteManager is initialized from a plist file containing an array of dictionaries, each configuration object can be initialized with dictionary in order to facilitiate the initialization of the Tourist Object manager class

-(instancetype)initWithConfigurationDict:(NSDictionary*)configurationDictionary{
    
    self = [super initWithDictionary:configurationDictionary];
    
    if(self){
        
        _title = [configurationDictionary valueForKey:@"title"];
        _siteDescription = [configurationDictionary valueForKey:@"description"];
        _admissionFee = [[configurationDictionary valueForKey:@"admissionFee"] doubleValue];
        _touristSiteCategory = (int)[[configurationDictionary valueForKey:@"category"] integerValue];

        _openingTime = [configurationDictionary valueForKey:@"openingTime"];
        _closingTime = [configurationDictionary valueForKey:@"closingTime"];
        
        _physicalAddress = [configurationDictionary valueForKey:@"physicalAddress"];
        _webAddress = [configurationDictionary valueForKey:@"webAddress"];
        _specialNote = [configurationDictionary valueForKey:@"specialNote"];
        _imagePath = [configurationDictionary valueForKey:@"imagePath"];

        
        
        NSArray* daysClosedArray = [configurationDictionary valueForKey:@"daysClosed"];
        _numberOfDaysClosed = [daysClosedArray count];
        
        _daysClosed = calloc(sizeof(int), _numberOfDaysClosed);
        
        for(int i = 0; i < _numberOfDaysClosed; i++){
            _daysClosed[i] = [daysClosedArray[i] integerValue];
            
        }
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocation:) name:@"userLocationDidUpdateNotification" object:nil];
        
        
    }
    
    
    return self;
    
}


-(NSString*)debugDescriptionA{
    return [NSString stringWithFormat:@"Tourist Site Title: %@; Name: %@; Description: %@",self.title,self.name,self.siteDescription];
}

-(NSString*)debugDescriptionB{
     NSString* rawString = [NSString stringWithFormat:@"Tourist Site Title: %@; Name: %@; Description: %@; Opens at %f, Closes at %f, Category: %@",self.title,self.name,self.siteDescription,[self.openingTime doubleValue],[self.closingTime doubleValue],[self stringForTouristSiteCategory:self.touristSiteCategory]];
    
    rawString = [rawString stringByAppendingString:@" Closed on the following days: "];
    
    for(int i = 0; i < _numberOfDaysClosed; i++){
        NSString* dayClosed = [self stringForDayOfWeek:_daysClosed[i]];
    
        rawString = [rawString stringByAppendingString:[NSString stringWithFormat:@"%@, ", dayClosed]];
    }
    
    return rawString;
}


- (NSString*) stringForDayOfWeek:(DayOfWeek)day{
    switch (day) {
        case MONDAY:
            return @"Monday";
        case TUESDAY:
            return @"Tuesday";
        case WEDNESDAY:
            return @"Wednesday";
        case THURSDAY:
            return @"Thursday";
        case FRIDAY:
            return @"Friday";
        case SATURDAY:
            return @"Saturday";
        case SUNDAY:
            return @"Sunday";
    }
}


- (NSString*) stringForTouristSiteCategory:(TouristSiteCategory)touristSiteCategory{
    
    NSString* stringCategory;
    
    switch (touristSiteCategory) {
        case MONUMENT_OR_WAR_MEMORIAL:
            stringCategory = @"Monument/Memorial";
            break;
        case RADIO_TOWER:
            stringCategory = @"Radio Tower";
            break;
        case SHOPPING_AREA:
            stringCategory = @"Shopping Area";
            break;
        case NATURAL_SITE:
            stringCategory = @"Natural Site";
            break;
        case NIGHT_MARKET:
            stringCategory = @"Night Market";
            break;
        case MUSUEM:
            stringCategory = @"Museum";
            break;
        case TEMPLE:
            stringCategory = @"Temple";
            break;
        case PARK:
            stringCategory = @"Park";
            break;
        default:
            break;
    }
    
    return stringCategory;
}

 **/

/** Helper function to convert the TouristConfigurationObject to a CLRegion that can be monitored for entry and exit events

-(CLRegion*) getRegionFromTouristConfiguration{
    
    CLLocation * midLocation = [[CLLocation alloc] initWithLatitude:self.midCoordinate.latitude longitude:self.midCoordinate.longitude];
    
    CLLocation * overlayTopRightLocation = [[CLLocation alloc] initWithLatitude:self.overlayTopRightCoordinate.latitude longitude:self.midCoordinate.longitude];
    
    
    double regionRadius = [midLocation distanceFromLocation: overlayTopRightLocation];
    
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:self.midCoordinate radius:regionRadius identifier: self.title];
    
    [region setNotifyOnExit:YES];
    [region setNotifyOnEntry:YES];
    
    return region;
    
}

-(CLRegion*) getRegionFromTouristConfigurationWithRadius:(double)radius{
    
   
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:self.midCoordinate radius:radius identifier: self.title];
    
    [region setNotifyOnExit:YES];
    [region setNotifyOnEntry:YES];
    
    return region;
    
}

**/

/**
 
-(BOOL)isOpen{
    
    CGFloat openingTime = [self.openingTime doubleValue];
    CGFloat closingTime = [self.closingTime doubleValue];
    
    /** If the site is open all hours, opening and closing time are less than zero **/
/**
    if(openingTime < 0.00 || closingTime < 0.00){
        return true;
    }
    
    NSTimeInterval currentTimeInSeconds = self.currentDateForKoreaInSeconds;

    /** If operating hours are from late evening to early morning the next time, then first check if opening time is greater than closing time (i.e. bars, clubs, and Pyoungwa Fashion town are typical examples) **/

/**
    if(openingTime > closingTime){
         return !(currentTimeInSeconds > self.closingTimeInSeconds) && (currentTimeInSeconds < self.openingTimeInSeconds);
        
    }
    
    /** For typical operating hours, where opening and closing time fall within the same 24-hour period, compare current time against closing and opening times **/
    /**
    return (currentTimeInSeconds > self.openingTimeInSeconds) && (currentTimeInSeconds < self.closingTimeInSeconds);
}


-(NSTimeInterval)timeUntilClosing{
    
    if(!self.isOpen){
        return -1.00;
    }
    
    if(self.openingTime > self.closingTime){
        
        //TODO: Not yet implemented
        return -5000000;
    }
    
    NSTimeInterval timeUntilClosing = [self closingTimeInSeconds] - [self currentDateForKoreaInSeconds];
    
    return timeUntilClosing;
    
}


-(NSTimeInterval)timeUntilOpening{
    
    if(self.isOpen){
        return -1.00;
    }
    
    if(self.openingTime > self.closingTime){
        //TODO: Not yet implemented
        
        return -5000000;

        
    }
    
    return [self openingTimeInSeconds] - [self currentDateForKoreaInSeconds];
   
}

-(NSString *)timeUntilClosingString{
    
    return [NSString timeFormattedStringFromTotalSeconds:self.timeUntilClosing];
}

-(NSString*)timeUntilOpeningString{
    return [NSString timeFormattedStringFromTotalSeconds:self.timeUntilOpening];
}

-(CGFloat)distanceFromUser{
    //TODO: get user's current location to calculate the distance to the site
    CLLocation* touristSiteLocation = [[CLLocation alloc] initWithLatitude:self.midCoordinate.latitude longitude:self.midCoordinate.longitude];
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    CLLocationDistance distanceInMeters = [userLocation distanceFromLocation:touristSiteLocation];
    
    return distanceInMeters;
}

-(CGFloat)travelingTimeFromUserLocation{
    //TODO: get the user's current location to calculate the distance to the site
    
    /** Get a direcctions request from the user's current location  **/

/**
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest getDirectionsRequestToDestinationWithCoordinate:CLLocationCoordinate2DMake(self.midCoordinate.latitude, self.midCoordinate.longitude) andWithTransportationMode:TRANSIT];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAny;
    
    
    MKDirections *routeDirections = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    
    
    __block MKRoute* routeToTouristSite = nil;
    
    __block NSTimeInterval travelTime = 0;
    
    [routeDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * routeResponse, NSError *routeError) {
        if (routeError) {
            
            NSLog(@"Error: failed to calculate directions to tourist site %@",[routeError description]);
            
            CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
            
            CLLocation* destinationLocation = [[CLLocation alloc] initWithLatitude:self.midCoordinate.latitude longitude:self.midCoordinate.longitude];
            
            CLLocationDistance distanceToLocation = [userLocation distanceFromLocation:destinationLocation];
            
            /** Use an average travel time of 30 m/s to compute an average travel time **/

/**
            travelTime = distanceToLocation/50.0;
            NSLog(@"Estimated travel time of %f used",travelTime);
            
        } else {
            routeToTouristSite = routeResponse.routes[0];
        }
    }];

    
    if(routeToTouristSite){
        travelTime = [routeToTouristSite expectedTravelTime];
    }
    
    return travelTime;
}

-(void)updateUserLocation:(NSNotification*)userLocationDidUpdateNotification{
    
    NSDictionary* userInfoDict = [userLocationDidUpdateNotification userInfo];
    
    CLLocation* userLocation = (CLLocation*)[userInfoDict valueForKey:@"userLocation"];
    
    _lastUpdatedUserLocation = userLocation;
    
}



-(NSTimeInterval)openingTimeInSeconds{
    
    double openingTimeDecimal = [self.openingTime doubleValue];
    
    return openingTimeDecimal*(60*60);
    
}

-(NSTimeInterval)closingTimeInSeconds{
    double closingTimeDecimal = [self.closingTime doubleValue];
    
    return closingTimeDecimal*(60*60);
}

-(NSTimeInterval)currentDateForKoreaInSeconds{
    
    NSDate* koreaDate = [self currentDateForKorea];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:koreaDate];
    
    NSInteger hour = [components hour];
    NSInteger minutes = [components minute];
    
    return hour*3600+minutes*60;
}


-(NSDate *)currentDateForKorea{
    NSDate* currentDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:currentDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval timeInterval = destinationGMTOffset - sourceGMTOffset;
    
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:currentDate];
    
}


/** distanceFromUserString and travelingTimeFromUserLocationString are computed properties whose values depend on distanceFromUser and travelingTimeFromUserLocation respectively **/

/**
-(NSString*)distanceFromUserString{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    if(self.distanceFromUser == 0){
        return @"";
    }
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.distanceFromUser]];
    
}

-(NSString*)travelingTimeFromUserLocationString{
    
    return [NSString timeHHMMSSFormattedStringFromTotalSeconds:self.travelingTimeFromUserLocation];
    
    
}

-(int)numberOfDaysClosed{
    
    return _numberOfDaysClosed;
    
}

/**  Register dependent keys for KVO **/

/**
+(NSSet<NSString *> *)keyPathsForValuesAffectingDistanceFromUserString{
    return [NSSet setWithObjects:@"distanceFromUser", nil];
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingTravelingTimeFromUserLocationString{
    return [NSSet setWithObjects:@"travelingTimeFromUserLocation", nil];
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingCurrentDateForKoreaInSeconds{
    return [NSSet setWithObjects:@"currentDateForKorea", nil];
}


+(NSSet<NSString *> *)keyPathsForValuesAffectingIsOpen{
    
    return [NSSet setWithObjects:@"currentDateForKoreaInSeconds",@"openingTimeInSeconds",@"closingTimeInSeconds",nil];
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingClosingTimeInSeconds{
    return [NSSet setWithObjects:@"closingTime", nil];
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingOpeningTimeInSeconds{
    return [NSSet setWithObjects:@"openingTime", nil];
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingTimeUntilOpening{
    return [NSSet setWithObjects:@"openingTimeInSeconds",@"currentDateForKoreaInSeconds", nil];

}

+(NSSet<NSString *> *)keyPathsForValuesAffectingTimeUntilClosing{
    return [NSSet setWithObjects:@"closingTimeInSeconds",@"currentDateForKoreaInSeconds", nil];

}

+(NSSet<NSString *> *)keyPathsForValuesAffectingTimeUntilClosingString{
    return [NSSet setWithObjects:@"timeUntilClosing", nil];

}

+(NSSet<NSString *> *)keyPathsForValuesAffectingTimeUntilOpeningString{
    return [NSSet setWithObjects:@"timeUntilOpening", nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
 
 **/
