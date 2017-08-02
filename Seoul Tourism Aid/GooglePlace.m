//
//  GooglePlace.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/1/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "GooglePlace.h"

#import "Constants.h"

#import <OIDServiceConfiguration.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationRequest.h>
#import <OIDTokenResponse.h>
#import <GTMAppAuth.h>
#import <GTMAppAuthFetcherAuthorization.h>
#import <GTMSessionFetcherService.h>

#import "NSString+URLEncoding.h"


@interface GooglePlace ()


@property GMSCoordinateBounds* viewPort;
@property GMSPlacesPriceLevel priceLevel;
@property NSArray* addressComponents;
@property USER_DEFINED_GOOGLE_PLACE_CATEGORY userDefinedCategory;
@property NSMutableArray* images;



@end


@implementation GooglePlace

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize images = _images;
@synthesize formattedAddress = _formattedAddress;
@synthesize addressComponents = _addressComponents;
@synthesize name = _name;
@synthesize openNowStatus = _openNowStatus;
@synthesize priceLevel = _priceLevel;
@synthesize rating = _rating;
@synthesize phoneNumber = _phoneNumber;
@synthesize types = _types;
@synthesize website = _website;
@synthesize viewPort = _viewPort;

NSArray* _reviews;
NSArray* _photoMetadataArray;

NSOperationQueue* _initializationOperationQueue;


-(instancetype)initWithGMSPlace:(NSString*)placeID andWithUserDefinedCategory:(NSNumber*)userDefinedCategory andWithBatchCompletionHandler:(void(^)(void))batchCompletionHandler andCompletionHandler:(void(^)(void))completion{

    self = [super init];
    
    if(self){
        
    
        
        [[GMSPlacesClient sharedClient] lookUpPlaceID:placeID callback:^(GMSPlace*result, NSError*error){
                
                
                
                if(result){
                    self.placeID = placeID;
                    self.userDefinedCategory = (USER_DEFINED_GOOGLE_PLACE_CATEGORY)[userDefinedCategory integerValue];
                    
                    [self initializeFromGMSPlace:result];
                    
                    [self loadPhotoMetaDataWithCompletionHandler:completion andWithBatchCompletionHandler:batchCompletionHandler];
                    
                } else {
                    
                        if(error){
                        
                            NSLog(@"Error occurred while looking up Location via Google PlaceID: %@",[error localizedDescription]);
                            NSLog(@"Reasone for failure: %@",[error localizedFailureReason]);
                        
                        } else {
                            NSLog(@"Error: failed to download Google Place; no results obtain from callback");
                        
                            [self performDefaultInitialization];
                        
                        }
                    
                    
                        }
                }];
            
        
            
        

        
    }
    
    return self;
    
}



-(void)loadPhotoMetaDataWithCompletionHandler:(void(^)(void))completion andWithBatchCompletionHandler:(void(^)(void))batchCompletionHandler{
    
    [[GMSPlacesClient sharedClient] lookUpPhotosForPlaceID:self.placeID callback:^(GMSPlacePhotoMetadataList* photos, NSError* error){
    
        if(photos){
            
            _photoMetadataArray = photos.results;
            
            [self loadPhotosWithCompletionHandler:completion andWithBatchCompletionHandler:batchCompletionHandler];
            
            
        } else {
            if(error){
                NSLog(@"Error: unable to acquire photometadata list: %@",[error description]);
            } else {
                NSLog(@"Unable to retrieve photometadata, photos downloaded with nil result");
            }
        }
    
    }];
    
}

-(void)loadPhotosWithCompletionHandler:(void(^)(void))completion andWithBatchCompletionHandler:(void(^)(void))batchCompletionHandler{
    
    
    if(!_photoMetadataArray){
        return;
    }
    
    if(_images == nil){
        _images = [[NSMutableArray alloc] initWithCapacity:[_photoMetadataArray count]];
    }

    __block int count = 0;
    
    for (GMSPlacePhotoMetadata*photoMetadata in _photoMetadataArray) {
        
        
        [[GMSPlacesClient sharedClient] loadPlacePhoto:photoMetadata callback:^(UIImage* photo, NSError* error){
        
            if(photo){
                
                [_images addObject:photo];
                
                if(batchCompletionHandler){
                    batchCompletionHandler();
                }
                
                if(count >= [_photoMetadataArray count] - 1 && completion){
                    
                    completion();
                }

            } else {
                
                if(error){
                    NSLog(@"Error occurred downloading photos: %@",[error description]);
                } else {
                    NSLog(@"Nil results obtained in downloading photo");

                }
                
            }
        }];
        
        count++;

    }
    
    

}

