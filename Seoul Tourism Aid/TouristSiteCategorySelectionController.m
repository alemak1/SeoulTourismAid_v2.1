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
#import "TouristSiteManager.h"
#import "Constants.h"
#import "ProgrammaticTouristSiteCell.h"
#import "TouristSiteCollectionViewCell.h"

@interface TouristSiteCategorySelectionController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>



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

@property TouristSiteManager* musuemsCollectionViewDataSource;
@property TouristSiteManager* templesCollectionViewDataSource;
@property TouristSiteManager* parksCollectionViewDataSource;
@property TouristSiteManager* dmzCollectionViewDataSource;
@property TouristSiteManager* naturalSitesCollectionViewDataSource;
@property TouristSiteManager* shoppingAreasCollectionViewDataSource;
@property TouristSiteManager* seoulTowerCollectionViewDataSource;
@property TouristSiteManager* otherSitesCollectionViewDataSource;


- (IBAction)getDirectionsForTouristSite:(id)sender;
- (IBAction)getDetailsForTouristSite:(id)sender;
    


@end

@implementation TouristSiteCategorySelectionController



-(void)viewWillAppear:(BOOL)animated{
    
    UserLocationManager* sharedLocationManager = [UserLocationManager sharedLocationManager];
    
    [sharedLocationManager requestAuthorizationAndStartUpdates];

    [self loadCollectionViewDataSources];
    
}




-(void)viewDidLoad{
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.view setBackgroundColor:[UIColor skyBlueColor]];
    

    [self configureScrollViewWithCollectionViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTouristSiteConfiguration:) name:DID_REQUEST_LOAD_TOURIST_SITE_DETAIL_CONTROLLER object:nil];
}




#pragma mark ******* HELPER METHODS FOR SETTING UP COLLECTION VIEWS

-(void) configureScrollViewWithActivityIndicators{
    
    CGFloat scrollViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*5.30);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    __block CGFloat controllerIndex = 0;
    
    CGFloat controllerHeight = scrollViewHeight*0.40;
    
    CGRect(^getCollectionViewFrame)(void) = ^CGRect(void){
        
        CGRect frame = CGRectMake(20.00, controllerIndex*controllerHeight+controllerHeight*0.35, scrollViewWidth, 250);
        
        return frame;
    };
    
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*5.50);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
   
    
    /** Add Museums CollectionView **/
    
    CGRect frame1 = getCollectionViewFrame();
    
    
    [self configureLabelAndActivityIndicatorsWithFrame:frame1 andWithTouristSiteCategory:MUSUEM andWithTitle:@"Museums and Other Cultural Sites"];
    
    controllerIndex++;
    
    
    /** Add Natural Sites CollectionView **/
    
    CGRect frame2 = getCollectionViewFrame();
    
    [self configureLabelAndActivityIndicatorsWithFrame:frame2 andWithTouristSiteCategory:NATURAL_SITE andWithTitle:@"Natural and Outdoor Sites"];

    controllerIndex++;
    
    /** Add Natural Sites CollectionView **/
    
    CGRect frame3 = getCollectionViewFrame();
    
    [self configureLabelAndActivityIndicatorsWithFrame:frame3 andWithTouristSiteCategory:SEOUL_TOWER andWithTitle:@"Seoul Tower"];

    controllerIndex++;
    
    
    CGRect frame5 = getCollectionViewFrame();
    
    
    [self configureLabelAndActivityIndicatorsWithFrame:frame5 andWithTouristSiteCategory:SHOPPING_AREA andWithTitle:@"Shopping Area"];

    
    controllerIndex++;
    
    
    
    CGRect frame6 = getCollectionViewFrame();
    
    [self configureLabelAndActivityIndicatorsWithFrame:frame6 andWithTouristSiteCategory:PARK andWithTitle:@"Parks and Other Outdoor Sites"];

    
    controllerIndex++;
    
}




