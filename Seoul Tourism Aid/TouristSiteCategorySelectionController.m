//
//  TouristSiteCategorySelectionController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/27/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouristSiteCategorySelectionController.h"
#import "TouristSiteCollectionViewController.h"
#import "TouristSiteDetailController.h"
#import "UserLocationManager.h"
#import "UIColor+HelperMethods.h"
#import "Constants.h"

@interface TouristSiteCategorySelectionController ()


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)returnToMainMenu:(UIBarButtonItem *)sender;

@property TouristSiteConfiguration* selectedTouristSiteConfiguration;

@property TouristSiteCollectionViewController* museumsViewController;
@property TouristSiteCollectionViewController* templesViewController;
@property TouristSiteCollectionViewController* parksViewController;
@property TouristSiteCollectionViewController* seoulTowerController;
@property TouristSiteCollectionViewController* yangguCountyController;
@property TouristSiteCollectionViewController* naturalSitesController;
@property TouristSiteCollectionViewController* otherSitesViewController;
@property TouristSiteCollectionViewController* shoppingViewController;


@end

@implementation TouristSiteCategorySelectionController


-(void)viewWillLayoutSubviews{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    UserLocationManager* sharedLocationManager = [UserLocationManager sharedLocationManager];
    
    [sharedLocationManager requestAuthorizationAndStartUpdates];


    
}

/**

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    
    for(UIViewController* childViewController in self.childViewControllers){
    
        [self setOverrideTraitCollection:newCollection forChildViewController:childViewController];
    }
    
    /** Remove all of the subviews from the scroll view **/
    
   /**
    
    for (UIView*subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }

    
    /** Remove all child view controllers **/
    
    /**
    for(UIViewController*childViewController in self.childViewControllers){
        [childViewController removeFromParentViewController];
    }
    
    [self configureScrollViewWithCachedViewControllers:newCollection];
    
}

**/

-(void)viewDidLoad{
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.view setBackgroundColor:[UIColor skyBlueColor]];
    


    [self configureScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTouristSiteConfiguration:) name:DID_REQUEST_LOAD_TOURIST_SITE_DETAIL_CONTROLLER object:nil];
}




-(void)loadTouristSiteConfiguration:(NSNotification*)notification{
    
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
       self.selectedTouristSiteConfiguration = (TouristSiteConfiguration*) notification.userInfo[@"touristSiteConfiguration"];
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self performSegueWithIdentifier:@"showTouristSiteDetailController" sender:nil];
        });
    });
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showTouristSiteDetailController"]){
        
       TouristSiteDetailController* detailController = (TouristSiteDetailController*)segue.destinationViewController;
        
        detailController.touristSiteConfiguration = self.selectedTouristSiteConfiguration;
        detailController.titleText = self.selectedTouristSiteConfiguration.siteTitle;
        detailController.subtitleText = self.selectedTouristSiteConfiguration.siteSubtitle;
        detailController.descriptionText = self.selectedTouristSiteConfiguration.siteDescription;
        detailController.detailImage = self.selectedTouristSiteConfiguration.largeImage;
        detailController.regionMonitoringStatus = self.selectedTouristSiteConfiguration.isUnderRegionMonitoring;
    
    }
}


