//
//  YouTubeCreditsController.m
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 8/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTubeCreditsController.h"
#import "UIViewController+HelperMethods.h"

@interface YouTubeCreditsController ()


- (IBAction)getMarkWiensYouTubeChannel:(UIButton *)sender;

- (IBAction)getMarkWiensInstagram:(UIButton *)sender;

- (IBAction)getMarkWiensBlogStore:(UIButton *)sender;




- (IBAction)getGrrlTravelerInstagram:(UIButton *)sender;

- (IBAction)getGrrlTravelerYouTubeChannel:(UIButton *)sender;


- (IBAction)getGrrlTravelerBlog:(UIButton *)sender;



- (IBAction)getSelinasInspirationYouTubeChannel:(id)sender;

- (IBAction)getSelinasInstagram:(UIButton *)sender;

- (IBAction)getSelinasBlog:(UIButton *)sender;


@end


@implementation YouTubeCreditsController


static NSString* const MARK_WIENS_YOUTUBE_ADDRESS = @"https://www.youtube.com/user/migrationology";

static NSString* const MARK_WIENS_INSTAGRAM_ADDRESS = @"https://www.instagram.com/migrationology/";


static NSString* const MARK_WIENS_STORE_ADDRESS =
@"https://migrationology.com/store/";


static NSString* const GRRRL_TRAVELER_BLOG_ADDRESS = @"http://grrrltraveler.com";

static NSString* const GRRRL_TRAVELER_YOUTUBE_ADDRESS = @"https://www.youtube.com/user/ckaaloa";

static NSString* const GRRRL_TRAVELER_INSTAGRAM_ADDRESS = @"https://www.instagram.com/grrrltraveler/";

static NSString* const SELINAS_YOUTUBE_ADDRESS = @"https://www.youtube.com/channel/UCNed1tZzzlaqcg-dPzmZN6Q";

static NSString* const SELINAS_INSTAGRAM_ADDRESS = @"https://www.instagram.com/selinasinspiration/";


static NSString* const SELINAS_BLOG_ADDRESS = @"http://www.selinasinspiration.com/";


-(void)viewDidLoad{
    
}

- (IBAction)getMarkWiensYouTubeChannel:(UIButton *)sender {
    NSLog(@"Loading site...");
    [self loadWebsiteWithURLAddress:MARK_WIENS_YOUTUBE_ADDRESS];

}

- (IBAction)getMarkWiensInstagram:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:MARK_WIENS_INSTAGRAM_ADDRESS];
}

- (IBAction)getMarkWiensBlogStore:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:MARK_WIENS_STORE_ADDRESS];
}

- (IBAction)getGrrlTravelerInstagram:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:GRRRL_TRAVELER_INSTAGRAM_ADDRESS];
}

- (IBAction)getGrrlTravelerYouTubeChannel:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:GRRRL_TRAVELER_YOUTUBE_ADDRESS];
}

- (IBAction)getGrrlTravelerBlog:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:GRRRL_TRAVELER_BLOG_ADDRESS];



}

- (IBAction)getSelinasInspirationYouTubeChannel:(id)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:SELINAS_YOUTUBE_ADDRESS];
}

- (IBAction)getSelinasInstagram:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:SELINAS_INSTAGRAM_ADDRESS];
}

- (IBAction)getSelinasBlog:(UIButton *)sender {
    NSLog(@"Loading site...");

    [self loadWebsiteWithURLAddress:SELINAS_BLOG_ADDRESS];
}
@end
