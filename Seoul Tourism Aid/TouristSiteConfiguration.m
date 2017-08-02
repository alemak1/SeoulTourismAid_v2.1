//
//  TouristSiteConfiguration.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteConfiguration.h"
#import "UserLocationManager.h"
#import "NSString+HelperMethods.h"
#import "CloudKitHelper.h"

@interface TouristSiteConfiguration ()


@end


@implementation TouristSiteConfiguration

@synthesize coordinate = _coordinate;
@synthesize midCoordinate = _midCoordinate;

/** Some site configurations are powerd by Google and based on what Google determines to be a place of interest; other tourist site metadata is downloaded from iCloud and based on information from SeoulTourismBureau; the app attempts to separate functionalities powered by Google Services and those reliant upon iCloud, MapKit, and data gathered from Seoul Tourism Department **/

#pragma mark ********** Initializers

-(instancetype)initWithGMSPlaceID:(NSString *)placeID andShouldApproximateProperties:(BOOL)shouldApproximate{
    
    __block GMSPlace* place;
    
    [[GMSPlacesClient sharedClient] lookUpPlaceID:placeID callback:^(GMSPlace*result, NSError*error){
        
        if(result){
            place = result;
        } else {
            
            if(error){
                
                NSLog(@"Error occurred while looking up Location via Google PlaceID: %@",[error localizedDescription]);
                NSLog(@"Reasone for failure: %@",[error localizedFailureReason]);
                
            } else {
                NSLog(@"Error: failed to download Google Place; no results obtain from callback");

            }
            
            
        }
    }];
    
    
    if(self = [super initWithGMSPlace:place]){
        
        self.physicalAddress = place.formattedAddress;
        self.googlePlaceID = place.placeID;
        
        __block GMSPlacePhotoMetadata* photoMetaData;
        
        [[GMSPlacesClient sharedClient] lookUpPhotosForPlaceID:placeID callback:^(GMSPlacePhotoMetadataList* photos, NSError*error){
            
            photoMetaData = [photos.results firstObject];
            
        
            [[GMSPlacesClient sharedClient] loadPlacePhoto:photoMetaData constrainedToSize:CGSizeMake(100.0, 200.0) scale:1.0 callback:^(UIImage*image,NSError*error){
                
                self.largeImage = image;
                
            }];
        
        }];
        
        
        
        if(shouldApproximate){
            [self approximateTouristSiteCategoryFromGMSPlace:place];
            [self approximateGeneralAdmissionFromGMSPlace:place];
        }
        
    }
    
    return self;
}



-(instancetype)initSimpleWithCKRecord:(CKRecord*)record{
    
    
    if(self = [super init]){
        
        /** Wrap the code involving initialization of images in a dispatch_async function in order to load the images asynchronously **/
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
           
            [self initializeAssetsWithRecord:record];
        });
        
        
        [self initializePhysicalAddressWithRecord:record];
        [self initializeCategoryNumberWithRecord:record];
        [self initializeSiteDescriptionWithRecord:record];
        [self initializeAdmissionFeeWithRecord:record];
    
        [self initializeOperatingHoursWithRecord:record];
        [self initializeOperatingHoursArrayWithRecord:record];
        
        [self initializeParkingFeeArrayWithRecord:record];
        [self initializeSubtitleWithRecord:record];
        [self initializePriceInfoListWithRecord:record];
        [self initializeWebAddressWithRecord:record];
        
        
        /** These dictoinary values have already been retrieved prior to calling the base class intializer **/
        
        [self initializeTitleWithRecord:record];
        [self initializeLocationInformationWithRecord:record];
        
        
    }
    
    return self;

}


