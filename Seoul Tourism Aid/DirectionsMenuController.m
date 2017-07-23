//
//  DirectionsMenuController.m
//  MapoHostelBasic
//
//  Created by Aleksander Makedonski on 6/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionsMenuController.h"
#import "LocationSearchController.h"
#import "ToHostelDirectionsController.h"
//#import "TouristLocationTableViewController.h"
#import "UserLocationManager.h"
#import "MKDirectionsRequest+HelperMethods.h"
#import "WarMemorialNavigationController.h"
#import "DestinationCategory.h"
#import "NavigationAidEntryController.h"
//#import "HostelAreaNavigationController.h"
//#import "TouristLocationTBNavigationController.h"
#import "CloudKitHelper.h"

/**
#import "TouristLocationSelectionNavigationController.h"
#import "TouristLocationTableViewController.h"
#import "HostelLocalAreaMapController.h"
**/

@interface DirectionsMenuController ()


typedef enum NAVIGATION_AID_AREA{
    WAR_MEMORIAL_NAV_AREA,
    WORLD_CUP_STADIUM_NAV_AREA,
    SEOUL_TOWER_NAV_AREA,
    SEOUL_GRAND_PARK_AREA,
    NAVIGATION_AID_AREA_END_INDEX
}NAVIGATION_AID_AREA;

typedef enum ANNOTATION_LOCAL_AREA{
    MAPOGU,
    ITAEWON,
    INSADONG
}ANNOTATION_LOCAL_AREA;

typedef enum VALID_NEXT_VIEW_CONTROLLER{
    MAPOGU_LOCATION_TABLEVIEW_CONTROLLER = 0,
    ITAEWON_LOCATION_TABLEVIEW_CONTROLLER,
    INSADONG_LOCATION_TABLEVIEW_CONTROLLER,
    LOCATION_SEARCH_CONTROLLER,
    TO_AIRPORT_DIRECTIONS_CONTROLLER,
    TO_SEOUL_STATION_DIRECTIONS_CONTROLLER,
    MAPOGU_LOCAL_AREA_MAPVIEW,
    ITAEWON_LOCAL_AREA_MAPVIEW,
    INSADONG_LOCAL_AREA_MAPVIEW,
    BIKING_JOGGING_ROUTE_CONTROLLER,
    POLYGON_NAVIGATION_CONTROLLER,
    NAVIGATION_AID_CONTROLLER_WAR_MEMORIAL,
    NAVIGATION_AID_CONTROLLER_WORLD_CUP_STADIUM,
    NAVIGATION_AID_CONTROLLER_SEOUL_TOWER,
    NAVIGATION_AID_CONTROLLER_SEOUL_GRAND_PARK,
    LAST_VIEW_CONTROLLER,
}VALID_NEXT_VIEW_CONTROLLER;

@property (weak, nonatomic) IBOutlet UIImageView *selectionBarImage;
@property (readonly) CGFloat titleFontSize;
@property VALID_NEXT_VIEW_CONTROLLER currentNextViewController;

- (IBAction)dismissViewController:(id)sender;

- (IBAction)showSelectedViewController:(UIButton *)sender;


- (IBAction)unwindToDirectionsMenuController:(UIStoryboardSegue *)unwindSegue;

@end

@implementation DirectionsMenuController

@synthesize titleFontSize = _titleFontSize;

-(void)viewWillLayoutSubviews{
    
    [self.pickerControl setDelegate:self];
    [self.pickerControl setDataSource:self];
    
    UserLocationManager* sharedLocationManager = [UserLocationManager sharedLocationManager];
    
    [sharedLocationManager requestAuthorizationAndStartUpdates];

    
}