-(void) configureScrollViewWithCollectionViews{
    CGFloat scrollViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*5.20);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    __block CGFloat controllerIndex = 0;
    
    CGFloat controllerHeight = scrollViewHeight*0.50;
    
    CGRect(^getCollectionViewFrame)(void) = ^CGRect(void){
        
        CGRect frame = CGRectMake(20.00, controllerIndex*controllerHeight*1.2+controllerHeight*0.15, scrollViewWidth, controllerHeight);
        
        return frame;
    };
    
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*4.20);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    
    
    /** Add Museums CollectionView **/
    
    CGRect frame1 = getCollectionViewFrame();
    
    [self configureCollectionViewWithTouristSiteCategory:MUSUEM andWithFrame:frame1 andWithTitle:@"Museums and Other Cultural Sites"];
    
    
    controllerIndex++;
    
    
    /** Add Natural Sites CollectionView **/
    
    CGRect frame2 = getCollectionViewFrame();
    
    [self configureCollectionViewWithTouristSiteCategory:NATURAL_SITE andWithFrame:frame2 andWithTitle:@"Natural and Outdoor Sites"];

    
    controllerIndex++;
    
    /** Add Natural Sites CollectionView **/
    
    CGRect frame3 = getCollectionViewFrame();
    
    
    [self configureCollectionViewWithTouristSiteCategory:SEOUL_TOWER andWithFrame:frame3 andWithTitle:@"Seoul Tower"];

    
    controllerIndex++;
    
    
    CGRect frame5 = getCollectionViewFrame();
    
    
    [self configureCollectionViewWithTouristSiteCategory:SHOPPING_AREA andWithFrame:frame5 andWithTitle:@"Shopping Area"];

    
    controllerIndex++;
    
    
    
    CGRect frame6 = getCollectionViewFrame();
    
    [self configureCollectionViewWithTouristSiteCategory:PARK andWithFrame:frame6 andWithTitle:@"Parks and Other Outdoor Sites"];

    
    controllerIndex++;
    
    CGRect frame8 = getCollectionViewFrame();
    
    [self configureCollectionViewWithTouristSiteCategory:YANGGU_COUNTY andWithFrame:frame8 andWithTitle:@"Demilitarized Zone (DMZ)"];
    
   
    controllerIndex++;
    
    CGRect frame7 = getCollectionViewFrame();
    
    [self configureCollectionViewWithTouristSiteCategory:OTHER andWithFrame:frame7 andWithTitle:@"Other Sites of Interest"];
    

    
}

-(void)configureLabelAndActivityIndicatorsWithFrame:(CGRect)frame andWithTouristSiteCategory:(TouristSiteCategory)tag andWithTitle:(NSString*)title{
    
    CGRect indicatorFrame = CGRectMake(frame.origin.x+frame.size.height*0.5, frame.origin.y+frame.size.width*0.5, 20, 20);
    
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
    
    indicatorView.tag = tag + 100;
    [indicatorView setColor:[UIColor darkGrayColor]];
    
    [self.scrollView addSubview:indicatorView];
    
    [indicatorView startAnimating];
    
    UILabel* label = [self getLabelFromRawFrame:frame andWithTitle:title andLabelHeight:20];
    
    [self.scrollView addSubview:label];
    
    
}
-(void)configureCollectionViewWithTouristSiteCategory:(TouristSiteCategory)tag andWithFrame:(CGRect)frame andWithTitle:(NSString*)title{
    
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(350, 350)];
    [flowLayout setMinimumLineSpacing:30.0];
    [flowLayout setMinimumInteritemSpacing:40];
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    
    UINib* collectionCellNib = [UINib nibWithNibName:@"TouristCollectionCellTemplate" bundle:nil];
    
    [collectionView registerNib:collectionCellNib forCellWithReuseIdentifier:[self getReuseIdentifiersForTouristSiteCategory:tag]];
    [collectionView setBackgroundColor:[UIColor skyBlueColor]];
    
    collectionView.tag = tag;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.scrollView addSubview:collectionView];
    
    UILabel* label = [self getLabelFromRawFrame:frame andWithTitle:title andLabelHeight:20];
    
    [self.scrollView addSubview:label];
    
}


-(NSString*)getReuseIdentifiersForTouristSiteCategory:(TouristSiteCategory)category{
    
    switch (category) {
        case TEMPLE:
            return @"TempleCell";
        case MUSUEM:
            return @"MuseumCell";
        case YANGGU_COUNTY:
            return @"DMZCell";
        case SHOPPING_AREA:
            return @"ShoppingAreaCell";
        case PARK:
            return @"ParkCell";
        case NATURAL_SITE:
            return @"NaturalSiteCell";
        case SEOUL_TOWER:
            return @"SeoulTowerCell";
        case SPORT_STADIUM:
            return @"SportStadiumCell";
        case OTHER:
            return @"OtherSiteCell";
        case MONUMENT_OR_WAR_MEMORIAL:
            return @"MonumentWarMemorialCell";
        default:
            return nil;
    }
}

#pragma mark ********** HELPER METHODS FOR SETTING UP CHILDVIEW CONTROLLERS

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


