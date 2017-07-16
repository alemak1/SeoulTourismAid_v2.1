//
//  WeatherCollectionCell.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/29/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCollectionCell.h"
#import "WeatherIconManager.h"

@interface WeatherCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *summary;

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;


@property (weak, nonatomic) IBOutlet UILabel *humidityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *temperatureIndicator;

@property (weak, nonatomic) IBOutlet UILabel *cloudCoverIndicator;
@property (weak, nonatomic) IBOutlet UILabel *precipitationIndicator;


@property (weak, nonatomic) IBOutlet UILabel *windSpeedIndicator;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@end

@implementation WeatherCollectionCell

@synthesize humidity = _humidity;
@synthesize windSpeed = _windSpeed;
@synthesize temperature = _temperature;
@synthesize  weatherIconName = _weatherIconName;
@synthesize  precipitation = _precipitation;
@synthesize cloudCover = _cloudCover;
@synthesize date = _date;
@synthesize summaryText = _summaryText;


-(void)setSummaryText:(NSString *)summaryText{
    
    _summaryText = summaryText;
    
    [self.summary setText:summaryText];
    
}

-(NSString *)summaryText{
    return _summaryText;
}

-(void)setDate:(NSDate *)date{
    
    _date = date;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    [self.dateLabel setText:dateString];
}

-(NSDate *)date{
    return _date;
}


-(double)cloudCover{
    return _cloudCover;
}

-(void)setCloudCover:(double)cloudCover{
    
    _cloudCover = cloudCover*100;
    
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* cloudCoverFormatter = [[NSNumberFormatter alloc] init];
    [cloudCoverFormatter setMinimumFractionDigits:0];
    [cloudCoverFormatter setMaximumFractionDigits:0];
    [cloudCoverFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* cloudCoverNumberString = [cloudCoverFormatter stringFromNumber:[NSNumber numberWithDouble:cloudCover]];
    NSString* cloudCoverString = [NSString stringWithFormat:@"Percent Cloud Cover: %@",cloudCoverNumberString];
    [self.cloudCoverIndicator setText:cloudCoverString];

}



-(void)setPrecipitation:(double)precipitation{
    
    _precipitation = precipitation;
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* precipitationFormatter = [[NSNumberFormatter alloc] init];
    [precipitationFormatter setMaximumFractionDigits:1];
    [precipitationFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* precipitationNumberString = [precipitationFormatter stringFromNumber:[NSNumber numberWithDouble:precipitation]];
    NSString* precipitationString = [NSString stringWithFormat:@"%@ inches",precipitationNumberString];
    [self.precipitationIndicator setText:precipitationString];
}

-(double)precipitation{
    return _precipitation;
}

-(void)setWeatherIconName:(NSString *)weatherIconName{
    
    
    UIImage* weatherIcon = [WeatherIconManager getWeatherIconForFilePath:weatherIconName];
    
    if(weatherIcon){
        [self.weatherIcon setImage:weatherIcon];
        _weatherIconName = weatherIconName;

    } else{
        _weatherIconName = @"clearB";
        [self.weatherIcon setImage:[UIImage imageNamed:@"clearB"]];

    }
    
}

-(NSString *)weatherIconName{
    return _weatherIconName;
}


-(void)setTemperature:(double)temperature{
    
    _temperature = temperature;
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* temperatureFormatter = [[NSNumberFormatter alloc] init];
    [temperatureFormatter setMaximumFractionDigits:1];
    [temperatureFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* temperatureNumberString = [temperatureFormatter stringFromNumber:[NSNumber numberWithDouble:temperature]];
    NSString* temperatureString = [NSString stringWithFormat:@"%@ °C",temperatureNumberString];
    [self.temperatureIndicator setText:temperatureString];
}


-(double)temperature{
    return _temperature;
}


-(double)humidity{
    return _humidity;
}

-(void)setHumidity:(double)humidity{
    
    _humidity = humidity;

    /** Configure number formatter for humidity **/
    NSNumberFormatter* humidityFormatter = [[NSNumberFormatter alloc] init];
    [humidityFormatter setMinimumFractionDigits:2];
    [humidityFormatter setMaximumFractionDigits:2];
    [humidityFormatter setMaximumIntegerDigits:1];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* humidityNumberString = [humidityFormatter stringFromNumber:[NSNumber numberWithDouble:humidity]];
    NSString* humidityString = [NSString stringWithFormat:@"Humidity: %@",humidityNumberString];
    [self.humidityIndicator setText:humidityString];
}

-(void)setWindSpeed:(double)windSpeed{
    
    _windSpeed = windSpeed;
    
    /** Configure number formatter for humidity **/
    NSNumberFormatter* windSpeedFormatter = [[NSNumberFormatter alloc] init];
    [windSpeedFormatter setMaximumFractionDigits:1];
    [windSpeedFormatter setMaximumIntegerDigits:2];
    
    /** Get string representation of humidity and set the text value for the label **/
    NSString* windSpeedNumberString = [windSpeedFormatter stringFromNumber:[NSNumber numberWithDouble:windSpeed]];
    NSString* windSpeedString = [NSString stringWithFormat:@"Wind Speed(mph): %@",windSpeedNumberString];
    [self.windSpeedIndicator setText:windSpeedString];
    
    
}

-(double)windSpeed{
    
    return _windSpeed;
}

@end