-(void)viewDidLoad{
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    
    NSLog(@"The last updated user location is at lat: %f, long: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude)
    ;
    
}

#pragma mark UIPICKER VIEW DELEGATE AND DATASOURCE METHODS

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    CGFloat componentWidth = self.selectionBarImage.bounds.size.width;
    
    return componentWidth;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    CGFloat rowHeight = self.selectionBarImage.bounds.size.height;
    
    return rowHeight;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return LAST_VIEW_CONTROLLER;
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.currentNextViewController = (int)row;
}



-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    CGRect viewFrame = CGRectInset(self.selectionBarImage.frame, 1.0, 1.0);
    UILabel* label = [[UILabel alloc] initWithFrame:viewFrame];
    
    [label setNumberOfLines:0];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    NSString* mainText = [self getNextViewControllerTitleFor:(int)row];
    
    UIFont* primaryFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:[self titleFontSize]];
    
    NSDictionary* stringAttributesDict = [NSDictionary dictionaryWithObjectsAndKeys:primaryFont,NSFontAttributeName, nil];
    
    NSMutableAttributedString* mainAttributedString = [[NSMutableAttributedString alloc] initWithString:mainText attributes:stringAttributesDict];
    
    label.attributedText = mainAttributedString;
    
    return label;
    
}


-(CGFloat)titleFontSize{
    
    if(!_titleFontSize){
    
        UITraitCollection *currentTraitCollection = [self traitCollection];
        UIUserInterfaceSizeClass horizontalSC = [currentTraitCollection horizontalSizeClass];
        UIUserInterfaceSizeClass verticalSC = [currentTraitCollection verticalSizeClass];
    
        BOOL CW_CH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassCompact);
    
        BOOL CW_RH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassRegular);
    
        BOOL RW_CH = (horizontalSC == UIUserInterfaceSizeClassRegular && verticalSC == UIUserInterfaceSizeClassCompact);
    
        BOOL RW_RH = (horizontalSC == UIUserInterfaceSizeClassRegular && verticalSC == UIUserInterfaceSizeClassRegular);
    
        _titleFontSize = 30.0;
        
        if(CW_CH){
            return 30.0;
        }
    
        if(CW_RH){
            return 30.0;
        }
    
        if(RW_CH){
            return 50.0;
        
        }
    
        if(RW_RH){
            return 50.0;
        }
    
    
    }
    
    return _titleFontSize;
}

- (IBAction)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSelectedViewController:(UIButton *)sender {
    
    UIViewController* nextViewController;
    
    
    
    switch (self.currentNextViewController) {
            /**
        case MAPOGU_LOCATION_TABLEVIEW_CONTROLLER:
            nextViewController = [self getNavigationControllerForTouristLocationTableViewControllerWith:MAPOGU];
            break;
        case ITAEWON_LOCATION_TABLEVIEW_CONTROLLER:
            nextViewController = [self getNavigationControllerForTouristLocationTableViewControllerWith:ITAEWON];
            break;
        case INSADONG_LOCATION_TABLEVIEW_CONTROLLER:
            nextViewController = [self getNavigationControllerForTouristLocationTableViewControllerWith:INSADONG];
            break;
             **/
        case LOCATION_SEARCH_CONTROLLER:
            nextViewController = [self getLocationSearchController];
            break;
            /**
        case MAPOGU_LOCAL_AREA_MAPVIEW:
            nextViewController = [self getLocalAreaAnnotationController:MAPOGU];
            break;
        case ITAEWON_LOCAL_AREA_MAPVIEW:
            nextViewController = [self getLocalAreaAnnotationController:ITAEWON];
            break;
        case INSADONG_LOCAL_AREA_MAPVIEW:
            nextViewController = [self getLocalAreaAnnotationController:INSADONG];
            break;
            **/
            
        case BIKING_JOGGING_ROUTE_CONTROLLER:
            nextViewController = [self getBikeRouteNavigationController];
            break;
        case POLYGON_NAVIGATION_CONTROLLER:
            nextViewController = [self getPolygonNavigationController];
            break;
        case NAVIGATION_AID_CONTROLLER_WAR_MEMORIAL:
            nextViewController = [self getNavigationAidControllerForArea:WAR_MEMORIAL_NAV_AREA];
            break;
        case NAVIGATION_AID_CONTROLLER_SEOUL_TOWER:
            nextViewController = [self getNavigationAidControllerForArea:SEOUL_TOWER_NAV_AREA];
            break;
        case NAVIGATION_AID_CONTROLLER_WORLD_CUP_STADIUM:
            nextViewController = [self getNavigationAidControllerForArea:WORLD_CUP_STADIUM_NAV_AREA];
            break;
        case NAVIGATION_AID_CONTROLLER_SEOUL_GRAND_PARK:
            nextViewController = [self getNavigationAidControllerForArea:SEOUL_GRAND_PARK_AREA];
            break;
        case TO_AIRPORT_DIRECTIONS_CONTROLLER:
            nextViewController = [self getToAirportDirectionsController];
            break;
        case TO_SEOUL_STATION_DIRECTIONS_CONTROLLER:
            nextViewController = [self getToSeoulStationDirectionsController];
            break;
        default:
            break;
    }

    
    [self showViewController:nextViewController sender:nil];
}


