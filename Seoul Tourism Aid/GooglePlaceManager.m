//
//  GooglePlaceManager.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "GooglePlaceManager.h"
#import "GooglePlace.h"
#import "TouristSiteConfiguration.h"

@interface GooglePlaceManager ()

@property NSMutableArray<GooglePlace*>* museums;
@property NSMutableArray<GooglePlace*>* temples;
@property NSMutableArray<GooglePlace*>* parks;
@property NSMutableArray<GooglePlace*>* shoppingCenters;
@property NSMutableArray<GooglePlace*>* naturalSites;
@property NSMutableArray<GooglePlace*>* monumentsAndCulturalSites;
@property NSMutableArray<GooglePlace*>* yangguCountySites;
@property NSMutableArray<GooglePlace*>* namsanTowerSites;
@property NSMutableArray<GooglePlace*>* otherSites;




@end

@implementation GooglePlaceManager


+(GooglePlaceManager *)sharedManager{
    static GooglePlaceManager* _sharedManager = nil;

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
                  
        _sharedManager = [[GooglePlaceManager alloc] init];
    });
    
    return _sharedManager;
}


-(instancetype)init{
    
    self = [super init];
    
    if(self){
        
        
        
    }
    
    return self;
}

-(GooglePlace*)getGooglePlaceForIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"Getting google place for index path...");
    
    USER_DEFINED_GOOGLE_PLACE_CATEGORY placeCategory = (USER_DEFINED_GOOGLE_PLACE_CATEGORY)indexPath.section;
    
    NSLog(@"Place category is %d...",placeCategory);

    
    switch (placeCategory) {
        case Museum:
            if(_museums && _museums.count > 0){
                return [_museums objectAtIndex:indexPath.row];
            }
        case Temple:
            if(_temples && _temples.count > 0){
                return [_temples objectAtIndex:indexPath.row];
            }
        case SeoulTower:
            if(_namsanTowerSites && _namsanTowerSites.count > 0){
                return [_namsanTowerSites objectAtIndex:indexPath.row];
            }
        case ShoppingArea:
            if(_shoppingCenters && _shoppingCenters.count > 0){
                return [_shoppingCenters objectAtIndex:indexPath.row];
            }
        case Outdoor_NaturalSite:
            if(_naturalSites && _naturalSites.count > 0){
                return [_naturalSites objectAtIndex:indexPath.row];
            }
        case Other:
            if(_otherSites && _otherSites.count > 0){
                return [_otherSites objectAtIndex:indexPath.row];
            }
        case YangguCounty:
            if(_yangguCountySites && _yangguCountySites.count > 0){
                return [_yangguCountySites objectAtIndex:indexPath.row];
            }
        case Park_RecreationSite:
            if(_parks && _parks.count > 0){
                return [_parks objectAtIndex:indexPath.row];
            }
        case Monument_HistoricalCulturalSite:
            if(_monumentsAndCulturalSites && _monumentsAndCulturalSites.count > 0){

                return [_monumentsAndCulturalSites objectAtIndex:indexPath.row];
            }
        default:
            break;
    }

    return nil;
}


-(GooglePlace*)getGooglePlaceForPlaceCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory andForRow:(NSInteger)row{
    
    NSLog(@"Getting google place for index path...");
    
    
    NSLog(@"Place category is %d...",placeCategory);
    
    
    switch (placeCategory) {
        case Museum:
            if(_museums && _museums.count > 0){
                return [_museums objectAtIndex:row];
            }
        case Temple:
            if(_temples && _temples.count > 0){
                return [_temples objectAtIndex:row];
            }
        case SeoulTower:
            if(_namsanTowerSites && _namsanTowerSites.count > 0){
                return [_namsanTowerSites objectAtIndex:row];
            }
        case ShoppingArea:
            if(_shoppingCenters && _shoppingCenters.count > 0){
                return [_shoppingCenters objectAtIndex:row];
            }
        case Outdoor_NaturalSite:
            if(_naturalSites && _naturalSites.count > 0){
                return [_naturalSites objectAtIndex:row];
            }
        case Other:
            if(_otherSites && _otherSites.count > 0){
                return [_otherSites objectAtIndex:row];
            }
        case YangguCounty:
            if(_yangguCountySites && _yangguCountySites.count > 0){
                return [_yangguCountySites objectAtIndex:row];
            }
        case Park_RecreationSite:
            if(_parks && _parks.count > 0){
                return [_parks objectAtIndex:row];
            }
        case Monument_HistoricalCulturalSite:
            if(_monumentsAndCulturalSites && _monumentsAndCulturalSites.count > 0){
                
                return [_monumentsAndCulturalSites objectAtIndex:row];
            }
        default:
            break;
    }
    
    return nil;
}