-(void)showDebugInfo{
    NSLog(@"The openNowStatus is %@, the price level is %@, the coordinate is %f,%f, the name is %@, the title is %@, the web address is %@, the phone number is %@,the formatted address is %@",self.isOpenNowText,self.priceLevelText,self.coordinate.latitude,self.coordinate.longitude,self.name,self.title, [self.website absoluteString], self.phoneNumber,self.formattedAddress);
    
    for(GMSAddressComponent*addressComponent in self.addressComponents){
        NSLog(@"Address component type: %@",addressComponent.type);
        NSLog(@"Address component type: %@",addressComponent.name);

        
        
    }
    
    for (NSString*type in self.types) {
        NSLog(@"Type: %@",type);
    }
    
    NSLog(@"openNowStatus enum is %ld",self.openNowStatus);
    NSLog(@"priceLevel enum is %ld",self.priceLevel);
}

-(void)initializeFromGMSPlace:(GMSPlace*)place{
    
    
    _formattedAddress = place.formattedAddress;
    _addressComponents = place.addressComponents;
    
    _title = place.name;
    _name = place.name;
    _coordinate = place.coordinate;

    
    _openNowStatus = place.openNowStatus;
    _priceLevel = place.priceLevel;
    _rating = place.rating;
    _phoneNumber = place.phoneNumber;
    _types = place.types;
    
    _website = place.website;
    _viewPort = place.viewport;
    


    
}

-(void)showDebugSummary{
    NSLog(@"Google Place has information: Title: %@, Address: %@, Phone Number: %@, Website: %@", self.title,self.formattedAddress,self.phoneNumber,[self.website absoluteString]);
}

-(void) performDefaultInitialization{
    //TODO: perform default initialization
    NSLog(@"Performing default initialization...");
    
}


-(GMSPlacesOpenNowStatus)openNowStatus{
    return _openNowStatus;
}

-(void)setOpenNowStatus:(GMSPlacesOpenNowStatus)openNowStatus{
    _openNowStatus = openNowStatus;
}

-(GMSPlacesPriceLevel)priceLevel{
    return _priceLevel;
}

-(void)setPriceLevel:(GMSPlacesPriceLevel)priceLevel{
    _priceLevel = priceLevel;
}

-(NSArray<NSString *> *)types{
    return _types;
}

-(void)setTypes:(NSArray<NSString *> *)types{
    _types = types;
}

-(NSString *)phoneNumber{
    return _phoneNumber;
}

-(void)setPhoneNumber:(NSString *)phoneNumber{
    _phoneNumber = phoneNumber;
}

-(NSString *)formattedAddress{
    return _formattedAddress;
}

-(void)setFormattedAddress:(NSString *)formattedAddress{
    _formattedAddress = formattedAddress;
}

-(NSURL *)website{
    return _website;
}


-(void)setWebsite:(NSURL *)website{
    _website = website;
}

-(NSString *)priceLevelText{
    switch (self.priceLevel) {
        case kGMSPlacesPriceLevelFree:
            return @"Free";
            break;
        case kGMSPlacesPriceLevelHigh:
            return @"Somewhat Expensive";
        case kGMSPlacesPriceLevelMedium:
            return @"Average";
        case kGMSPlacesPriceLevelCheap:
            return @"Cheap";
        case kGMSPlacesPriceLevelUnknown:
            return @"Unknown";
        case kGMSPlacesPriceLevelExpensive:
            return @"Expensive";
        default:
            break;
    }
}

-(NSString*)isOpenNowText{
    
    switch (self.openNowStatus) {
        case kGMSPlacesOpenNowStatusUnknown:
            return @"Unknown";
            break;
        case kGMSPlacesOpenNowStatusNo:
            return @"Closed";
        case kGMSPlacesOpenNowStatusYes:
            return @"Open";
        default:
            return @"Unknown";
    }
   

}

