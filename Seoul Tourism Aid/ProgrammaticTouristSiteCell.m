//
//  ProgrammaticTouristSiteCell.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/11/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgrammaticTouristSiteCell.h"
#import "UIView+HelperMethods.h"
#import "UserLocationManager.h"
#import "Constants.h"
#import "OperatingHours.h"

@interface ProgrammaticTouristSiteCell ()

@property UIImageView *siteImageView;
@property UILabel *titleLabel;
@property UILabel *isOpenStatusLabel;
@property UILabel *distanceLabel;
@property UIButton* getDirectionsButton;
@property UIButton* getDetailsButton;

@property (readonly) OperatingHours* operatingHours;


- (void)getDirectionsForTouristSite;
- (void)getDetailsForTouristSite;

@end

@implementation ProgrammaticTouristSiteCell


static void *TouristConfigurationContext = &TouristConfigurationContext;

/** The TouristSiteCollectionViewCell can observe it's tourist configuration object; make sure that tourist configuration object's computed properties also are KVO compliant **/




/** Implement getters and setters for labels and image view **/

-(instancetype)init{
    
    if(self = [super init]){
        
        CGFloat cellWidth = CGRectGetWidth(self.contentView.frame);
        CGFloat cellHeight = CGRectGetHeight(self.contentView.frame);

        CGFloat leadingSpace = cellWidth*0.10;
        CGFloat topPadding = cellHeight*0.05;
        CGFloat bottomPadding = cellWidth*0.05;
        CGFloat trailingSpace = cellWidth*0.05;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(leadingSpace, topPadding, cellWidth*0.50, cellHeight*0.15)];
        [self.contentView addSubview:_titleLabel];
        
        _isOpenStatusLabel = [[UILabel alloc] init];
        [_isOpenStatusLabel setFrame:CGRectMake(leadingSpace, topPadding + cellHeight*0.15, cellWidth*0.30, cellHeight*0.15)];
        [self.contentView addSubview:_isOpenStatusLabel];

        _siteImageView = [[UIImageView alloc] init];
        _siteImageView.frame = self.contentView.frame;
        [self.contentView addSubview:_siteImageView];

        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setFrame:CGRectMake(leadingSpace, cellHeight-bottomPadding-cellHeight*030, cellWidth*0.50, cellHeight*0.15)];
        [self.contentView addSubview:_distanceLabel];

        _getDetailsButton = [[UIButton alloc] init];
        [_getDetailsButton setFrame:CGRectMake(cellWidth-trailingSpace-40, topPadding, 40, 40)];
        [_getDetailsButton addTarget:self action:@selector(getDetailsForTouristSite) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_getDetailsButton];

        _getDirectionsButton = [[UIButton alloc] init];
        [_getDirectionsButton setFrame:CGRectMake(cellWidth-trailingSpace-40, topPadding+40+10, 40, 40)];
        [_getDirectionsButton addTarget:self action:@selector(getDirectionsButton) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_getDirectionsButton];

        
        [self addObserver:self forKeyPath:@"touristSiteConfigurationObject.operatingHours" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:TouristConfigurationContext];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        
        [self addObserver:self forKeyPath:@"touristSiteConfigurationObject.operatingHours" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:TouristConfigurationContext];
        
    }
    
    return self;
}



-(void)dealloc{
    [self removeObserver:self forKeyPath:@"touristSiteConfigurationObject.operatingHours"];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"touristSiteConfigurationObject.operatingHours"]){
        NSLog(@"Updating isOpenStatus");
        
        NSString* isOpenStatus = self.touristSiteConfigurationObject.isOpen ? @"Open" : @"Closed";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setIsOpenStatusText:isOpenStatus];
            
            
        });
        
    }
}


#pragma mark ************ TITLE TEXT and TITLE LABEL

-(void)setTitleText:(NSString *)titleText{
    
   
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setMinimumScaleFactor:0.50];
    
    [self.titleLabel setText:titleText];
    [self layoutIfNeeded];
}

-(NSString *)titleText{
    return [self.titleLabel text];
}


#pragma mark ********* IMAGEVIEW AND IMAGE

