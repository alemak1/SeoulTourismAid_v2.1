//
//  WeatherDisplayController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WeatherDisplayController.h"
#import "WeatherForecastCollectionController.h"
#import "WeatherCollectionCell.h"
#import "WeatherDetailController.h"

#import "WFSManager.h"
#import "WeatherIconManager.h"
#import "WeatherConfiguration.h"
#import "UIView+HelperMethods.h"
#import "UIViewController+HelperMethods.h"
#import "Constants.h"

#import "WVController.h"

@interface WeatherDisplayController () <UIPickerViewDelegate,UIPickerViewDataSource, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>


/** Outlets and Actions **/

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)changedForecastDate:(UIDatePicker *)sender;



- (IBAction)getWeatherForecast:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;

@property (weak, nonatomic) IBOutlet UISlider *forecastPeriodSlider;

- (IBAction)changedForecastPeriod:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *forecastPeriodLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property UICollectionView* childCollectionView;


@property CLLocationCoordinate2D currentlySelectedLocationCoordinate;



/** Helper Properties for Configuring URL **/

@property (readonly) NSString* currentRequestURI;
@property (readonly) NSString* apiKey;

/** Data Source **/

@property WFSManager* wfsManager;


/** Properties related to NSURL Session **/

@property NSURLSession* sessionForWeatherDataRequests;
@property (readonly) NSURLSessionConfiguration* sessionConfiguration;
@property (readonly) NSURLSessionConfiguration* backgroundSessionConfiguration;
@property (readonly) NSOperationQueue* backgroundSessionOperationQueue;

@property NSMutableArray<NSDictionary*>* jsonDictArray;
@property NSMutableArray<WeatherConfiguration*>* jsonConfigurationArray;


/** Navigation Buttons **/

- (IBAction)dismissPresentedViewController:(UIBarButtonItem *)sender;

- (IBAction)dismissForecastController:(UIBarButtonItem *)sender;


/** Constraint Outlets **/

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingConstraintBtwnTopAndMiddleLabels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingConstraintBtwnBottomAndMiddleLabels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacingBtwnContainerAndButtonConstraint;


/** Weather Configuration Object - Currently Selected **/

@property WeatherConfiguration* currentlySelectedWeatherConfiguration;

- (IBAction)loadDarkSkyWebsite:(UIButton *)sender;


@end

@implementation WeatherDisplayController

static NSString* _baseURL = @"https://api.darksky.net/forecast/";
static NSString* _apiKey = DARK_SKY_API;

BOOL _userHasSelectedForecastPeriod = false;
BOOL _userHasSelectedDate = false;

NSOperationQueue* _backgroundOperationQueue;
int backgroundSessionIndex = 0;

-(void)viewWillAppear:(BOOL)animated{
    
   
    [self.locationPicker setDelegate:self];
    [self.locationPicker setDataSource:self];
}

-(void)viewDidLoad{
    
    
    self.wfsManager = [[WFSManager alloc] initFromFileName:@"WeatherForecastSites"];
    
    
     WeatherForecastCollectionController* forecastCollectionController = (WeatherForecastCollectionController*)[self.childViewControllers objectAtIndex:0];
    
    self.childCollectionView = forecastCollectionController.collectionView;
    
    [self.childCollectionView setDelegate:self];
    [self.childCollectionView setDataSource:self];
    
    
    [self.childCollectionView reloadData];
    
    /** Provide initial values for weather forecast **/
    
    [self initializeSelectorWidgets];

    
}

-(void)didReceiveMemoryWarning{
    
    
}

#pragma mark **** METHODS THAT TRIGGER NEW URLSESSIONS 

- (IBAction)changedForecastDate:(UIDatePicker *)sender {
    
    _userHasSelectedDate = true;

}

- (IBAction)getWeatherForecast:(UIButton *)sender {
    
    
    [self getUpdatedJSONDataBasedOnAdjustedParameters];
    
}


- (IBAction)changedForecastPeriod:(UISlider *)sender {
    
    _userHasSelectedForecastPeriod = true;
    
    NSUInteger forecastPeriod = (NSUInteger)[self.forecastPeriodSlider value];
    
    NSString* forecastPeriodString = [NSString stringWithFormat:@"%lu",forecastPeriod];
    
    forecastPeriodString = [forecastPeriodString stringByAppendingString:@" days"];
    
    [self.forecastPeriodLabel setText:forecastPeriodString];
    

    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    self.currentlySelectedLocationCoordinate = [self.wfsManager getCoordinateForForecastSite:row];
    
    
   
}