-(NSInteger)getNumberOfPlacesForCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory{
    switch (placeCategory) {
        case Museum:
            if(_museums && _museums.count > 0){
                return [_museums count];
            }
        case Temple:
            if(_temples && _temples.count > 0){
                return [_temples count];
            }
        case SeoulTower:
            if(_namsanTowerSites && _namsanTowerSites.count > 0){
                return [_namsanTowerSites count];
            }
        case ShoppingArea:
            if(_shoppingCenters && _shoppingCenters.count > 0){
                return [_shoppingCenters count];
            }
        case Outdoor_NaturalSite:
            if(_naturalSites && _naturalSites.count > 0){
                return [_naturalSites count];
            }
        case Other:
            if(_otherSites && _otherSites.count > 0){
                return [_otherSites count];
            }
        case YangguCounty:
            if(_yangguCountySites && _yangguCountySites.count > 0){
                return [_yangguCountySites count];
            }
        case Park_RecreationSite:
            if(_parks && _parks.count > 0){
                return [_parks count];
            }
        case Monument_HistoricalCulturalSite:
            if(_monumentsAndCulturalSites && _monumentsAndCulturalSites.count > 0){
                return [_monumentsAndCulturalSites count];
            }
        default:
            break;
    }
    
    return 0;
}


-(void)loadCategoryArrayWithUserDefinedCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)placeCategory andWithSinglePlaceItemCompletionHandler:(void(^)(void))completionHandler{
    
    [self initializeArrayForCategory:placeCategory];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
    
    NSArray* regionsDictArray = [NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary*dict in regionsDictArray){
        
        USER_DEFINED_GOOGLE_PLACE_CATEGORY category = (USER_DEFINED_GOOGLE_PLACE_CATEGORY)[dict[@"category"] integerValue];
        NSString* placeID = dict[@"placeID"];
        
        if(!placeID){
            return;
        }
        

        if(category == placeCategory){
            
            GooglePlace* googlePlace = [[GooglePlace alloc] initWithGMSPlace:placeID andWithUserDefinedCategory:[NSNumber numberWithInt:category] andWithBatchCompletionHandler:nil andCompletionHandler:completionHandler];

            [self addGooglePlace:googlePlace forCategory:category];
           
            
        }
    }

    
}

-(void)addGooglePlace:(GooglePlace*)googlePlace forCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)category{
    
    switch (category) {
        case Museum:
            [_museums addObject:googlePlace];
            break;
        case Temple:
            [_temples addObject:googlePlace];
            break;
        case SeoulTower:
            [_namsanTowerSites addObject:googlePlace];
            break;
        case ShoppingArea:
            [_shoppingCenters addObject:googlePlace];
            break;
        case Outdoor_NaturalSite:
            [_naturalSites addObject:googlePlace];
            break;
        case Other:
            [_otherSites addObject:googlePlace];
            break;
        case YangguCounty:
            [_yangguCountySites addObject:googlePlace];
            break;
        case Park_RecreationSite:
            [_parks addObject:googlePlace];
            break;
        case Monument_HistoricalCulturalSite:
            [_monumentsAndCulturalSites addObject:googlePlace];
            break;
        default:
            break;
    }

}

-(void)initializeArrayForCategory:(USER_DEFINED_GOOGLE_PLACE_CATEGORY)category{
        
    switch (category) {
        case Museum:
            _museums = [[NSMutableArray alloc] init];
            break;
        case Temple:
            _temples = [[NSMutableArray alloc] init];
            break;
        case SeoulTower:
            _namsanTowerSites = [[NSMutableArray alloc] init];
            break;
        case ShoppingArea:
            _shoppingCenters = [[NSMutableArray alloc] init];
            break;
        case Outdoor_NaturalSite:
            _naturalSites = [[NSMutableArray alloc] init];
            break;
        case Other:
            _otherSites = [[NSMutableArray alloc] init];
            break;
        case YangguCounty:
            _yangguCountySites = [[NSMutableArray alloc] init];
            break;
        case Park_RecreationSite:
            _parks = [[NSMutableArray alloc] init];
            break;
        case Monument_HistoricalCulturalSite:
            _monumentsAndCulturalSites = [[NSMutableArray alloc] init];
            break;
        default:
            break;
    }
}