-(void) configureScrollViewWithChildCollectionControllers{
    
    CGFloat scrollViewWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
    
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight*5.30);
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    __block CGFloat controllerIndex = 0;
    
    CGFloat controllerHeight = scrollViewHeight*0.60;
    
    CGRect(^getControllerFrame)(void) = ^CGRect(void){
        
        CGRect frame = CGRectMake(0.00, controllerIndex*controllerHeight+controllerHeight*0.30, scrollViewWidth, 250);
        
        return frame;
    };
    
    
    /** Add Museums View Controller **/
    
    CGRect frame1 = getControllerFrame();
    
    self.museumsViewController = [self addChildViewControllerWithFrame:frame1 andWithTouristCategory:MUSUEM];
    
    UILabel* label1 = [self getLabelFromRawFrame:frame1 andWithTitle:@"Museums and Other Cultural Sites" andLabelHeight:20];
    
    [self.scrollView addSubview:label1];
    
    
    controllerIndex++;
    
    
    /** Add Yanggu County View Controller **/
    
    /** Can add additional view controllers here **/
    
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



-(UILabel*)getLabelFromRawFrame:(CGRect)rawFrame andWithTitle:(NSString*)title andLabelHeight:(CGFloat)labelHeight{
    
    CGFloat yOffset = rawFrame.size.height*0.12;
    
    CGRect modifiedFrame1 = CGRectMake(rawFrame.origin.x+20, rawFrame.origin.y-yOffset, rawFrame.size.width,labelHeight);
    
    UILabel* label = [[UILabel alloc] initWithFrame:modifiedFrame1];
    
    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-Medium" size:15.0],NSFontAttributeName,[UIColor koreanBlue],NSForegroundColorAttributeName, nil];
    
    NSAttributedString* attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributesDict];
    
    [label setAttributedText:attributedTitle];
    
    return label;
}


#pragma mark ******* HELPER METHODS FOR RETRIEVING/UPDATING COLLECTION VIEWS (based on tag identifier)

-(void)reloadCollectionViewWithTouristSiteCategory:(TouristSiteCategory)category{
    

    for (UIView*subview in self.scrollView.subviews) {
        if([subview isKindOfClass:[UICollectionView class]]){
            UICollectionView* collectionView = (UICollectionView*)subview;
            if(collectionView.tag == category){
                
                
                [collectionView reloadData];
            }
        }
    }
    
    
}

-(UICollectionView*)getCollectionViewForTouristSiteCategory:(TouristSiteCategory)category{
    for (UIView*subview in self.scrollView.subviews) {
        if([subview isKindOfClass:[UICollectionView class]]){
            UICollectionView* collectionView = (UICollectionView*)subview;
            if(collectionView.tag == category){
                return collectionView;
            }
        }
    }
    
    return nil;
}


#pragma mark ********** HELPER METHOD FOR LOADING COLLECTION VIEW DATASOURCES ASYNCHRONOUSLY


-(UIActivityIndicatorView*)getIndicatorViewForTouristSiteCategory:(TouristSiteCategory)category{
    
    for(UIView*subview in self.scrollView.subviews){
        if(subview.tag == category+100){
            UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*)subview;
            return activityIndicator;
        }
    }
    
    return nil;
}