-(instancetype)initWithCKRecord:(CKRecord*)record{

    /** Call default initializer to ensure that self is intialized **/
    
    self = [super init];
    
    
    /** Peform temporary processing before calling alternative base intializers **/
    
    NSString* coordStr = record[@"coordinate"]; //String
    CLLocation* location = record[@"location"]; //CLLocation
    NSString* title = record[@"title"]; //String

    CLLocationCoordinate2D tempCoordinate;
    
    /** Call alternative base initializers depending on the data available **/
    
    if(coordStr){
        CGPoint p = CGPointFromString(coordStr);
        tempCoordinate = CLLocationCoordinate2DMake(p.x, p.y);
        self = [super initWithCoordinate:tempCoordinate andWithName:title];
    }
    
    if(location){
        tempCoordinate = location.coordinate;
        self = [super initWithCoordinate:location.coordinate andWithName:title];
    }
    
    
    if(self){
    
        /** Wrap the code involving initialization of images in a dispatch_async function in order to load the images asynchronously **/
        /** Wrap the code involving initialization of images in a dispatch_async function in order to load the images asynchronously **/
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [self initializeAssetsWithRecord:record];
        });
        
        
        [self initializePhysicalAddressWithRecord:record];
        [self initializeCategoryNumberWithRecord:record];
        [self initializeSiteDescriptionWithRecord:record];
        [self initializeAdmissionFeeWithRecord:record];
        
        [self initializeOperatingHoursWithRecord:record];
        [self initializeOperatingHoursArrayWithRecord:record];
        
        [self initializeParkingFeeArrayWithRecord:record];
        [self initializeSubtitleWithRecord:record];
        [self initializePriceInfoListWithRecord:record];
        [self initializeWebAddressWithRecord:record];
    
        
        /** These dictoinary values have already been retrieved prior to calling the base class intializer **/
        
        if(title){
            self.siteTitle = title;
        }
        
        if(coordStr){
            CGPoint p = CGPointFromString(coordStr);
            _coordinate = CLLocationCoordinate2DMake(p.x, p.y);
        }
        
        if(location){
            self.location = location;
            _midCoordinate = location.coordinate;
        }
        
        
    }
    
    return self;

}


#pragma mark ******* Helper Functions for Initializing the Tourist Site Configuration


-(void)initializeOperatingHoursWithRecord:(CKRecord*)record{

    
    CKReference* operatingHoursRef = record[@"operatingHoursByDay"]; //Reference Type (operating hours)

    if(operatingHoursRef){
        

    
        CKRecordID* recordID = operatingHoursRef.recordID;
        
        CloudKitHelper* ckHelper = [[CloudKitHelper alloc] init];

        
        [ckHelper performFetchFromPublicDBforRecordID:recordID andCompletionHandler:^(CKRecord*record,NSError*error){
        
            if(error){
                NSLog(@"CKRecord failed to download with error: %@",[error description]);
                return;
            }
        
            if(record){
                
                self.operatingHours = [[OperatingHours alloc] initWithCKRecord:record];
              
                
            } else {
                NSLog(@"CKRecord failed to download");
                return;
            }
        
        }];
        
       
    }
}

-(void)initializeOperatingHoursArrayWithRecord:(CKRecord*)record{
    
    NSArray* operatingHoursArray = record[@"operatingHoursInfo"]; //List(Strings)
    
    if(operatingHoursArray){
        self.detailedOperatingHoursInfoArray = operatingHoursArray;
    }
}

-(void)initializeParkingFeeArrayWithRecord:(CKRecord*)record{
    NSArray* parkingFeeArray = record[@"parkingFee"]; //List(String)

    if(parkingFeeArray){
        self.detailedParkingFeeInfoArray = parkingFeeArray;
    }
}

-(void)initializePriceInfoListWithRecord:(CKRecord*)record{
    NSArray* priceInfoList = record[@"priceInfo"]; //List(String)

    if(priceInfoList){
        self.detailedPriceInfoArray = priceInfoList;
    }
}

-(void)initializeSubtitleWithRecord:(CKRecord*)record{
    NSString* subtitle = record[@"subtitle"]; //String

    if(subtitle){
        self.siteSubtitle = subtitle;
    }
}


-(void)initializeWebAddressWithRecord:(CKRecord*)record{
    NSString* webAddress = record[@"webAddress"]; //String

    if(webAddress){
        self.webAddress = webAddress;
    }
}