#pragma mark ******* PICKER VIEW DELEGATE METHODS


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.wfsManager getNumberOfForecastSites];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return CGRectGetHeight(pickerView.frame);
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return CGRectGetWidth(pickerView.frame);
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    NSString* labelText = [self.wfsManager getTitleForForecastSite:row];
    UILabel* labelView = [[UILabel alloc] initWithFrame:pickerView.frame];
    
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:labelText attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:5.00],NSKernAttributeName, [UIFont fontWithName:@"Optima-Bold" size:30.0],NSFontAttributeName,NSTextEffectLetterpressStyle,NSTextEffectAttributeName,nil]];
    
    [labelView setAttributedText:attributedText];
    
    [labelView setFrame:pickerView.frame];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setAdjustsFontSizeToFitWidth:YES];
    [labelView setMinimumScaleFactor:0.50];
    
    
    return labelView;
    
}

#pragma mark ****** COLLECTION VIEW DATA SOURCE AND DELEGATE METHODS

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    /** The number of JSON objects successfully downloadded from the weather API will determine the number of cells that need to be configured **/
    
    return [self.jsonConfigurationArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherCollectionCell* cell = [self.childCollectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCollectionCell" forIndexPath:indexPath];
    
    [self sortWeatherConfigurationArrayByDate];
   
    WeatherConfiguration* weatherConfiguration = [self.jsonConfigurationArray objectAtIndex:indexPath.row];
    
    [self configureCollectionViewCell:cell withWeatherConfiguration:weatherConfiguration];

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.currentlySelectedWeatherConfiguration = [self.jsonConfigurationArray objectAtIndex:indexPath.row];
    
    
    [self performSegueWithIdentifier:@"showWeatherDetailController" sender:nil];

    
}

-(void) sortWeatherConfigurationArrayByDate{
    [self.jsonConfigurationArray sortUsingComparator:^NSComparisonResult(id a, id b){
        
        NSDate* first = [(WeatherConfiguration*)a date];
        NSDate* second = [(WeatherConfiguration*)b date];
        
        return [first compare:second];
        
    }];
}


-(void) configureCollectionViewCell:(WeatherCollectionCell*)cell withWeatherConfiguration:(WeatherConfiguration*)weatherConfiguration{
    

    
    cell.weatherIconName = weatherConfiguration.iconName;
    cell.temperature = weatherConfiguration.temperature;
    cell.precipitation = weatherConfiguration.precipitation;
    cell.humidity = weatherConfiguration.humidity;
    cell.cloudCover = weatherConfiguration.cloudCover;
    cell.windSpeed = weatherConfiguration.windSpeed;
    cell.date = weatherConfiguration.date;
    cell.summaryText = weatherConfiguration.summaryText;
}

-(void)configureCollectionViewCell:(WeatherCollectionCell*)cell withJSONDict:(NSDictionary*)jsonDict{
    
    
    NSDictionary* dailyInfoDict = [jsonDict valueForKey:@"daily"];
    
    NSDictionary* configurationInfo = [[dailyInfoDict valueForKey:@"data"] objectAtIndex:0];
    
    
    NSTimeInterval unixDate = [[configurationInfo valueForKey:@"time"] longValue];
    NSDate* formattedDate = [NSDate dateWithTimeIntervalSince1970:unixDate];
    
    NSLog(@"Date: %@",formattedDate);
    
    
    NSString* iconName = [configurationInfo valueForKey:@"icon"];
    
    NSLog(@"Icon Name: %@", iconName);
    
    double temperature = [[configurationInfo valueForKey:@"temperatureMax"] doubleValue];
    
    NSLog(@"Temperature: %f",temperature);
    
    double humidity = [[configurationInfo valueForKey:@"humidity"] doubleValue];
    
    NSLog(@"Humidity: %f",humidity);
    
    double precipitation = [[configurationInfo valueForKey:@"precipIntensity"] doubleValue];
    
    NSLog(@"Precipitation: %f", precipitation);
    
    double windSpeed = [[configurationInfo valueForKey:@"windSpeed"] doubleValue];
    
    NSLog(@"WindSpeed: %f", windSpeed);
    
    double cloudCover = [[configurationInfo valueForKey:@"cloudCover"] doubleValue];
    
    NSLog(@"Cloud Cover: %f",cloudCover);
    
    
    NSString* summaryText = [configurationInfo valueForKey:@"summary"];
    
    NSLog(@"Summary text: %@",summaryText);
    

    cell.weatherIconName = iconName;
    cell.temperature = temperature;
    cell.precipitation = precipitation;
    cell.humidity = humidity;
    cell.cloudCover = cloudCover;
    cell.windSpeed = windSpeed;
    cell.date = formattedDate;
    cell.summaryText = summaryText;

}




#pragma mark ******* URL SESSION MANAGEMENT HELPER METHODS


-(void) createBackgroundURLSession{
    
    
    if([self.backgroundSessionOperationQueue operationCount] > 0 || self.sessionForWeatherDataRequests != nil){
        
        //[self.backgroundSessionOperationQueue cancelAllOperations];
        
        [self.sessionForWeatherDataRequests invalidateAndCancel];
        
        self.jsonDictArray = nil;
    }

    
    NSLog(@"Creating a new session with a new background session configuration");
    
    self.sessionForWeatherDataRequests = [NSURLSession sessionWithConfiguration:self.backgroundSessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    


}


-(void) addDataTasksToOperationQueue{
    
    /** Clear any previously downloaded JSON data **/
    if(self.jsonDictArray){
        
        NSLog(@"Clearing old json data array...");
        
        self.jsonDictArray = nil;
    }
    
    NSLog(@"Initializing new json data array...");
    
    self.jsonDictArray = [[NSMutableArray alloc] init];

    
    
    NSLog(@"Preparing to create data tasks for urls");
    
    for(NSURL* url in [self getURLsForForecastPeriod]){
        
        NSLog(@"Creating data task for url: %@",[url absoluteString]);

        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        
        NSLog(@"URL request created %@",[urlRequest description]);
        
        NSURLSessionDataTask* dataTask = [self.sessionForWeatherDataRequests dataTaskWithRequest:urlRequest];
        
        NSLog(@"Data task created with data task identifier: %d",[dataTask taskIdentifier]);
        
        [dataTask resume];
        
    }

}




-(void)getUpdatedJSONDataBasedOnAdjustedParameters{
    
    if(!_userHasSelectedDate || !_userHasSelectedDate){
        
        
        BOOL condition1 = !_userHasSelectedDate && _userHasSelectedForecastPeriod;
        BOOL condition2 = _userHasSelectedDate && !_userHasSelectedForecastPeriod;
        BOOL condition3 = !_userHasSelectedDate && !_userHasSelectedForecastPeriod;
        
        NSString* messageStr;
        
        if(condition1){
            messageStr = @"Starting Forecast Date";
        }
        
        if(condition2){
            messageStr = @"Forecast Period";
        }
        
        if(condition3){
            messageStr = @"Forecast Period and Starting Date";
        }
        
        NSString* finalMessage = [NSString stringWithFormat:@"Please select: %@",messageStr];
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Insufficient Information" message:finalMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okay];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [self cancelPreviousURLSession];
    
    [self createAndStartDataTasksForNewURLSession];
    

    
}

-(void) cancelPreviousURLSession{
    
    if(self.sessionForWeatherDataRequests != nil){
        [self.sessionForWeatherDataRequests invalidateAndCancel];
        self.sessionForWeatherDataRequests = nil;
    }
}



-(void)createAndStartDataTasksForNewURLSession{
    
    self.sessionForWeatherDataRequests = [NSURLSession sessionWithConfiguration:self.sessionConfiguration];
    
    /** Clear any previously downloaded JSON data **/
    if(self.jsonConfigurationArray){
        
        self.jsonConfigurationArray = nil;
    }
    
    self.jsonConfigurationArray = [[NSMutableArray alloc] init];
    
    for(NSURL* url in [self getURLsForForecastPeriod]){
        
        [[self.sessionForWeatherDataRequests dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(!error){
        
                if([response isKindOfClass:[NSHTTPURLResponse class]]){
                    /** JSON Dictionaries for a particular session are added to stored array **/
                    NSError* jsonError = nil;
            
            
                    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    

                
                    if(jsonError){
                        NSLog(@"Error in parsing JSON data: %@",[jsonError description]);
                    }else{
                        
                        WeatherConfiguration* weatherConfiguration = [[WeatherConfiguration alloc] initWithJSONDict:jsonDict];
                        
                        [self.jsonConfigurationArray addObject:weatherConfiguration];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.childCollectionView reloadData];
                        
                        
                        });
                        
                       
                        

                    }
                }
            }
         
            
        }] resume];
        
    }
    
    
}


