//
//  GooglePlaceCell.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/2/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlaceCell.h"
#import "UserLocationManager.h"

@interface GooglePlaceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *openNowStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (IBAction)getDirectionsToGooglePlace:(UIButton *)sender;

- (IBAction)getInfoForGooglePlace:(UIButton *)sender;

@end


@implementation GooglePlaceCell


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
       
        [self addObserver:self forKeyPath:@"googlePlace.firstImage" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        
        [self addObserver:self forKeyPath:@"googlePlace.title" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        
        [self addObserver:self forKeyPath:@"googlePlace.openNowStatus" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];


    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"googlePlace.openNowStatus"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOpenNowStatusLabel];
        });
    }
    
    if([keyPath isEqualToString:@"googlePlace.firstImage"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImageView];
        });
    }
    
    if([keyPath isEqualToString:@"googlePlace.title"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateTitleLabel];
        });
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"googlePlace.openNowStatus"];
    [self removeObserver:self forKeyPath:@"googlePlace.firstImage"];
    [self removeObserver:self forKeyPath:@"googlePlace.title"];


    
}

-(void)layoutSubviews{
    
    [self updateCellUI];
}

-(void)didMoveToSuperview{
    [self updateCellUI];
}

-(void)updateCellUI{
    
    [self updateImageView];
    
    [self updateTitleLabel];
    
    [self updateOpenNowStatusLabel];
    
    [self updateDistanceLabel];

}

-(void)updateImageView{
    if(self.googlePlace.firstImage){
        [self.imageView setImage:self.googlePlace.firstImage];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

-(void)updateTitleLabel{
    if(self.googlePlace.title){
        
        [self.titleLabel setText:self.googlePlace.title];
        
    } else if(self.googlePlace.name){
        
        [self.titleLabel setText:self.googlePlace.name];
        
    }
}

-(void)updateOpenNowStatusLabel{
    if(self.googlePlace.openNowStatus != kGMSPlacesOpenNowStatusUnknown){
        
        [self.openNowStatusLabel setText:self.googlePlace.isOpenNowText];
        
    } else if(self.googlePlace.phoneNumber) {
        
        [self.openNowStatusLabel setText:self.googlePlace.phoneNumber];
        
    } else {
        
        [self.openNowStatusLabel setHidden:YES];
        
    }
}

-(void)updateDistanceLabel{
    CLLocation* userLocation = [[UserLocationManager sharedLocationManager] getLastUpdatedUserLocation];
    
    CLLocationDistance distanceToSite = [userLocation distanceFromLocation:self.googlePlace.location];
    
    if(userLocation){
        [self.distanceLabel setText:[NSString stringWithFormat:@"Distance: %f",distanceToSite]];
    } else if(self.googlePlace.formattedAddress){
        
        [self.distanceLabel setText:self.googlePlace.formattedAddress];
        
    } else {
        
        [self.distanceLabel setHidden:YES];
        
    }
}

- (IBAction)getDirectionsToGooglePlace:(UIButton *)sender {
}

- (IBAction)getInfoForGooglePlace:(UIButton *)sender {
}
@end