-(void) initializePhysicalAddressWithRecord:(CKRecord*)record{
    NSString* address = record[@"address"]; //String

    if(address){
        self.physicalAddress = address;
    }
}

-(void) initializeCategoryNumberWithRecord:(CKRecord*)record{
    NSNumber* categoryNumber = record[@"category"];

    if(categoryNumber){
        self.touristSiteCategory = (TouristSiteCategory)[categoryNumber integerValue];
    }
}


-(void)initializeSiteDescriptionWithRecord:(CKRecord*)record{
NSString* siteDescription = record[@"description"]; //String

    if(siteDescription){
        self.siteDescription = siteDescription;
    }

}

-(void) initializeAdmissionFeeWithRecord:(CKRecord*)record{
    NSNumber* admissionFeeNumb = record[@"generalAdmissionFee"]; //Double

    if(admissionFeeNumb){
        self.generalAdmissionFee = [admissionFeeNumb floatValue];
    }
}


-(void)initializeAssetsWithRecord:(CKRecord*)record{
    NSArray<CKAsset*>* accessoryImages = record[@"accessoryImages"]; //Asset List
    
    if(accessoryImages){
        NSMutableArray<UIImage*>* imageArray = [[NSMutableArray alloc] init];
        
        for(CKAsset*asset in accessoryImages){
            
            UIImage* image = [self getImageFromCKAsset:asset];
            [imageArray addObject:image];
            
        }
        
        self.accessoryImages = [NSArray arrayWithArray:imageArray];
    }
    
    CKAsset* calloutImage = record[@"calloutImage"]; //Asset
    
    
    if(calloutImage){
        
        self.calloutImage = [self getImageFromCKAsset:calloutImage];
    }
    
    CKAsset* largeImage = record[@"largeImage"]; //Asset
    
    if(largeImage){
        
        self.largeImage = [self getImageFromCKAsset:largeImage];
        
    }
}


-(void)initializeTitleWithRecord:(CKRecord*)record{
    NSString* title = record[@"title"]; //String

    if(title){
        self.siteTitle = title;
    }

}

-(void)initializeLocationInformationWithRecord:(CKRecord*)record{
    NSString* coordStr = record[@"coordinate"]; //String

    if(coordStr){
        CGPoint p = CGPointFromString(coordStr);
        _coordinate = CLLocationCoordinate2DMake(p.x, p.y);
    }

    CLLocation* location = record[@"location"]; //CLLocation

    if(location){
        self.location = location;
        _midCoordinate = location.coordinate;
    }
}


-(UIImage*)getImageFromCKAsset:(CKAsset*)imageAsset{
    
    NSData* imageData = [NSData dataWithContentsOfURL:imageAsset.fileURL];
    
    return [UIImage imageWithData:imageData];
    
}

-(void)approximateTouristSiteCategoryFromGMSPlace:(GMSPlace*)place{
    
    BOOL isMuseum = [place.types containsObject:@"museum"] || [place.types containsObject:@"art_gallery"];
    
    if(isMuseum){
        self.touristSiteCategory = MUSUEM;
    }
    
    BOOL isShoppingArea = [place.types containsObject:@"shopping_mall"]  || [place.types containsObject:@"clothing_store"] || [place.types containsObject:@"convenience_store"] ||[place.types containsObject:@"home_goods_store"] || [place.types containsObject:@"department_store"] || [place.types containsObject:@"electronics_store"] |[place.types containsObject:@"store"]|[place.types containsObject:@"shoe_store"];
    
    if(isShoppingArea){
        self.touristSiteCategory = SHOPPING_AREA;
    }
    
    BOOL isNaturalSite = [place.types containsObject:@"campground"] || [place.types containsObject:@"rv_park"];
    
    if(isNaturalSite){
        self.touristSiteCategory = NATURAL_SITE;
    }
    
    BOOL isPointOfInterest = [place.types containsObject:@"point_of_interest"];
    
    if(isPointOfInterest){
        self.touristSiteCategory = OTHER;
    }

}