-(void) configureScrollView{
    
    CGFloat scrollViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*4.50);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    __block CGFloat controllerIndex = 0;
    
    CGFloat controllerHeight = scrollViewHeight*0.50;
    
    CGRect(^getControllerFrame)(void) = ^CGRect(void){
        
        CGRect frame = CGRectMake(0.00, controllerIndex*controllerHeight+controllerHeight*0.30, scrollViewWidth, controllerHeight);
        
        return frame;
    };
    

    /** Add Museums View Controller **/
    
    CGRect frame1 = getControllerFrame();
    
    self.museumsViewController = [self addChildViewControllerWithFrame:frame1 andWithTouristCategory:MUSUEM];

    UILabel* label1 = [self getLabelFromRawFrame:frame1 andWithTitle:@"Museums and Other Cultural Sites" andLabelHeight:20];
    
    [self.scrollView addSubview:label1];

    
    controllerIndex++;
    
    
    /** Add Yanggu County View Controller **/
    
    CGRect frame2 = getControllerFrame();
    

    self.yangguCountyController = [self addChildViewControllerWithFrame:frame2 andWithTouristCategory:YANGGU_COUNTY];
    
    
    UILabel* label2 = [self getLabelFromRawFrame:frame2 andWithTitle:@"Yanggu County" andLabelHeight:20];
    
    [self.scrollView addSubview:label2];

    controllerIndex++;
    
    
    /** Add Parks View Controller **/
    
    
    CGRect frame3 = getControllerFrame();
    
    
    self.parksViewController = [self addChildViewControllerWithFrame:frame3 andWithTouristCategory:PARK];
    
    UILabel* label3 = [self getLabelFromRawFrame:frame3 andWithTitle:@"Parks and Other Recreational Areas" andLabelHeight:20];
    
    [self.scrollView addSubview:label3];
    
    controllerIndex++;
    
    /** Add Shopping View Controller **/
    
    CGRect frame4 = getControllerFrame();
    
    self.shoppingViewController = [self addChildViewControllerWithFrame:frame4 andWithTouristCategory:SHOPPING_AREA];
    
    UILabel* label4 = [self getLabelFromRawFrame:frame4 andWithTitle:@"Shopping Malls and Other Stores" andLabelHeight:20];
    
    [self.scrollView addSubview:label4];
    
    controllerIndex++;
    
    //Configure the next view controller...
    
    CGRect frame5 = getControllerFrame();
    
    
    UILabel* label5 = [self getLabelFromRawFrame:frame5 andWithTitle:@"Temples" andLabelHeight:20];
    
    self.templesViewController = [self addChildViewControllerWithFrame:frame5 andWithTouristCategory:TEMPLE];
    
    [self.scrollView addSubview:label5];
    
    controllerIndex++;
    
    //Configure the next view controller...
    
    
    CGRect frame6 = getControllerFrame();
    
   self.naturalSitesController = [self addChildViewControllerWithFrame:frame6 andWithTouristCategory:NATURAL_SITE];
    
    
    UILabel* label6 = [self getLabelFromRawFrame:frame6 andWithTitle:@"Natural/Outdoor Sites" andLabelHeight:20];
    
    [self.scrollView addSubview:label6];
    
    controllerIndex++;
    
    
    //Configure the next view controller...
    
    CGRect frame8 = getControllerFrame();
   
    
    self.seoulTowerController = [self addChildViewControllerWithFrame:frame8 andWithTouristCategory:SEOUL_TOWER];
    
    
    UILabel* label8 = [self getLabelFromRawFrame:frame8 andWithTitle:@"Seoul Tower Area" andLabelHeight:20];
    
    [self.scrollView addSubview:label8];
    
    controllerIndex++;
    

    //Configure the next view controller...

    CGRect frame9 = getControllerFrame();
    
    self.otherSitesViewController = [self addChildViewControllerWithFrame:frame9 andWithTouristCategory:OTHER];
    
    UILabel* label9 = [self getLabelFromRawFrame:frame9 andWithTitle:@"Other Sites of Interest" andLabelHeight:20];
    
    [self.scrollView addSubview:label9];
    
    controllerIndex++;

}

-(TouristSiteCollectionViewController*) addChildViewControllerWithFrame:(CGRect)frame andWithTouristCategory:(TouristSiteCategory)category{
    
    UIStoryboard* storyboardC = [UIStoryboard storyboardWithName:@"StoryboardC" bundle:nil];
    
    TouristSiteCollectionViewController* touristSiteCVC = [storyboardC instantiateViewControllerWithIdentifier:@"TouristSiteCVC"];
    
    [self addChildViewController:touristSiteCVC];
    
    [touristSiteCVC.view setFrame:frame];
    
    [self.scrollView addSubview:touristSiteCVC.view];
    
    [touristSiteCVC didMoveToParentViewController:self];
    
    [touristSiteCVC setCategory:category];
    
    return touristSiteCVC;
}

-(UILabel*)getLabelFromRawFrame:(CGRect)rawFrame andWithTitle:(NSString*)title andLabelHeight:(CGFloat)labelHeight{
    
    CGFloat yOffset = rawFrame.size.height*0.02;
    
    CGRect modifiedFrame1 = CGRectMake(rawFrame.origin.x+20, rawFrame.origin.y-yOffset, rawFrame.size.width,labelHeight);
    
    UILabel* label = [[UILabel alloc] initWithFrame:modifiedFrame1];
    
    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:15.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributesDict];
    
    [label setAttributedText:attributedTitle];
    
    return label;
}



- (IBAction)returnToMainMenu:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end

