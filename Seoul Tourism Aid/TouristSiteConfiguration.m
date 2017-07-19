//
//  TouristSiteConfiguration.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "TouristSiteConfiguration.h"


@interface TouristSiteConfiguration ()


@end


@implementation TouristSiteConfiguration

@synthesize coordinate = _coordinate;
@synthesize midCoordinate = _midCoordinate;


#pragma mark ********** Initializers

-(instancetype)initWithGMSPlace:(GMSPlace *)place andShouldApproximateProperties:(BOOL)shouldApproximate{
    
    if(self = [super initWithGMSPlace:place]){
        
        self.physicalAddress = place.formattedAddress;
        self.googlePlaceID = place.placeID;
        
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
        CKRecord* record = [[CKRecord alloc] initWithRecordType:@"Annotation" recordID:recordID];
    
        if(record){
            self.operatingHours = [[OperatingHours alloc] initWithCKRecord:record];
        }
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

@end