/**
- (UINavigationController*) getLocalAreaAnnotationController:(ANNOTATION_LOCAL_AREA)annotationLocalArea{
    
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
     HostelAreaNavigationController* nextViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HostelAreaNavigationController"];
    
    [self configureHostelAreaAnnotationControllerForViewController:nextViewController andForAnnotationArea:annotationLocalArea];
    
    return nextViewController;
}

**/

/**
-(void) configureHostelAreaAnnotationControllerForViewController:(HostelAreaNavigationController*)nextViewController andForAnnotationArea:(ANNOTATION_LOCAL_AREA)annotationLocalArea{
    
    switch (annotationLocalArea) {
        case MAPOGU:
            nextViewController.annotationSourceFilePath = @"PlacemarksNearHostel";
            nextViewController.mapRegion = [self getMapoguMapRegion];
            break;
        case ITAEWON:
            break;
        case INSADONG:
            break;
        default:
            break;
    }
    
}
**/

-(MKCoordinateRegion) getMapoguMapRegion{
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.5416277, 126.9507303), span);
    
}

/**
- (UINavigationController*) getNavigationControllerForTouristLocationTableViewControllerWith:(ANNOTATION_LOCAL_AREA)annotationArea{
    
   
    UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
    
    NSString* storyboardIdentifier = @"TouristLocationTableViewNavigationController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"TouristLocationTableViewNavigationController_iPad";
        
    }
    
    TouristLocationTBNavigationController* nextViewController = [storyboardB instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    [self configureTouristLocationTableViewControllerFor:nextViewController andFor:annotationArea];
    
    return nextViewController;

}


-(void)configureTouristLocationTableViewControllerFor:(TouristLocationTBNavigationController*)nextViewController andFor:(ANNOTATION_LOCAL_AREA)annotationLocalArea{
    
    switch (annotationLocalArea) {
        case MAPOGU:
            nextViewController.annotationFilePath = @"PlacemarksNearHostel";
            break;
        case ITAEWON:
            break;
        case INSADONG:
            break;
        default:
            break;
    }
}

**/

 -(NSString*)getNextViewControllerTitleFor:(VALID_NEXT_VIEW_CONTROLLER)validNextViewController{
    
    switch (validNextViewController) {
        case MAPOGU_LOCATION_TABLEVIEW_CONTROLLER:
            return @"Mapo-gu (Recommended Locations)";
        case ITAEWON_LOCATION_TABLEVIEW_CONTROLLER:
            return @"Itaewon (Recommended Locations)";
        case INSADONG_LOCATION_TABLEVIEW_CONTROLLER:
            return @"Insadong (Recommended Locations)";
        case LOCATION_SEARCH_CONTROLLER:
            return @"Search for Locations Nearby";
        case MAPOGU_LOCAL_AREA_MAPVIEW:
            return @"View the Mapo-gu Area";
        case ITAEWON_LOCAL_AREA_MAPVIEW:
            return @"View the Itaewon Area";
        case INSADONG_LOCAL_AREA_MAPVIEW:
            return @"View the Insadong Area";
        case BIKING_JOGGING_ROUTE_CONTROLLER:
            return @"Sight-Seeing Routes";
        case POLYGON_NAVIGATION_CONTROLLER:
            return @"Local Building, Park, and Site Regions";
        case NAVIGATION_AID_CONTROLLER_WAR_MEMORIAL:
            return @"War Memorial Navigation Aid";
        case NAVIGATION_AID_CONTROLLER_WORLD_CUP_STADIUM:
            return @"World Cup Stadium Navigation Aid";
        case NAVIGATION_AID_CONTROLLER_SEOUL_TOWER:
            return @"Seoul Tower Navigation Aid";
        case NAVIGATION_AID_CONTROLLER_SEOUL_GRAND_PARK:
            return @"Seoul Grand Park Zoo Navigation Aid";
        case TO_SEOUL_STATION_DIRECTIONS_CONTROLLER:
            return @"Directions to Seoul Station";
        case TO_AIRPORT_DIRECTIONS_CONTROLLER:
            return @"Directions to Incheon Airport";
        case LAST_VIEW_CONTROLLER:
            return nil;
    }
    
    return nil;
}



