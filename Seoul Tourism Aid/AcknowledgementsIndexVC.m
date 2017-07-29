//
//  AcknowledgementsIndexVC.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcknowledgementsIndexVC.h"
#import "UIViewController+HelperMethods.h"

@interface AcknowledgementsIndexVC ()

- (IBAction)loadFlaticonWebsite:(UIButton *)sender;

- (IBAction)loadKenneyGraphicsWebsite:(UIButton *)sender;

- (IBAction)loadKoreaTourismWebsite:(UIButton *)sender;


- (IBAction)loadFlaticonHomepage:(UIButton *)sender;



@end



@implementation AcknowledgementsIndexVC

-(void)viewDidLoad{
    
    
}


- (IBAction)loadFlaticonWebsite:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://www.flaticon.com"];

}

- (IBAction)loadKenneyGraphicsWebsite:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://kenney.itch.io/"];
    
}

- (IBAction)loadKoreaTourismWebsite:(UIButton *)sender {
    
    [self loadWebsiteWithURLAddress:@"https://www.imagineyourkorea.com/main.php"];

}

-(IBAction)unwindToAcknowledgementsSection:(UIStoryboardSegue*)segue{
    
}


- (IBAction)loadFlaticonHomepage:(UIButton *)sender {
    [self loadWebsiteWithURLAddress:@"https://www.flaticon.com"];

}
@end