-(void)approximateGeneralAdmissionFromGMSPlace:(GMSPlace*)place{
    
    switch (place.priceLevel) {
        case 0:
            self.generalAdmissionFee = 0.00;
            break;
        case 1:
            self.generalAdmissionFee = 5000;
            break;
        case 2:
            self.generalAdmissionFee = 30000;
            break;
        case 3:
            self.generalAdmissionFee = 70000;
            break;
        case 4:
            self.generalAdmissionFee = 100000;
            break;
        default:
            break;
    }
}

-(CLLocationCoordinate2D)coordinate{
    return _coordinate;
}

-(CLLocationCoordinate2D)midCoordinate{
    return _midCoordinate;
}


-(void)showTouristSiteDebugInfo{
    

    NSLog(@"The category for this site is: %d",self.touristSiteCategory);
    
    NSLog(@"The has title: %@ and subtitle: %@",self.siteTitle,self.siteSubtitle);
    
    NSLog(@"The description for the site is: %@",self.siteDescription);
    
    
    NSLog(@"The general admission fee for the site is: %f KRW",self.generalAdmissionFee);

    
    if(self.detailedPriceInfoArray){
        
        NSLog(@"The detailed price info associated with this site is: ");

        for(NSString*string in self.detailedPriceInfoArray){
        
            NSLog(@"%@",string);
        
        }
        
    } else {
        NSLog(@"There is no detailed price info associated with this site.");
    }
    
    if(self.detailedOperatingHoursInfoArray){
        NSLog(@"The detailed operating hours associated with this site are as follows: ");
        
        for(NSString* string in self.detailedOperatingHoursInfoArray){
            NSLog(@"%@",string);
        }
        
    } else {
        NSLog(@"There are no detailed operating hours associated with this array");
    }
    
    
    if(self.detailedParkingFeeInfoArray){
        NSLog(@"The parking fee info for this array is as follows: ");
        
        for(NSString*string in self.detailedParkingFeeInfoArray){
            
            NSLog(@"%@",string);
            
        }
    } else {
        NSLog(@"There is no detailed parking fee info for this site configuration");
    }
    
    
    if(self.largeImage){
        NSLog(@"The large image associated with this site has debug info: %@",[self.largeImage description]);
    }
    
    
    if(self.calloutImage){
        NSLog(@"The callout image associated with this site has debug info: %@",[self.calloutImage description]);
    }
    
    /** Show Location Info **/
    
    if(self.location){
        NSLog(@"The location of the site is lat: %f, long: %f",self.location.coordinate.latitude,self.location.coordinate.longitude);
    }
    
    
    /** Show information about accessory images **/
    
    
    if(self.accessoryImages){
        
        NSLog(@"The following accessory images are associated with the Tourist Site: ");

        for (UIImage*image in self.accessoryImages) {
        
            NSLog(@"Image Debug Info: %@",[image description]);
        }
    } else {
        NSLog(@"There are no accessory images associated with this site. ");
    }
    
    /** Show Detailed Operating Hours Summary **/
    
    [self.operatingHours showOperatingHoursSummary];
    
}

/** Helper function to convert the TouristConfigurationObject to a CLRegion that can be monitored for entry and exit events **/

-(CLRegion*) getRegionFromTouristConfigurationBasedOnOverlayCoordinates{
    
    CLLocation * midLocation = [[CLLocation alloc] initWithLatitude:self.midCoordinate.latitude longitude:self.midCoordinate.longitude];
    
    CLLocation * overlayTopRightLocation = [[CLLocation alloc] initWithLatitude:self.overlayTopRightCoordinate.latitude longitude:self.midCoordinate.longitude];
    
    
    double regionRadius = [midLocation distanceFromLocation: overlayTopRightLocation];
    
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:self.midCoordinate radius:regionRadius identifier: self.title];
    
    [region setNotifyOnExit:YES];
    [region setNotifyOnEntry:YES];
    
    return region;
    
}

-(CLRegion*) getLongRangeRadiusRegionFromTouristConfiguration{
    
    return [self getRegionFromTouristConfigurationWithRadius:200.00];
    
}