-(NavigationAidEntryController*) getNavigationAidControllerForArea:(NAVIGATION_AID_AREA)navigationAidArea{
    
    
    
    UIStoryboard* storyboardB = [UIStoryboard storyboardWithName:@"StoryboardB" bundle:nil];
    
    NSString* storyboardIdentifier = @"WarMemorialNavigationController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"WarMemorialNavigationController_iPad";
        
    }
    
    NavigationAidEntryController* nextViewController = [storyboardB instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    [self configureNavigationAidController:nextViewController andForNavigationAidArea:navigationAidArea];
    
    return nextViewController;
}




-(void) configureNavigationAidController:(NavigationAidEntryController*)nextViewController andForNavigationAidArea:(NAVIGATION_AID_AREA)navigationAidArea{
    
    
    switch (navigationAidArea) {
        case WAR_MEMORIAL_NAV_AREA:
            [self configureNavigationAidControlllerForKoreanWarMemorialSettings:nextViewController];
            break;
        case WORLD_CUP_STADIUM_NAV_AREA:
            [self configureNavigationAidControllerForWorldCupParkSettings:nextViewController];
            break;
        case SEOUL_TOWER_NAV_AREA:
            break;
        case SEOUL_GRAND_PARK_AREA:
            
            [self configureNavigationAidControllerForSeoulGrandParkSettings:nextViewController];
        
            break;
        default:
            break;
    }
    
}





-(LocationSearchController*)getLocationSearchController{
    
    
    
    UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    NSString* storyboardIdentifier = @"LocationSearchController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"LocationSearchController_iPad";
        
    }
    
    LocationSearchController* nextViewController = [storyBoardA instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    return nextViewController;

}



-(ToHostelDirectionsController*)getToAirportDirectionsController{
    
    MKDirectionsResponse* directionsResponse = [MKDirectionsRequest getDirectionsResponseForIncheonInternationalAirportDirectionsRequestForTransportationMode:TRANSIT];
    
    
    UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    NSString* storyboardIdentifier = @"ToHostelDirectionsController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"ToHostelDirectionsController_iPad";
        
    }
    
    ToHostelDirectionsController* nextViewController = [storyBoardA instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    
    
    [nextViewController.titleLabel setAttributedText:[self getAttributedTitleForToDestinationControllerWithString:@"Directions to Airport"]];
    
    nextViewController.destinationCategory = INCHEON_AIRPORT;
    
    nextViewController.directionsResponse = directionsResponse;
    
    return nextViewController;

}