-(void)loadCollectionViewDataSources{
    
    NSLog(@"Preparing to load collection view data sources...");
    
    
    
    if(self.musuemsCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for museums");
        
        
        self.musuemsCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:MUSUEM andWithBatchCompletionHandler:^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSLog(@"Finished loading collection view data source for museum");
                
                [self reloadCollectionViewWithTouristSiteCategory:MUSUEM];
                
            });
            
        }];
    }
    
    if(self.templesCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for temples");
        
        
        self.templesCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:TEMPLE andWithBatchCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Finished loading collection view data source for temples");
                
                
                [self reloadCollectionViewWithTouristSiteCategory:TEMPLE];
                
            });
            
            
        }];
    }
    
    
    if(self.seoulTowerCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for Seoul Tower");
        
        self.seoulTowerCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:SEOUL_TOWER andWithBatchCompletionHandler:^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Finished loading collection view data source for Seoul Tower");
                
                [self reloadCollectionViewWithTouristSiteCategory:SEOUL_TOWER];
                
            });
            
            
        }];
    }
    
    if(self.parksCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for Park");
        
        self.parksCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:PARK andWithBatchCompletionHandler:^{
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSLog(@"Finished loading collection view data source for Park");
                
                [self reloadCollectionViewWithTouristSiteCategory:PARK];
                
            });
            
        }];
    }
    
    if(self.shoppingAreasCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for Shopping Area");
        
        self.shoppingAreasCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:SHOPPING_AREA andWithBatchCompletionHandler:^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSLog(@"Finished loading collection view data source for Shopping Area");
                
                
                [self reloadCollectionViewWithTouristSiteCategory:SHOPPING_AREA];
                
            });
            
        }];
    }
    
    if(self.naturalSitesCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for Natural Site");
        
        self.naturalSitesCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:NATURAL_SITE andWithBatchCompletionHandler:^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSLog(@"Finished loading collection view data source for Natural Site");
                
            
                [self reloadCollectionViewWithTouristSiteCategory:NATURAL_SITE];
                
            });
            
        }];
    }
    
    if(self.dmzCollectionViewDataSource == nil){
        
        NSLog(@"Starting to load collection view data source for Yanggu County ");
        
        self.dmzCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:YANGGU_COUNTY andWithBatchCompletionHandler:^{
            
         

            dispatch_async(dispatch_get_main_queue(), ^{
                
              

                NSLog(@"Finished loading collection view data source for Yanggu County");
                
                [self reloadCollectionViewWithTouristSiteCategory:YANGGU_COUNTY];
                
            });
            
        }];
    }
    
    if(self.otherSitesViewController == nil){
        
        NSLog(@"Starting to load collection view data source for Yanggu County ");
        
        self.otherSitesCollectionViewDataSource = [[TouristSiteManager alloc] initFromCloudWithTouristSiteCategory:OTHER andWithBatchCompletionHandler:^{
            
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
         
                NSLog(@"Finished loading collection view data source for Yanggu County");
                
                [self reloadCollectionViewWithTouristSiteCategory:OTHER];
                
            });
            
        }];
    }
}