/** This code does not get executed, since segue for the detail controller is connected to the navigation controller, not the TouristSiteCategoryCollectionController
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedTouristSiteConfigurationForDetailController:) name:@"presentTouristSiteDetailNotification" object:nil];
 
 
 
 -(void)configureScrollViewWithCachedViewControllers:(UITraitCollection*)newTraitCollection{
 
 CGFloat scrollViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
 CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
 
 
 self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*3.50);
 
 [self.scrollView setShowsHorizontalScrollIndicator:NO];
 
 __block CGFloat controllerIndex = 0;
 
 CGFloat controllerHeight = scrollViewHeight*0.30;
 
 
 
 CGRect(^getControllerFrame)(void) = ^CGRect(void){
 
 CGRect frame = CGRectMake(0.00, controllerIndex*controllerHeight+controllerHeight*0.20, scrollViewWidth, controllerHeight);
 
 
 
 return frame;
 };
 
 
 
 CGRect frame1 = getControllerFrame();
 
 [self addChildViewController:self.museumsViewController];
 
 [self.scrollView addSubview:self.museumsViewController.view];
 
 [self.museumsViewController.view setFrame:frame1];
 
 [self.museumsViewController didMoveToParentViewController:self];
 
 [self setOverrideTraitCollection:newTraitCollection forChildViewController:self.museumsViewController];
 
 UILabel* label1 = [self getLabelFromRawFrame:frame1 andWithTitle:@"Museums and Other Cultural Sites" andLabelHeight:20];
 
 [self.scrollView addSubview:label1];
 
 controllerIndex++;
 
 CGRect frame2 = getControllerFrame();
 
 [self addChildViewController:self.yangguCountyController];
 
 [self.scrollView addSubview:self.yangguCountyController.view];
 
 [self.yangguCountyController.view setFrame:frame2];
 
 [self.yangguCountyController didMoveToParentViewController:self];
 
 [self setOverrideTraitCollection:newTraitCollection forChildViewController:self.yangguCountyController];
 
 
 
 
 UILabel* label2 = [self getLabelFromRawFrame:frame2 andWithTitle:@"Yanggu County and Related Sites" andLabelHeight:20];
 
 [self.scrollView addSubview:label2];
 
 controllerIndex++;
 
 CGRect frame3 = getControllerFrame();
 
 [self addChildViewController:self.parksViewController];
 
 [self.scrollView addSubview:self.parksViewController.view];
 
 [self.parksViewController.view setFrame:frame3];
 
 [self.parksViewController didMoveToParentViewController:self];
 
 [self setOverrideTraitCollection:newTraitCollection forChildViewController:self.parksViewController];
 
 UILabel* label3 = [self getLabelFromRawFrame:frame3 andWithTitle:@"Yanggu County and Related Sites" andLabelHeight:20];
 
 [self.scrollView addSubview:label3];
 
 
 controllerIndex++;
 
 CGRect frame4 = getControllerFrame();
 
 [self addChildViewController:self.shoppingViewController];
 
 [self.scrollView addSubview:self.shoppingViewController.view];
 
 [self.shoppingViewController.view setFrame:frame3];
 
 [self.shoppingViewController didMoveToParentViewController:self];
 
 [self setOverrideTraitCollection:newTraitCollection forChildViewController:self.shoppingViewController];
 
 UILabel* label4 = [self getLabelFromRawFrame:frame4 andWithTitle:@"Yanggu County and Related Sites" andLabelHeight:20];
 
 [self.scrollView addSubview:label4];
 
 controllerIndex++;
 
 
 }

 **/


/** This code does not get executed, since segue for the detail controller is connected to the navigation controller, not the TouristSiteCategoryCollectionController
 
 -(void) setSelectedTouristSiteConfigurationForDetailController:(NSNotification*)notification{
 
 TouristSiteConfiguration* selectedTouristConfiguration = [[notification userInfo] valueForKey:@"touristSiteConfiguration"];
 
 self.selectedTouristSiteConfiguration = selectedTouristConfiguration;
 
 }
 
 
 
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 NSLog(@"Preparing segue for tourist detail controller...");
 
 if([segue.identifier isEqualToString:@"showTouristSiteDetailController"]){
 TouristSiteDetailInformationController* detailController = segue.destinationViewController;
 
 detailController.touristSiteConfiguration = self.selectedTouristSiteConfiguration;
 
 }
 }
 
 **/