-(ToHostelDirectionsController*)getToSeoulStationDirectionsController{
    
    MKDirectionsResponse* directionsResponse = [MKDirectionsRequest getDirectionsResponseForSeoulStationDirectionsRequestForTransportationMode:TRANSIT];
    
    
    UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    NSString* storyboardIdentifier = @"ToHostelDirectionsController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"ToHostelDirectionsController_iPad";
        
    }
    
    ToHostelDirectionsController* nextViewController = [storyBoardA instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    [nextViewController.titleLabel setAttributedText:[self getAttributedTitleForToDestinationControllerWithString:@"Directions to Seoul Station"]];
    
    
    nextViewController.destinationCategory = SEOUL_STATION;
    
    nextViewController.directionsResponse = directionsResponse;
    
    return nextViewController;
}


/**
-(ToHostelDirectionsController*)getToHostelDirectionsController{
    
    MKDirectionsResponse* directionsResponse = [MKDirectionsRequest getDirectionsResponseForHostelDirectionsRequestForTransportationMode:WALK];
    
   
    UIStoryboard* storyBoardA = [UIStoryboard storyboardWithName:@"StoryboardA" bundle:nil];
    
    NSString* storyboardIdentifier = @"ToHostelDirectionsController";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        storyboardIdentifier = @"ToHostelDirectionsController_iPad";
        
    }
    
    ToHostelDirectionsController* nextViewController = [storyBoardA instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    nextViewController.directionsResponse = directionsResponse;
    
    return nextViewController;
    
    
}
**/

/** Helper method for configuring the title label for the "To Destination" (e.g. To Hostel, To Aiprot, To Seoul Station) Controlller  **/

-(NSAttributedString*)getAttributedTitleForToDestinationControllerWithString:(NSString*)string{

    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Bold" size:30.0],NSFontAttributeName,[UIColor blueColor],NSForegroundColorAttributeName, nil];

    NSAttributedString* attributedTitle = [[NSAttributedString alloc]initWithString:string attributes:attributesDict];
    
    
    return attributedTitle;
}

- (IBAction)unwindToDirectionsMenuController:(UIStoryboardSegue *)unwindSegue
{
}


-(void) configureNavigationAidControllerForWorldCupParkSettings:(NavigationAidEntryController*)nextViewController{
    
    nextViewController.navigationRegionName = @"WorldCupStadium";
    nextViewController.annotationsFileSource = @"";
    nextViewController.annotationViewImagePath = @"streetStandA";
    nextViewController.polygonOverlayFileSources = [NSArray arrayWithObjects:@"",@"", nil];
    nextViewController.mapCoordinateRegion = [self getWorldCupStadiumMapRegion];
    
}


-(MKCoordinateRegion)getWorldCupStadiumMapRegion{
    
    CLLocationCoordinate2D lowerRight = CLLocationCoordinate2DMake(37.5665962,126.8971703);
    CLLocationCoordinate2D upperRight = CLLocationCoordinate2DMake(37.5696912,126.8972773);
    CLLocationCoordinate2D upperLeft = CLLocationCoordinate2DMake(37.5698362,126.8933823);
    
    CLLocationCoordinate2D warMemorialMainEntrance = CLLocationCoordinate2DMake(37.568263,126.8950887);
    
    CLLocationDegrees latDifference = fabs(upperRight.latitude - lowerRight.latitude);
    CLLocationDegrees longDifference = fabs(upperRight.longitude - upperLeft.longitude);
    
    MKCoordinateSpan warMemorialSpan = MKCoordinateSpanMake(latDifference, longDifference);
    MKCoordinateRegion warMemorialRegion = MKCoordinateRegionMake(warMemorialMainEntrance, warMemorialSpan);
    
    return warMemorialRegion;
}


