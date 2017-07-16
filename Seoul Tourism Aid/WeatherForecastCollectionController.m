//
//  WeatherForecastCollectionController.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/28/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecastCollectionController.h"
#import "WeatherDisplayController.h"

@interface WeatherForecastCollectionController ()

@end

@implementation WeatherForecastCollectionController


-(void)viewDidLoad{
    
    WeatherDisplayController* __weak weatherDisplayController = (WeatherDisplayController*)(self.parentViewController);
    
    [self.collectionView setDataSource:weatherDisplayController];
    [self.collectionView setDelegate:weatherDisplayController];
    
}

-(void)didReceiveMemoryWarning{
    
    
}

@end