#pragma mark *************** COLLECTION VIEW DATASOURCE AND DELEGATE METHODS

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        switch ((TouristSiteCategory)collectionView.tag) {
            case MUSUEM:
                if(self.musuemsCollectionViewDataSource){
                    self.selectedTouristSiteConfiguration = [self.musuemsCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                }
                break;
            case TEMPLE:
                self.selectedTouristSiteConfiguration = [self.templesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case SEOUL_TOWER:
                self.selectedTouristSiteConfiguration = [self.seoulTowerCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case SHOPPING_AREA:
                self.selectedTouristSiteConfiguration = [self.shoppingAreasCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case NATURAL_SITE:
                self.selectedTouristSiteConfiguration = [self.naturalSitesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case PARK:
                self.selectedTouristSiteConfiguration = [self.parksCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case YANGGU_COUNTY:
                self.selectedTouristSiteConfiguration = [self.dmzCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            case OTHER:
                self.selectedTouristSiteConfiguration = [self.otherSitesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
                break;
            default:
                self.selectedTouristSiteConfiguration = [self.naturalSitesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"showTouristSiteDetailController" sender:nil];

        });
        
    
    });
    
}


#pragma mark ***************** COLLECTION VIEW DELEGATE METHODS

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(290, 230);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 40;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 40;
}





-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch ((TouristSiteCategory)collectionView.tag) {
        case MUSUEM:
            if(self.musuemsCollectionViewDataSource){
                return [self.musuemsCollectionViewDataSource totalNumberOfTouristSitesInMasterArray
                    ];
            }
            break;
        case TEMPLE:
            if(self.templesCollectionViewDataSource){
                return [self.templesCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case SEOUL_TOWER:
            if(self.seoulTowerCollectionViewDataSource){
            return [self.seoulTowerCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case SHOPPING_AREA:
            if(self.shoppingAreasCollectionViewDataSource){
                return [self.shoppingAreasCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case NATURAL_SITE:
            if(self.naturalSitesCollectionViewDataSource){
                return [self.naturalSitesCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case PARK:
            if(self.parksCollectionViewDataSource){
                return [self.parksCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case YANGGU_COUNTY:
            if(self.dmzCollectionViewDataSource){
                return [self.dmzCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];
            }
            break;
        case OTHER:
            if(self.otherSitesCollectionViewDataSource){
                return [self.otherSitesCollectionViewDataSource totalNumberOfTouristSitesInMasterArray];

            }
            break;
        default:
            return 0;
    }
    
    return 0;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TouristSiteConfiguration* configurationObject;
    UICollectionView* taggedCollectionView;
    
    switch ((TouristSiteCategory)collectionView.tag) {
        case YANGGU_COUNTY:
            configurationObject = [self.dmzCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:YANGGU_COUNTY];

            break;
        case TEMPLE:
            configurationObject = [self.templesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:TEMPLE];

            break;
        case PARK:
            configurationObject = [self.parksCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:PARK];

            break;
        case SHOPPING_AREA:
            configurationObject = [self.shoppingAreasCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:SHOPPING_AREA];

            break;
        case MUSUEM:
            configurationObject = [self.musuemsCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:MUSUEM];

            break;
        case SEOUL_TOWER:
            configurationObject = [self.seoulTowerCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:SEOUL_TOWER];

            break;
        case NATURAL_SITE:
            configurationObject = [self.naturalSitesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:NATURAL_SITE];
            break;
        case OTHER:
            configurationObject = [self.otherSitesCollectionViewDataSource getConfigurationObjectFromConfigurationArray:indexPath.row];
            taggedCollectionView = [self getCollectionViewForTouristSiteCategory:OTHER];
            break;
        default:
            break;
    }
    
    NSString* reuseIdentifier = [self getReuseIdentifiersForTouristSiteCategory:(TouristSiteCategory)collectionView.tag];
    
    TouristSiteCollectionViewCell* cell = [taggedCollectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.siteImage = [configurationObject largeImage];
    
    cell.titleText = [configurationObject siteTitle];
    
    cell.isOpenStatusText = @"Checking if open....";
    
    cell.distanceToSiteText = [configurationObject distanceFromUserString];
    
    cell.touristSiteConfigurationObject = configurationObject;
    
    return cell;
    
}

#pragma mark ****** HELPER METHODS FOR NAVIGATION VIEW CONTROLLER TRANSITIONS

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showTouristSiteDetailController"]){
        
        TouristSiteDetailController* detailController = (TouristSiteDetailController*)segue.destinationViewController;
        
        detailController.touristSiteConfiguration = self.selectedTouristSiteConfiguration;
        detailController.titleText = self.selectedTouristSiteConfiguration.siteTitle;
        detailController.subtitleText = self.selectedTouristSiteConfiguration.siteSubtitle;
        detailController.descriptionText = self.selectedTouristSiteConfiguration.siteDescription;
        detailController.detailImage = self.selectedTouristSiteConfiguration.largeImage;
        detailController.regionMonitoringStatus = self.selectedTouristSiteConfiguration.isUnderRegionMonitoring;
        detailController.flickrAuthor = self.selectedTouristSiteConfiguration.flickrAuthor;
        
        
    }
}



-(void)loadTouristSiteConfiguration:(NSNotification*)notification{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        self.selectedTouristSiteConfiguration = (TouristSiteConfiguration*) notification.userInfo[@"touristSiteConfiguration"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"showTouristSiteDetailController" sender:nil];
        });
    });
    
}



- (IBAction)returnToMainMenu:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)returnToTouristSiteCategorySelectionController:(UIStoryboardSegue*)segue{
    
}


#pragma mark ************ HANDLERS FOR DEVICE-ORIENTATION/SIZE-CLASS CHANGES

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    
    
    for(UIView*subview in self.scrollView.subviews){
        
        CGRect frame = subview.frame;
        
        frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
        
        [subview setFrame:frame];
        
        
        
    }
    
    /**
     for(UIViewController*childViewController in self.childViewControllers){
     
     CGRect frame = childViewController.view.frame;
     
     frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
     
     [childViewController.view setFrame:frame];
     
     [childViewController.view setBackgroundColor:[UIColor redColor]];
     
     [childViewController.view layoutIfNeeded];
     
     }
     **/
    
}

#pragma mark ******** IBOUTLETS FOR TOURIST SITE COLLECTION VIEW CELLS


- (IBAction)getDirectionsForTouristSite:(id)sender {
    
    
    CLLocationDegrees toLatitude = self.selectedTouristSiteConfiguration.location.coordinate.latitude;
    CLLocationDegrees toLongitude = self.selectedTouristSiteConfiguration.location.coordinate.longitude;
    
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

- (IBAction)getDetailsForTouristSite:(id)sender {
    
    /** Since this collection view cell is a subview of a collecion view that is being managed by a viewcontroller, which in turn is a child view controller for paret view contrller that is the root view of a navigation controller, posting notification is best option to  transfer data **/
    
    //Send notification and pass data so that the TouristCategorySelectionController's navigation controller can present the detail controller
    
    
    [self performSegueWithIdentifier:@"showTouristSiteDetailController" sender:nil];
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