-(CLRegion*) getIntermediateRadiusRegionFromTouristConfiguration{
    
    return [self getRegionFromTouristConfigurationWithRadius:150.00];
    
}

-(CLRegion*) getShortRadiusRegionFromTouristConfiguration{
    
    return [self getRegionFromTouristConfigurationWithRadius:50.00];
    
}

-(CLRegion*) getRegionFromTouristConfigurationWithRadius:(double)radius{
    
    
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:self.location.coordinate radius:radius identifier: self.siteTitle];
    
    [region setNotifyOnExit:YES];
    [region setNotifyOnEntry:YES];
    
    return region;
    
}

-(BOOL)isUnderRegionMonitoring{
    
    NSString* regionIdentifier = self.siteTitle;
    
    return [[UserLocationManager sharedLocationManager] isUnderRegionMonitoring:regionIdentifier];
}



-(NSString*)isOpenAccordingToGMS{
    
    __block NSString* isOpenStatus;
    
    [[GMSPlacesClient sharedClient] lookUpPlaceID:self.googlePlaceID callback:^(GMSPlace* place, NSError*error){
        
        GMSPlacesOpenNowStatus openNowStatus = place.openNowStatus;
        
        if(openNowStatus == kGMSPlacesOpenNowStatusYes){
            isOpenStatus = @"Open";
        } else if(openNowStatus == kGMSPlacesOpenNowStatusNo) {
            isOpenStatus = @"Closed";
        } else {
            isOpenStatus = @"Indeterminate";
        }
        
    }];
    
    return isOpenStatus;
}


-(BOOL)isOpen{
    
    if(self.operatingHours){
        
        /** First determine if the the current date falls within the open season **/
        
        NSDate* todayDate = [NSDate date];
        NSDate* openingDate = [self.operatingHours getOpeningDate];
        NSDate* closingDate = [self.operatingHours getClosingDate];
        
        if(openingDate && closingDate){
        
            if(openingDate != [todayDate earlierDate:openingDate] || closingDate != [todayDate laterDate:closingDate]){
            
                return NO;
            }
            
        }
        
        NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents* todayDateComponents = [gregorian components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:todayDate];
        
        
        NSInteger todayWeekday = [todayDateComponents weekday];
        
        NSString* todayString = [self getDayStringForNSCalendarWeekdayUnit:todayWeekday];
        
        double openingTime = [self.operatingHours getOpeningTimeForDay:todayString];
        NSLog(@"Opening time for today is %f",openingTime);
        
        double closingTime = [self.operatingHours getClosingTimeForDay:todayString];
        NSLog(@"Closing time for today is %f",closingTime);
        
        /** For days closed, the opening time and closing time are set to -1 **/
        
        if(openingTime < 0 || closingTime < 0){
            return NO; //Closed today
        }
        
        if(openingTime == 0.00 && closingTime == 24.00){
            return YES; //Always open
        }
        
        NSInteger currentHour = [todayDateComponents hour];
        NSInteger currentMinute = [todayDateComponents minute];
        NSInteger currentSecond = [todayDateComponents second];
        
        /** For establishments with regular day-time operating hours **/
        
        if(closingTime > openingTime){
            NSLog(@"This place has daytime operating hours");
            
            double currentTimeInSeconds = currentHour*3600 + currentMinute*60 + currentSecond;
            
            double openingTimeInSeconds = openingTime*3600;
            double closingTimeInSeconds = closingTime*3600;
            
            if(currentTimeInSeconds > openingTimeInSeconds && currentTimeInSeconds < closingTimeInSeconds){
                    return YES;
            }
        
            
        }
        
        /** For establishments with evening operating hours **/
        if(closingTime < openingTime){
            NSLog(@"The place has evening operating hours");
            
            NSString* previousDayString = [self getDayStringForNSCalendarWeekdayUnit:[self getPreviousDayWeekday:todayWeekday]];
            
            double previousDayClosingTime = [self.operatingHours getClosingTimeForDay:previousDayString];
            
            double todayOpeningTime = [self.operatingHours getOpeningTimeForDay:todayString];
            
            
             double currentTimeInSeconds = currentHour*3600 + currentMinute*60 + currentSecond;
            
            double openingTimeInSeconds = todayOpeningTime*3600;
            
            double earlyHoursClosingTime = previousDayClosingTime*3600;
            
            BOOL wasClosedOnYesterday = previousDayClosingTime < 0;
            
            /** The current time must be greater than the opening time for the current day, or less than the closing time of the previous day (which would be in the early hours of the current day), unless the establishment was closed on the previous day **/
            if(currentTimeInSeconds > openingTimeInSeconds || (!wasClosedOnYesterday && currentTimeInSeconds < earlyHoursClosingTime)){
                
                return YES;
                
            } else {
                return NO;
            }
        }
        
        
    }
    
    return YES;
}