-(MKCoordinateRegion)coordinateRegion{
    
    if(MKMapRectIsNull(self.boundingMapRect) || MKMapRectIsEmpty(self.boundingMapRect)){
        
        return MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(0.001, 0.001));
    }
    
    return MKCoordinateRegionForMapRect(self.boundingMapRect);
    
}

-(MKMapRect)boundingMapRect{
    
    CLLocationCoordinate2D southWestCoord = self.viewPort.southWest;
    CLLocationCoordinate2D northEastCoord = self.viewPort.northEast;
    
    double height = northEastCoord.latitude - southWestCoord.latitude;
    double width = fabs(northEastCoord.longitude - southWestCoord.longitude);
    
    return MKMapRectMake(southWestCoord.longitude, southWestCoord.latitude, width, height);
}

-(CLLocationCoordinate2D)coordinate{
    return _coordinate;
}


-(NSString *)title{
    return _title;
}



-(NSString *)subtitle{
    return _subtitle;
}

-(NSString *)name{
    return _name;
}

-(void)setName:(NSString *)name{
    _name = name;
}


-(void)setImages:(NSMutableArray *)images{
    _images = images;
}

-(NSMutableArray *)images{
   
    return _images;
}

-(void)loadGooglePlaceDetailData{
    
    NSLog(@"Preparing to make API request..");
    
    GTMAppAuthFetcherAuthorization* fromKeychainAuthorization =
    [GTMAppAuthFetcherAuthorization authorizationFromKeychainForName:kGTMAppAuthAuthorizerKey];
    
    GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
    fetcherService.authorizer = fromKeychainAuthorization;
    
    /** Convert the captured image into a base64encoded string which can be submitted via the HTTP body to Google Servers **/
    
    
    
    NSString* baseURLString = GOOGLE_PLACES_BASE_URL_ENDPOINT;
    
    NSString* placeID_queryParameter = [NSString stringWithFormat:@"placeid=%@",self.placeID];

    baseURLString = [baseURLString stringByAppendingString:placeID_queryParameter];
    
    
    BOOL shouldAppendAPIKey = true;
    
    if(shouldAppendAPIKey){
        
        NSString* apiKey_queryParameter = [NSString stringWithFormat:@"&key=%@",GOOGLE_API_KEY];
        
        baseURLString = [baseURLString stringByAppendingString:apiKey_queryParameter];

    }
    
    
  //NSString* encodedURLString = [baseURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    
    NSURL* url = [NSURL URLWithString:baseURLString];
    

    // Creates a fetcher for the API call.
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    /** Set the HTTP Method as POST **/
    
    [request setHTTPMethod:@"GET"];
    
    /** Set Content-Type Header to 'application/json' **/
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    /** Set the access key as the value for 'authorizaiton' in a separate authorization header **/
    NSString* authValue = [NSString stringWithFormat:@"Bearer %@",fromKeychainAuthorization.authState.lastTokenResponse.accessToken];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    /** Initialize fetcher object with an NSURL request **/
    
    
    GTMSessionFetcher *fetcher = [fetcherService fetcherWithRequest:request];
    
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        // Checks for an error.
        
        
        
        // Parses the JSON response.
        NSError *jsonError = nil;
        
        if(data){
            NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            // JSON error.
            if (jsonError) {
                NSLog(@"JSON decoding error %@", jsonError);
                return;
            }
            
            
            // Success response!
            NSLog(@"Success: %@", jsonDict);
        } else {
            
            if(error){
               
                NSLog(@"Error description: %@",[error description]);
                NSLog(@"Error localized description: %@",[error localizedDescription]);
                NSLog(@"Failure reason: %@",[error localizedFailureReason]);
            } else {
                NSLog(@"Failed to download JSON dict");

            }
            
            
           
        }
        
        
    }];
    
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingFirstImage{
    return [NSSet setWithObject:@"images"];
}

-(UIImage *)firstImage{
    if(_images){
        return [_images firstObject];
    }
    
    return nil;
}

-(CLLocation *)location{
    
    return [[CLLocation alloc] initWithLatitude:_coordinate.latitude longitude:_coordinate.longitude];
    
    
}

@end