-(void)setSiteImage:(UIImage *)siteImage{
    
    [self.siteImageView setImage:siteImage];
    [self layoutIfNeeded];
}

-(UIImage *)siteImage{
    
    return [self.siteImageView image];
}




#pragma mark ******* IS_OPEN_STATUS TEXT and LABEL

-(void)setIsOpenStatusText:(NSString *)isOpenStatusText{
    
    [self.isOpenStatusLabel setAdjustsFontSizeToFitWidth:YES];
    [self.isOpenStatusLabel setMinimumScaleFactor:0.50];
    [self.isOpenStatusLabel setText:isOpenStatusText];
    
    [self layoutSubviews];
    
}

-(NSString *)isOpenStatusText{
    return [self.isOpenStatusLabel text];
}

#pragma mark ******* DISTANCE TO SITE TEXT and LABEL


-(void)setDistanceToSiteText:(NSString *)distanceToSiteText{
    
    NSString* labelString = [[NSString alloc] init];
    
    if(distanceToSiteText){
        
        labelString = [labelString stringByAppendingString:@"Distance: "];
        
        labelString = [labelString stringByAppendingString:distanceToSiteText];
        
        labelString = [labelString stringByAppendingString:@" km"];
    }
    
    if([labelString isEqualToString:@""]){
        [self.distanceLabel setText:@"Getting distance..."];
    } else{
        [self.distanceLabel setText:labelString];
        
    }
    
    
}

-(NSString *)distanceToSiteText{
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    CLLocation* endLocation;
    
    endLocation = self.touristSiteConfigurationObject.location ? self.touristSiteConfigurationObject.location : [[CLLocation alloc] initWithLatitude:self.touristSiteConfigurationObject.coordinate.latitude longitude:self.touristSiteConfigurationObject.coordinate.longitude];
    
    
    CLLocationDistance distanceToSite = [userLocation distanceFromLocation:endLocation]/1000.00;
    
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:2];
    
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distanceToSite]];
    
}

#pragma mark ****** IBACTION IMPLEMENTATIONS

-(void)getDirectionsForTouristSite{
    
    
    CLLocationDegrees toLatitude = self.touristSiteConfigurationObject.location.coordinate.latitude;
    CLLocationDegrees toLongitude = self.touristSiteConfigurationObject.location.coordinate.longitude;
    
    MKPlacemark* toPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(toLatitude, toLongitude)];
    
    MKMapItem* toMapItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    MKPlacemark* userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];
    
    MKMapItem* fromMapItem = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    
    // Create a region centered on the starting point with a 10km span
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(toPlacemark.coordinate, 10000, 10000);
    
    // Open the item in Maps, specifying the map region to display.
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:toMapItem,fromMapItem, nil]
                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
}

- (void)getDetailsForTouristSite{
    
    /** Since this collection view cell is a subview of a collecion view that is being managed by a viewcontroller, which in turn is a child view controller for paret view contrller that is the root view of a navigation controller, posting notification is best option to  transfer data **/
    
    //Send notification and pass data so that the TouristCategorySelectionController's navigation controller can present the detail controller
    
    NSDictionary* userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.touristSiteConfigurationObject,@"touristSiteConfiguration", nil];
    
    
    NSLog(@"From tourist site collection view cell.  Name: %@, Lat/Long: %f,%f",[self.touristSiteConfigurationObject name],self.touristSiteConfigurationObject.midCoordinate.latitude,self.touristSiteConfigurationObject.midCoordinate.longitude);
    
    NSLog(@"Sending userInfoDict %@",[userInfoDict description]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REQUEST_LOAD_TOURIST_SITE_DETAIL_CONTROLLER object:self userInfo:userInfoDict];
}

#pragma mark ******** OPERATING HOURS

-(OperatingHours *)operatingHours{
    
    return self.touristSiteConfigurationObject.operatingHours;
    
}


+(NSSet<NSString *> *)keyPathsForValuesAffectingOperatingHours{
    return [NSSet setWithObjects:@"touristSiteConfigurationObject", nil];
}

@end