-(void)loadGooglePlaceCategoryArrays{
    
    _museums = [[NSMutableArray alloc] init];
    _temples = [[NSMutableArray alloc] init];
    _parks = [[NSMutableArray alloc] init];
    _shoppingCenters = [[NSMutableArray alloc] init];
    _naturalSites = [[NSMutableArray alloc] init];
    _monumentsAndCulturalSites = [[NSMutableArray alloc] init];
    _yangguCountySites = [[NSMutableArray alloc] init];
    _namsanTowerSites = [[NSMutableArray alloc] init];
    _otherSites = [[NSMutableArray alloc] init];
    
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"RegionIdentifiers" ofType:@"plist"];
    
    NSArray* regionsDictArray = [NSArray arrayWithContentsOfFile:path];
    
    for(NSDictionary*dict in regionsDictArray){
        
        USER_DEFINED_GOOGLE_PLACE_CATEGORY category = (USER_DEFINED_GOOGLE_PLACE_CATEGORY)[dict[@"category"] integerValue];
        NSString* placeID = dict[@"placeID"];
        
        if(!placeID){
            return;
        }
        
        GooglePlace* googlePlace = [[GooglePlace alloc] initWithGMSPlace:placeID andWithUserDefinedCategory:[NSNumber numberWithInt:category] andWithBatchCompletionHandler:nil andCompletionHandler:nil];
        
        switch (category) {
            case Museum:
                [self.museums addObject:googlePlace];
                break;
            case Monument_HistoricalCulturalSite:
                [self.monumentsAndCulturalSites addObject:googlePlace];
                break;
            case Outdoor_NaturalSite:
                [self.naturalSites addObject:googlePlace];
                break;
            case Other:
                [self.otherSites addObject:googlePlace];
                break;
            case Park_RecreationSite:
                [self.parks addObject:googlePlace];
                break;
            case SeoulTower:
                [self.namsanTowerSites addObject:googlePlace];
                break;
            case ShoppingArea:
                [self.shoppingCenters addObject:googlePlace];
                break;
            case YangguCounty:
                [self.yangguCountySites addObject:googlePlace];
                break;
            case Temple:
                [self.temples addObject:googlePlace];
                break;
            default:
                break;
        }
        
    }

}


-(void) purgeAllCategoryArrays{
    self.museums = nil;
    self.temples = nil;
    self.parks = nil;
    self.shoppingCenters = nil;
    self.naturalSites = nil;
    self.monumentsAndCulturalSites = nil;
    self.yangguCountySites = nil;
    self.namsanTowerSites = nil;
    self.otherSites = nil;
    

}

-(void)showDebugInfoForMuseums{
    NSLog(@"The museums have loaded with the following information: ");
    
    for(GooglePlace*museum in self.museums){
        [museum showDebugSummary];
    }

}

-(void)showDebugInfoForParks{
    NSLog(@"The parks have loaded with the following information: ");
    
    for(GooglePlace*park in self.parks){
        [park showDebugSummary];
    }
    
}

-(void)showDebugInfoForTemples{
    NSLog(@"The temples have loaded with the following information: ");
    
    for(GooglePlace*temple in self.temples){
        [temple showDebugSummary];
    }
    
}

-(void) showDebugInfoForNaturalSites{
    NSLog(@"The natural sites have loaded with the following information: ");
    
    for(GooglePlace*naturalSite in self.naturalSites){
        [naturalSite showDebugSummary];
    }
}

-(void)showDebugInfoForOtherSites{
    NSLog(@"The other tourist sites have loaded with the following information: ");

    for(GooglePlace*other in self.otherSites){
        [other showDebugSummary];
    }
}

-(void)showDebugInfoForMonuments{
    NSLog(@"The monuments and cultural sites have loaded with the following information: ");
    
    for(GooglePlace*monument in self.monumentsAndCulturalSites){
        [monument showDebugSummary];
    }
}

-(void)showDebugInfoForNamsanSites{
    NSLog(@"The Namsan Tower sites have loaded with the following information: ");
    
    for(GooglePlace*namsanSite in self.namsanTowerSites){
        [namsanSite showDebugSummary];
    }
}

-(void)showDebugInforForYangguSites{
    NSLog(@"The Yanggu County sites have loaded with the following information: ");
    
    for(GooglePlace*yangguCountySite in self.yangguCountySites){
        [yangguCountySite showDebugSummary];
    }
}

-(void)showDebugInfoForShoppingCenters{
    NSLog(@"The Shopping Areas have loaded with the following information: ");
    
    for(GooglePlace*shoppingCenter in self.shoppingCenters){
        [shoppingCenter showDebugSummary];
    }

}

-(void)showDebugInfoForCategoryArrays{
    
    [self showDebugInfoForMuseums];
    
    [self showDebugInfoForParks];
    
    [self showDebugInfoForTemples];
   
    [self showDebugInfoForOtherSites];
    
    [self showDebugInfoForMonuments];
    
    [self showDebugInfoForNaturalSites];
    
    [self showDebugInforForYangguSites];
    
    [self showDebugInfoForNamsanSites];
    
    [self showDebugInfoForShoppingCenters];
    
}

@end