-(NSArray<NSURL*>*)getURLsForForecastPeriod{
    
    NSMutableArray<NSURL*>* urlArray = [[NSMutableArray alloc] init];
    
    int numberOfForecastDays = (int)[self.forecastPeriodSlider value];
    
    if(numberOfForecastDays == 0){
        numberOfForecastDays = 1;
    }
    
    NSDate* runningDate = [self.datePicker date];
    
    if(runningDate == nil){
        runningDate = [NSDate date];
    }
    
    for(int i = 0; i < numberOfForecastDays; i++){
        
        NSCalendar* gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents* offsetComponents = [[NSDateComponents alloc] init];
        
        [offsetComponents setDay:i];
        
        
        runningDate = [gregorian dateByAddingComponents:offsetComponents toDate:runningDate options:0];
        
        
        NSTimeInterval timeIntervalSince1970 = [runningDate timeIntervalSince1970];

        
        /** The DarkSky API requires a UNIX-formatted date for its endpdoint **/
        /**
         
        runningDate = [NSDate dateWithTimeInterval:(i*3600*24) sinceDate:runningDate];
        NSTimeInterval UNIXFormattedRunningDate = [runningDate timeIntervalSince1970];
        **/
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setMaximumFractionDigits:8];
    
        NSString* runningDateString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:timeIntervalSince1970]];
    

        NSString* nextURLString = [self.currentRequestURI stringByAppendingString:runningDateString];
        
        NSURL* nextURL = [NSURL URLWithString:nextURLString];
        
        [urlArray addObject:nextURL];
    }
    
    return [NSArray arrayWithArray:urlArray];
}


