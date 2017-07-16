//
//  WeatherDetailController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/30/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import "WeatherDetailController.h"



@interface WeatherDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;


@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UILabel *cloudCoverLabel;

@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (readonly) NSString* headerLabelText;

@end



@implementation WeatherDetailController


static void* WeatherDetailContext = &WeatherDetailContext;

@synthesize temperature = _temperature;
@synthesize precipitation = _precipitation;
@synthesize  windSpeed = _windSpeed;
@synthesize  cloudCover = _cloudCover;
@synthesize  summaryText = _summaryText;
@synthesize  humidity = _humidity;
@synthesize date = _date;


-(void)viewWillLayoutSubviews{
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* temperatureFormatter = [[NSNumberFormatter alloc] init];
    [temperatureFormatter setMaximumFractionDigits:2];
    [temperatureFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* temperatureNumberString = [temperatureFormatter stringFromNumber:[NSNumber numberWithDouble:self.temperature]];
    NSString* temperatureString = [NSString stringWithFormat:@"     %@ °F",temperatureNumberString];
    [self.temperatureLabel setText:temperatureString];
    
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* humidityFormatter = [[NSNumberFormatter alloc] init];
    [humidityFormatter setMinimumFractionDigits:2];
    [humidityFormatter setMaximumFractionDigits:2];
    [humidityFormatter setMaximumIntegerDigits:1];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* humidityNumberString = [humidityFormatter stringFromNumber:[NSNumber numberWithDouble:self.humidity]];
    NSString* humidityString = [NSString stringWithFormat:@"     Humidity: %@",humidityNumberString];
    [self.humidityLabel setText:humidityString];
    
    
    /** Configure number formatter for humidity **/
    
    NSNumberFormatter* precipitationFormatter = [[NSNumberFormatter alloc] init];
    [precipitationFormatter setMaximumFractionDigits:2];
    [precipitationFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* precipitationNumberString = [precipitationFormatter stringFromNumber:[NSNumber numberWithDouble:self.precipitation]];
    NSString* precipitationString = [NSString stringWithFormat:@"     %@ inches",precipitationNumberString];
    
    [self.precipitationLabel setText:precipitationString];
    
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* cloudCoverFormatter = [[NSNumberFormatter alloc] init];
    [cloudCoverFormatter setMinimumFractionDigits:0];
    [cloudCoverFormatter setMaximumFractionDigits:0];
    [cloudCoverFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* cloudCoverNumberString = [cloudCoverFormatter stringFromNumber:[NSNumber numberWithDouble:self.cloudCover*100]];
    NSString* cloudCoverString = [NSString stringWithFormat:@"     Percent Cloud Cover: %@",cloudCoverNumberString];
    
    [self.cloudCoverLabel setText:cloudCoverString];
    
    
    /** Configure Wind Speed NumberFormatter and Label **/
    NSNumberFormatter* windSpeedFormatter = [[NSNumberFormatter alloc] init];
    [windSpeedFormatter setMinimumFractionDigits:0];
    [windSpeedFormatter setMaximumFractionDigits:0];
    [windSpeedFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* windSpeedNumberString = [windSpeedFormatter stringFromNumber:[NSNumber numberWithDouble:self.windSpeed]];
    NSString* windSpeedString = [NSString stringWithFormat:@"     Wind Speed: %@ mph",windSpeedNumberString];
    
    [self.windSpeedLabel setText:windSpeedString];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    
    NSString* dateString = [dateFormatter stringFromDate:self.date];
    
    NSString* headerLabelText = [NSString stringWithFormat:@"%@: %@",dateString,self.summaryText];
    
    [self.summaryLabel setText:headerLabelText];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}


-(void)viewDidLoad{

    

    NSLog(@"Weather Detail Controller loaded with values of Temperature: %f, Precipitation: %f, Cloud Cover: %f, Wind Speed: %d, Date: %@, Summary Text: %@", self.temperature,self.precipitation,self.cloudCover,self.windSpeed,self.date,self.summaryText);
    

}






@end