/**Before calling these functions, perform the Boolean check with isOpen **/

-(NSTimeInterval)timeUntilOpening{
    
    if(self.isOpen){
        return -10.00;
    }
    
    double openingTimeForToday = [self getOpeningTimeForToday];
    double closingTimeForToday = [self getClosingTimeForToday];
    NSLog(@"The opening time for today is %f hours",openingTimeForToday);
    NSLog(@"The closing time for today is %f hours",closingTimeForToday);


    
    if(openingTimeForToday == 0.00 && closingTimeForToday == 24.00){
        //Always open
        NSLog(@"The establishment is always open");
        
        return -5.00;
    }
    
    
    NSDate* todayDate = [NSDate date];
    
    NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* todayDateComponents = [gregorian components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:todayDate];
    
    NSInteger currentHour = [todayDateComponents hour];
    NSInteger currentMinute = [todayDateComponents minute];
    NSInteger currentSecond = [todayDateComponents second];
    NSInteger currentWeekday = [todayDateComponents weekday];
    
    NSInteger tomorrowWeekday = [self getNextDayWeekday:currentWeekday];
    NSString* tomorrowDayString = [self getDayStringForNSCalendarWeekdayUnit:tomorrowWeekday];
    
    double openingTimeTomorrow =[self.operatingHours getOpeningTimeForDay:tomorrowDayString];
    
    double closingTimeTomorrow = [self.operatingHours getClosingTimeForDay:tomorrowDayString];
    
    if(openingTimeForToday < 0.00 || closingTimeForToday < 0.00){
        //Estabishment closed today
        NSLog(@"The establishment is closed today");
        
        //TODO: determine if is open tomorrow
        if(openingTimeTomorrow < 0.00 || closingTimeTomorrow < 24.00){
            return -4.00; //Establishment is closed tomorrow
        }
    }
    
    
    
    double currentTimeInSeconds = currentHour*3600 + currentMinute*60 + currentSecond;
   
    if(currentTimeInSeconds < openingTimeForToday*3600){
        return [self getOpeningTimeForToday]*3600 - currentTimeInSeconds;
    } else {
        
        if(openingTimeTomorrow < 0){
            return -4; //The establishment is closed tomorrow
        }
        
        return openingTimeTomorrow*3600 + (24*3600 - currentTimeInSeconds);
    }
    
}

-(NSTimeInterval)timeUntilClosing{
    
    double closingTimeForToday = [self getClosingTimeForToday];
    double openiningTimeForToday = [self getOpeningTimeForToday];
    
    NSLog(@"The opening time for today is %f hours",openiningTimeForToday);
    NSLog(@"The closing time for today is %f hours",closingTimeForToday);
    

    if(closingTimeForToday == 24.00 && openiningTimeForToday == 0.00){
        
        return -5.00; //Always open
        
    }

    if(!self.isOpen){
        return -10.00;
    }
    
    
    NSDate* todayDate = [NSDate date];
    
    NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* todayDateComponents = [gregorian components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:todayDate];
    
    NSInteger currentHour = [todayDateComponents hour];
    NSInteger currentMinute = [todayDateComponents minute];
    NSInteger currentSecond = [todayDateComponents second];
    NSInteger currentWeekday = [todayDateComponents weekday];
    
    NSInteger nextDayWeekday = [self getNextDayWeekday:currentWeekday];
    NSString* nextDayString = [self getDayStringForNSCalendarWeekdayUnit:nextDayWeekday];
    
   
    double currentTimeInSeconds = currentHour*3600 + currentMinute*60 + currentSecond;
    
   

    if(closingTimeForToday > openiningTimeForToday){ /** Daytime-Hour establishments **/
        
        return closingTimeForToday*3600 - currentTimeInSeconds;

    } else { /** Evening hour establishments **/
        
        if(currentTimeInSeconds > 24*3600){ //Current time is past midnight
            
            return closingTimeForToday*3600 - currentTimeInSeconds;
            
        } else { //Current time is before midnight
            
            return (24*3600 - currentTimeInSeconds) + closingTimeForToday*3600;
        }
        
    }
    

    
}