-(void)showCurrentURLsForDataTasks{
    
    NSLog(@"The new set of urls is: ");
    
    for (NSURL*url in [self getURLsForForecastPeriod]) {
        NSLog(@"%@",[url absoluteString]);
    }
    
}


-(NSString *)apiKey{
    return _apiKey;
}

-(NSString *)currentRequestURI{
    
    
    
    CLLocationDegrees latitude = self.currentlySelectedLocationCoordinate.latitude;
    CLLocationDegrees longitude = self.currentlySelectedLocationCoordinate.longitude;
    
    NSString* parameterString = [NSString stringWithFormat:@"%@/%f,%f,",self.apiKey,latitude,longitude];
    
    NSString* baseURLStringWithLocationParameters = [_baseURL stringByAppendingString:parameterString];
    
    return baseURLStringWithLocationParameters;
}




-(NSURLSessionConfiguration *)sessionConfiguration{
    
    /** The readonly sessionConfiguration provides a new instance of a default session configuration each time it is accessed **/
    
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

-(NSURLSessionConfiguration *)backgroundSessionConfiguration{
    
    backgroundSessionIndex++;
    
    NSString* backgroundSessionIdentifier = [NSString stringWithFormat:@"backgroundSession-%d",backgroundSessionIndex];
    
    return [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundSessionIdentifier];
}


-(NSOperationQueue *)backgroundSessionOperationQueue{
    if(!_backgroundOperationQueue){
        _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _backgroundOperationQueue;
}

#pragma mark **** OTHER HELPER METHODS

-(NSTimeInterval) getUNIXDate{
    
    return [[self.datePicker date] timeIntervalSince1970];
    
}




#pragma mark ****** URL SESSION DELEGATE METHODS

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    NSLog(@"URL Session completed all tasks");

    [self.childCollectionView reloadData];
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    ;
    NSLog(@"URL Session became invalid due to error: %@",[error description]);
}


#pragma mark ******* URL SESSION DATA TASK DELEGATE



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if(error){
        NSLog(@"The dataTask %@ encountered an error and failed to complete, error description: %@",[task description],[error description]);
        
        [self.backgroundSessionOperationQueue cancelAllOperations];
        
        [self.sessionForWeatherDataRequests invalidateAndCancel];
        
        self.jsonDictArray = nil;
    }
}


#pragma mark ****** NSURL DATA DELEGATE

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
 
    
    
    NSError* e = nil;
    
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    

    [self.jsonDictArray addObject:jsonDict];
    
    
    
    
}


- (IBAction)dismissPresentedViewController:(UIBarButtonItem *)sender {
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissForecastController:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ******** PREPARE FOR SEGUE

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showWeatherDetailController"]){
        
        WeatherDetailController* detailController = (WeatherDetailController*)[segue destinationViewController];
      
        detailController.temperature = self.currentlySelectedWeatherConfiguration.temperature;
        detailController.humidity = self.currentlySelectedWeatherConfiguration.humidity;
        detailController.windSpeed = self.currentlySelectedWeatherConfiguration.windSpeed;
        detailController.cloudCover = self.currentlySelectedWeatherConfiguration.cloudCover;
        detailController.summaryText = self.currentlySelectedWeatherConfiguration.summaryText;
        detailController.date = self.currentlySelectedWeatherConfiguration.date;
    }
}



#pragma mark IBACTION FOR LOADING DARK SKY WEBSITE

- (IBAction)loadDarkSkyWebsite:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://darksky.net/poweredby/"];
   
}

-(void)initializeSelectorWidgets{
    
    [self.locationPicker selectRow:1 inComponent:0 animated:NO];
    [self.datePicker setDate:[NSDate date]];
    [self.forecastPeriodSlider setValue:1.00];
    self.currentlySelectedLocationCoordinate = [self.wfsManager getCoordinateForForecastSite:1];

    

}

@end