#pragma mark  ****** HELPER FUNCTION FOR GETTING BIKE ROUTE NAVIGATION CONTROLLER

-(UIViewController*) getBikeRouteNavigationController{
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];
    
    return [storyboardD instantiateViewControllerWithIdentifier:@"BikeRouteNavigationController"];

}

#pragma mark HELPER FUNCTION FOR GETTING POLYGON NAVIGATION CONTROLLER

-(UIViewController*)getPolygonNavigationController{
    
    UIStoryboard* storyboardD = [UIStoryboard storyboardWithName:@"StoryboardD" bundle:nil];

    return [storyboardD instantiateViewControllerWithIdentifier:@"PolygonNavigationController"];

}


#pragma mark ******* HELPER FUNCTIONS FOR CONFIGURING KOREAN WAR MEMORIAL NAVIGATION AID

-(void) configureNavigationAidControlllerForKoreanWarMemorialSettings: (NavigationAidEntryController*)nextViewController{
    
    nextViewController.navigationRegionName = @"KoreanWarMemorial";
    nextViewController.annotationsFileSource = @"KoreanWarMemorialCircleRegions";
    nextViewController.annotationViewImagePath = @"tankA";
    nextViewController.polygonOverlayFileSources = [NSArray arrayWithObjects:@"WarMemorialMainBuilding",@"WeddingHall", nil];
    nextViewController.mapCoordinateRegion = [self getWarMemorialMapRegion];
    
}


-(MKCoordinateRegion)getWarMemorialMapRegion{
    
    CLLocationCoordinate2D lowerRight = CLLocationCoordinate2DMake(37.5348, 126.9788);
    CLLocationCoordinate2D upperRight = CLLocationCoordinate2DMake(37.5380, 126.9788);
    CLLocationCoordinate2D upperLeft = CLLocationCoordinate2DMake(37.5380, 126.9755);
    
    CLLocationCoordinate2D warMemorialMainEntrance = CLLocationCoordinate2DMake(37.5365, 126.9772);
    
    CLLocationDegrees latDifference = fabs(upperRight.latitude - lowerRight.latitude);
    CLLocationDegrees longDifference = fabs(upperRight.longitude - upperLeft.longitude);
    
    MKCoordinateSpan warMemorialSpan = MKCoordinateSpanMake(latDifference, longDifference);
    MKCoordinateRegion warMemorialRegion = MKCoordinateRegionMake(warMemorialMainEntrance, warMemorialSpan);
    
    return warMemorialRegion;
}

#pragma mark ******* HELPER FUNCTIONS FOR CONFIGURING SEOUL GRAND PARK NAVIGATION AID

-(void)configureNavigationAidControllerForSeoulGrandParkSettings:(NavigationAidEntryController*)nextViewController{
    
    /** navigationRegionName is the searchable query parameter that specifies the navigation region for which annotations will be downloaded from CloudKit and is used to creat the NSPredicate object that is passed to the CKQuery used to download the annotations **/
    
    nextViewController.navigationRegionName = @"SeoulGrandPark";
    
    nextViewController.annotationsFileSource = @"SeoulGrandParkRegions";
    
    /** The annotation view image used to display annotations on the map view **/
    
    nextViewController.annotationViewImagePath = @"zooCageA";
    
    nextViewController.polygonOverlayFileSources = [NSArray arrayWithObjects:@"SeoulGrandParkArea", nil];
    
    nextViewController.mapCoordinateRegion = [self getSeoulGrandParkMapRegion];
}



-(MKCoordinateRegion)getSeoulGrandParkMapRegion{
    
    
    CLLocationCoordinate2D seoulGrandParkEntrance = CLLocationCoordinate2DMake(37.4294604,127.0124504);
    
    MKCoordinateRegion warMemorialRegion = MKCoordinateRegionMake(seoulGrandParkEntrance, MKCoordinateSpanMake(0.02, 0.04));
    
    return warMemorialRegion;
}


@end