-(NSString *)timeUntilClosingString{
    
    if(self.timeUntilClosing == -10.00){
        return @"Error: establishement is currently closed.";
    }
    
    if(self.timeUntilClosing == -5.00){
        return @"Always Open";
    }
    
    return [NSString timeFormattedStringFromTotalSeconds:self.timeUntilClosing];
}


-(NSString*)timeUntilOpeningString{
    
    
    if(self.timeUntilOpening == -10.00){
        return @"Error: establishment is current open";
    }
    
    /** Establishment is always open **/
    
    if(self.timeUntilOpening == -5.00){
        return @"Always Open";
    }
    
    /** Establishment is currently closed, and will not open tomorrow either **/
    
    if(self.timeUntilOpening == -4.00){
        return @"Closed Tomorrow";
    }
    
    /** Establishement will open today or tomorrow at designated opening time **/
    return [NSString timeFormattedStringFromTotalSeconds:self.timeUntilOpening];
}

-(double)getOpeningTimeForToday{
    
    NSDate* todayDate = [NSDate date];

    NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* todayDateComponents = [gregorian components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:todayDate];
    
    NSInteger todayWeekday = [todayDateComponents weekday];
    
    NSString* todayString = [self getDayStringForNSCalendarWeekdayUnit:todayWeekday];
    
    return [self.operatingHours getOpeningTimeForDay:todayString];
    
}

-(double)getClosingTimeForToday{
    NSDate* todayDate = [NSDate date];

    NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* todayDateComponents = [gregorian components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:todayDate];
    
    NSInteger todayWeekday = [todayDateComponents weekday];
    
    NSString* todayString = [self getDayStringForNSCalendarWeekdayUnit:todayWeekday];
    
    return [self.operatingHours getClosingTimeForDay:todayString];
    
}
 

-(CGFloat)distanceFromUser{

    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];

    
    if(!self.location){
        CLLocationDegrees lat = self.coordinate.latitude;
        CLLocationDegrees lon = self.coordinate.longitude;
        
        self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    }
    
    return [userLocation distanceFromLocation:self.location];
}

-(NSString*)distanceFromUserString{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    if(self.distanceFromUser == 0){
        return @"";
    }
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.distanceFromUser]];
    
}

-(NSInteger)getPreviousDayWeekday:(NSInteger)todayWeekday{
    
    if(todayWeekday == 1){
        return 7;
    } else {
        
        return todayWeekday - 1;
    }

}

-(NSInteger)getNextDayWeekday:(NSInteger)todayWeekday{
    
    if(todayWeekday == 7){
        return 1;
    } else {
        return todayWeekday + 1;
    }
}

-(NSString*)getDayStringForNSCalendarWeekdayUnit:(NSInteger)weekdayUnit{
    
    switch (weekdayUnit) {
        case 1:
            return @"Sunday";
        case 2:
            return @"Monday";
        case 3:
            return @"Tuesday";
        case 4:
            return @"Wednesday";
        case 5:
            return @"Thursday";
        case 6:
            return @"Friday";
        case 7:
            return @"Saturday";
     
    }
    
    return nil;
}

-(void)showOperatingHoursForSite{
    
    [self.operatingHours showOperatingHoursSummary];
}

@end
