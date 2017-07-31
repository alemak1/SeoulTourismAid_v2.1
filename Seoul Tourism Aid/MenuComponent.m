//
//  MenuComponent.m
//  GDJHostel
//
//  Created by Aleksander Makedonski on 6/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


#import "MenuComponent.h"
#import <MapKit/MapKit.h>
#import <SpriteKit/SpriteKit.h>
#import "UIColor+HelperMethods.h"

@interface MenuComponent ()

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIImageView *backgroundView;


@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic,strong) SKView* planeSpriteView;

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) UITableView *optionsTableView;
@property (nonatomic, strong) NSArray *menuOptions;
@property (nonatomic, strong) NSArray *menuOptionImages;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic) MenuDirectionOptions menuDirection;
@property (nonatomic) CGRect menuFrame;
@property (nonatomic) CGRect menuInitialFrame;
@property (nonatomic) BOOL isMenuShown;

- (void)setupMenuView;
- (void)setupBackgroundView;
- (void)setupOptionsTableView;
- (void)setInitialTableViewSettings;
- (void)setupSwipeGestureRecognizer;

- (void)hideMenuWithGesture:(UISwipeGestureRecognizer *)gesture;

- (void)toggleMenu;

@property (nonatomic, strong) void(^selectionHandler)(NSInteger);


@end

@implementation MenuComponent

- (id)initMenuWithFrame:(CGRect)frame targetView:(UIView *)targetView direction:(MenuDirectionOptions)direction options:(NSArray *)options optionImages:(NSArray *)optionImages {
    if (self = [super init]) {
        self.menuFrame = frame;
        self.targetView = targetView;
        self.menuDirection = direction;
        self.menuOptions = options;
        self.menuOptionImages = optionImages;
        
        //Set initial background image as temporary transition in order to allow asynchronous loading of the map image
        [self setupBackgroundView];
        
        //Load the map image and cache the images for both portrait and landscape orientations
        [self loadMapSnaptIntoBackgroundView];
        [self preloadSnapshotForAlternateDeviceOrientation];
        
        // Setup the menu view.
        [self setupMenuView];
        
        // Setup the options table view.
        [self setupOptionsTableView];
        
        // Set the initial table view settings.
        [self setInitialTableViewSettings:[self.targetView traitCollection]];
        
        // Setup the swipe gesture recognizer.
        [self setupSwipeGestureRecognizer];
        
        // Initialize the animator.
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.targetView];
        
        // Set the initial height for each cell row.
        self.optionCellHeight = 50.0;
        
        // Set the initial acceleration value (push magnitude).
        self.acceleration = 15.0;
        
        // Indicate that initially the menu is not shown.
        self.isMenuShown = NO;
        
    }
    
    return self;
}


-(void) loadMapSnaptIntoBackgroundView{
    
    /**
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && self.cachedPortraitImage != nil){
        
        NSLog(@"Main image (portrait mode) has already been preloaded, aborting preload in the MenuComponent class initialization");
        
        return;
    }
    if(([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) && self.cachedLandscapeImage != nil){
        
         NSLog(@"Main image (landscape mode) has already been preloaded, aborting preload in the MenuComponent class initialization");
        
        return;
    }
    **/
    
    
    MKMapSnapshotOptions* snapShotOptions = [[MKMapSnapshotOptions alloc] init];
    
    [snapShotOptions setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.542103, 126.9433582), MKCoordinateSpanMake(10.0,10.0))];
    [snapShotOptions setMapType:MKMapTypeSatelliteFlyover];
    [snapShotOptions setShowsPointsOfInterest:NO];
    [snapShotOptions setSize:self.backgroundView.frame.size];
    
    MKMapSnapshotter* snapShotter = [[MKMapSnapshotter alloc] initWithOptions:snapShotOptions];
    
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot* snapShot, NSError* error){
        
        if(error){
            NSLog(@"Error: snapshotter object failed to capture map image with error: %@",[error localizedDescription]);
            return;
        }
        
        if(!snapShot){
            NSLog(@"Error: no shapshot available.");
            return;
        }
        
        self.backgroundView.image = [snapShot image];
        
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
            self.cachedPortraitImage = [snapShot image];
        }
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight){
            self.cachedLandscapeImage = [snapShot image];
        }
        
        
    }];
}

-(void)preloadSnapshotForAlternateDeviceOrientation{
    
    /**
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && self.cachedLandscapeImage != nil){
        
         NSLog(@"Alternate cached image (landscape mode for device in portrait orientation) has already been preloaded, aborting preload in the MenuComponent class initialization");
        
        return;
    }
    if(([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) && self.cachedPortraitImage != nil){
        
        NSLog(@"Alternate cached image (portrait mode for device in landscape orientation) has already been preloaded, aborting preload in the MenuComponent class initialization");

        return;
    }
    
    **/
    
    
    MKMapSnapshotOptions* snapShotOptions = [[MKMapSnapshotOptions alloc] init];
    
    CGFloat width = self.backgroundView.frame.size.height;
    CGFloat height = self.backgroundView.frame.size.width;
    CGSize alternateSize = CGSizeMake(width, height);
    
    [snapShotOptions setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.542103, 126.9433582), MKCoordinateSpanMake(10.0,10.0))];
    [snapShotOptions setMapType:MKMapTypeSatelliteFlyover];
    [snapShotOptions setShowsPointsOfInterest:NO];
    [snapShotOptions setSize:alternateSize];
    
    
    MKMapSnapshotter* snapShotter = [[MKMapSnapshotter alloc] initWithOptions:snapShotOptions];
    
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot* snapShot, NSError* error){
        
        if(error){
            NSLog(@"Error: snapshotter object failed to capture map image with error: %@",[error localizedDescription]);
            return;
        }
        
        if(!snapShot){
            NSLog(@"Error: no shapshot available.");
            return;
        }
        
        
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
            self.cachedLandscapeImage = [snapShot image];
        }
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight){
            self.cachedPortraitImage = [snapShot image];
        }
        
        
    }];
}

-(void)setupMenuView{
    if (self.menuDirection == menuDirectionLeftToRight) {
        self.menuInitialFrame = CGRectMake(-self.menuFrame.size.width+20,
                                           self.menuFrame.origin.y,
                                           self.menuFrame.size.width,
                                           self.menuFrame.size.height);
    }
    else{
        self.menuInitialFrame = CGRectMake(self.targetView.frame.size.width-20,
                                           self.menuFrame.origin.y,
                                           self.menuFrame.size.width,
                                           self.menuFrame.size.height);
    }
    
    self.menuView = [[UIView alloc] initWithFrame:self.menuInitialFrame];
    [self.menuView setBackgroundColor:[UIColor skyBlueColor]];
    [self.targetView addSubview:self.menuView];
    
   
    
}


-(void)setupBackgroundView{
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.targetView.frame];
    
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /**
    UIImage* backgroundImage = [UIImage imageNamed:@"north_seoul_tower"];
    
    
    self.backgroundView.image =  backgroundImage;
     **/
    
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundView setAlpha:1.0];
    [self.targetView addSubview:self.backgroundView];
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:[[self.backgroundView topAnchor] constraintEqualToAnchor:[self.targetView topAnchor]],[[self.backgroundView rightAnchor] constraintEqualToAnchor:[self.targetView rightAnchor]],[[self.backgroundView leftAnchor] constraintEqualToAnchor:[self.targetView leftAnchor]],[[self.backgroundView bottomAnchor] constraintEqualToAnchor:[self.targetView bottomAnchor]], nil]];
    
    CGFloat bgWidth = CGRectGetWidth(self.backgroundView.frame);
    CGFloat bgHeight = CGRectGetHeight(self.backgroundView.frame);
    
    CGRect labelFrame = CGRectMake(bgWidth*0.10, bgHeight*0.001, bgWidth*0.80, bgHeight*.40);
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
    titleLabel.text = @"Start using Seoul Tourism Aid. Swipe from the right...";
    titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:30.0];
    titleLabel.textColor = [UIColor koreanRed];
    titleLabel.shadowColor = [UIColor koreanBlue];
    titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth = true;
    [self.backgroundView addSubview:titleLabel];
    
    /** Display the local time in Korea **/
    CGRect timeLabelFrame = CGRectMake(bgWidth*0.10, bgHeight*0.80, bgWidth*0.80, bgHeight*0.20);
    
    UILabel* timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
    
    NSDate* today = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    NSString* localDateString = [dateFormatter stringFromDate:today];
    
    [timeLabel setText:localDateString];
    [timeLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:30.0]];
    [timeLabel setTextColor:[UIColor koreanRed]];
    [timeLabel setNumberOfLines:1];
    [timeLabel setAdjustsFontSizeToFitWidth:YES];
    [timeLabel setMinimumScaleFactor:0.50];
    [self.backgroundView addSubview:timeLabel];
    
}

-(void)setupOptionsTableView{
    
    CGFloat menuFrameWidth = CGRectGetWidth(self.menuFrame);
    CGFloat menuFrameHeight = CGRectGetHeight(self.menuFrame);
    
    self.optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(menuFrameWidth*0.01, menuFrameHeight*0.55, self.menuFrame.size.width, self.menuFrame.size.height*0.50) style:UITableViewStylePlain];
    [self.optionsTableView setBackgroundColor:[UIColor clearColor]];
    [self.optionsTableView setScrollEnabled:NO];
    [self.optionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.menuView addSubview:self.optionsTableView];
    
    CGRect logoFrame = CGRectMake(menuFrameWidth*0.17, menuFrameHeight*0.01, menuFrameWidth*0.05, menuFrameHeight*0.05);
    

    
    [self.optionsTableView setDelegate:self];
    [self.optionsTableView setDataSource:self];
    
    self.planeSpriteView = [[SKView alloc] initWithFrame:logoFrame];
    
    SKScene* planeScene = [[SKScene alloc] initWithSize:self.planeSpriteView.bounds.size];
   
    
    [self configurePlaneScene:planeScene];
    
    [self.menuView addSubview: self.planeSpriteView];
    [ self.planeSpriteView presentScene:planeScene];

    
    
}

-(void)resetMenuView:(UITraitCollection*)newTraitCollection{
    
    
    NSLog(@"Resetting the menu view in response to device orientation change....");
    
    
    [self.menuView removeFromSuperview];
    self.menuView = nil;
    
    //Set up the menu view again
    [self setupMenuView];
    
    // Setup the options table view.
    [self resetOptionsTableView:[self.targetView traitCollection]];
    
    // Set the initial table view settings.    
    [self setInitialTableViewSettings:[self.targetView traitCollection]];
    
    // Setup the swipe gesture recognizer.
    [self setupSwipeGestureRecognizer];
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.targetView];
    
    // Set the initial height for each cell row.
    UIUserInterfaceSizeClass horizontalSC = [newTraitCollection horizontalSizeClass];
    UIUserInterfaceSizeClass verticalSC = [newTraitCollection verticalSizeClass];
    
    BOOL CW_CH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassCompact);
    
    BOOL RW_CH = (horizontalSC == UIUserInterfaceSizeClassRegular && verticalSC == UIUserInterfaceSizeClassCompact);
    
    self.optionCellHeight = 40.0;
    

    if(CW_CH){
        self.optionCellHeight = 25.0;

    }
    
    if(RW_CH){
        self.optionCellHeight = 33.0;

    }
    
    // Set the initial acceleration value (push magnitude).
    self.acceleration = 15.0;
    
    // Indicate that initially the menu is not shown.
    self.isMenuShown = NO;

    

}

-(void)resetOptionsTableView:(UITraitCollection*)newTraitCollection{
    
    NSLog(@"Resetting the options table view...");
   
    //Remove the options table view from the superview
    [self.optionsTableView removeFromSuperview];
    [self.logoImageView removeFromSuperview];
    
    self.optionsTableView = nil;
    self.logoImageView = nil;
    
    UIUserInterfaceSizeClass horizontalSC = [newTraitCollection horizontalSizeClass];
    UIUserInterfaceSizeClass verticalSC = [newTraitCollection verticalSizeClass];
    
    BOOL CW_CH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassCompact);
    
    BOOL CW_RH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassRegular);
    
    BOOL RW_CH = (horizontalSC == UIUserInterfaceSizeClassRegular && verticalSC == UIUserInterfaceSizeClassCompact);
    
    CGFloat menuFrameWidth = CGRectGetWidth(self.menuFrame);
    CGFloat menuFrameHeight = CGRectGetHeight(self.menuFrame);
    
    self.optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(menuFrameWidth*0.01, menuFrameHeight*0.20, self.menuFrame.size.width, self.menuFrame.size.height*0.80) style:UITableViewStylePlain];
    
    CGRect logoFrame = CGRectMake(menuFrameWidth*0.25, menuFrameHeight*0.02, menuFrameWidth*0.35, menuFrameHeight*0.15);
    
    [self.optionsTableView setScrollEnabled:YES];
    [self.optionsTableView setDirectionalLockEnabled:YES];
    [self.optionsTableView setAlwaysBounceHorizontal:NO];

    if(CW_CH){
        self.optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(menuFrameWidth*0.01, menuFrameHeight*0.01, self.menuFrame.size.width, menuFrameHeight) style:UITableViewStylePlain];
        
        [self.optionsTableView setScrollEnabled:YES];
        [self.optionsTableView setContentInset:UIEdgeInsetsMake(20, 0, 50, 0)];
        [self.optionsTableView setAlwaysBounceHorizontal:NO];
        [self.optionsTableView setScrollsToTop:NO];
        [self.optionsTableView setDirectionalLockEnabled:YES];

        [self.optionsTableView setContentSize:CGSizeMake(self.menuFrame.size.width, 1500)];
        

    }
    
    if(CW_RH){
        //Not yet implemented
        self.planeSpriteView = [[SKView alloc] initWithFrame:logoFrame];
        
        SKScene* planeScene = [[SKScene alloc] initWithSize:logoFrame.size];
        
        [self configurePlaneScene:planeScene];
        
        
        [self.menuView addSubview:self.planeSpriteView];
        
        [ self.planeSpriteView presentScene:planeScene];
        
        
    }
    
    if(RW_CH){
        self.optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(menuFrameWidth*0.01, menuFrameHeight*0.01, self.menuFrame.size.width, menuFrameHeight) style:UITableViewStylePlain];
        
        
        [self.optionsTableView setContentSize:CGSizeMake(self.menuFrame.size.width, 1500)];
        
        [self.optionsTableView setScrollEnabled:YES];
        [self.optionsTableView setAlwaysBounceHorizontal:NO];
        [self.optionsTableView setContentInset:UIEdgeInsetsMake(20, 0, 50, 0)];
        [self.optionsTableView setScrollsToTop:YES];
        
        [self.optionsTableView setContentSize:CGSizeMake(self.menuFrame.size.width, 1500)];


    }

    
    [self.optionsTableView setBackgroundColor:[UIColor clearColor]];
    [self.optionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.menuView addSubview:self.optionsTableView];
    
    
    
    
    [self.optionsTableView setDelegate:self];
    [self.optionsTableView setDataSource:self];
    
    
}



- (void)setInitialTableViewSettings:(UITraitCollection*)newTraitCollection {
    self.tableSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          [UIFont fontWithName:@"Futura-CondensedMedium" size:30.0], @"font",
            [NSNumber numberWithInt:NSTextAlignmentLeft], @"textAlignment",
            [UIColor koreanBlue], @"textColor",
            [NSNumber numberWithInt:UITableViewCellSelectionStyleGray], @"selectionStyle",
                          nil];
    
    UIUserInterfaceSizeClass horizontalSC = [newTraitCollection horizontalSizeClass];
    UIUserInterfaceSizeClass verticalSC = [newTraitCollection verticalSizeClass];
    
    BOOL CW_CH = (horizontalSC == UIUserInterfaceSizeClassCompact && verticalSC == UIUserInterfaceSizeClassCompact);
    
    BOOL RW_CH = (horizontalSC == UIUserInterfaceSizeClassRegular && verticalSC == UIUserInterfaceSizeClassCompact);
    
    if(CW_CH){
        self.tableSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            [UIFont fontWithName:@"Futura-CondensedMedium" size:20.0], @"font",
            [NSNumber numberWithInt:NSTextAlignmentLeft], @"textAlignment",
            [UIColor koreanBlue], @"textColor",
            [NSNumber numberWithInt:UITableViewCellSelectionStyleGray], @"selectionStyle",
                              nil];
    }
    
    
    if(RW_CH){
        self.tableSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              [UIFont fontWithName:@"Futura-CondensedMedium" size:20.0], @"font",
                              [NSNumber numberWithInt:NSTextAlignmentLeft], @"textAlignment",
                              [UIColor koreanBlue], @"textColor",
                              [NSNumber numberWithInt:UITableViewCellSelectionStyleGray], @"selectionStyle",
                              nil];
    }
}


-(void)setupSwipeGestureRecognizer{
    UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuWithGesture:)];
    if (self.menuDirection == menuDirectionLeftToRight) {
        hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    else{
        hideMenuGesture.direction = UISwipeGestureRecognizerDirectionRight;
    }
    [self.menuView addGestureRecognizer:hideMenuGesture];
}

- (void)toggleMenu{
    // Remove any previous behaviors added to the animator.
    [self.animator removeAllBehaviors];
    
    // The following variables will define the direction of the menu view animation.
    
    // This variable indicates the gravity direction.
    CGFloat gravityDirectionX;
    
    // These two points specify an invisible boundary where the menu view should collide.
    // The boundary must be always to the side of the gravity direction so as the menu view
    // can stop moving.
    CGPoint collisionPointFrom, collisionPointTo;
    
    // The higher the push magnitude value, the greater the acceleration of the menu view.
    // If that value is set to 0.0, then only the gravity force will be applied to the
    // menu view.
    CGFloat pushMagnitude = self.acceleration;
    
    // Check if the menu is shown or not.
    if (!self.isMenuShown) {
        // If the menu view is hidden and it's about to be shown, then specify each variable
        // value depending on the animation direction.
        if (self.menuDirection == menuDirectionLeftToRight) {
            // The value 1.0 means that gravity "moves" the view towards the right side.
            gravityDirectionX = 1.0;
            
            // The From and To points define an invisible boundary, where the X-origin point
            // equals to the desired X-origin point that the menu view should collide, and the
            // Y-origin points specify the highest and lowest point of the boundary.
            
            // If the menu view is being shown from left to right, then the collision boundary
            // should be defined so as to be at the right of the initial menu view position.
            collisionPointFrom = CGPointMake(self.menuFrame.size.width-20, self.menuFrame.origin.y);
            collisionPointTo = CGPointMake(self.menuFrame.size.width-20, self.menuFrame.size.height);
        }
        else{
            // The value -1.0 means that gravity "pulls" the view towards the left side.
            gravityDirectionX = -1.0;
            
            // If the menu view is being shown from right to left, then the collision boundary
            // should be defined so as to be at the left of the initial menu view position.
            collisionPointFrom = CGPointMake(self.targetView.frame.size.width - self.menuFrame.size.width+20, self.menuFrame.origin.y);
            collisionPointTo = CGPointMake(self.targetView.frame.size.width - self.menuFrame.size.width+20, self.menuFrame.size.height);
            
            // Set to the pushMagnitude variable the opposite value.
            pushMagnitude = (-1) * pushMagnitude;
        }
        
        // Make the background view semi-transparent.
        [self.backgroundView setAlpha:0.25];
    }
    else{
        // In case the menu is about to be hidden, then the exact opposite values should be
        // set to all variables for succeeding the opposite animation.
        
        if (self.menuDirection == menuDirectionLeftToRight) {
            gravityDirectionX = -1.0;
            collisionPointFrom = CGPointMake(-self.menuFrame.size.width+20, self.menuFrame.origin.y);
            collisionPointTo = CGPointMake(-self.menuFrame.size.width+20, self.menuFrame.size.height);
            
            // Set to the pushMagnitude variable the opposite value.
            pushMagnitude = (-1) * pushMagnitude;
        }
        else{
            gravityDirectionX = 1.0;
            collisionPointFrom = CGPointMake(self.targetView.frame.size.width + self.menuFrame.size.width-20, self.menuFrame.origin.y);
            collisionPointTo = CGPointMake(self.targetView.frame.size.width + self.menuFrame.size.width-20, self.menuFrame.size.height);
        }
        
        // Make the background view fully transparent.
        [self.backgroundView setAlpha:1.0];
    }
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    [gravityBehavior setGravityDirection:CGVectorMake(gravityDirectionX, 0.0)];
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    [collisionBehavior addBoundaryWithIdentifier:@"collisionBoundary"
                                       fromPoint:collisionPointFrom
                                         toPoint:collisionPointTo];
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.menuView]];
    [itemBehavior setElasticity:0.35];
    [self.animator addBehavior:itemBehavior];
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView] mode:UIPushBehaviorModeInstantaneous];
    [pushBehavior setMagnitude:pushMagnitude];
    [self.animator addBehavior:pushBehavior];
}

- (void)showMenuWithSelectionHandler:(void (^)(NSInteger))handler {
    if (!self.isMenuShown) {
        self.selectionHandler = handler;
        
        [self toggleMenu];
        
        self.isMenuShown = YES;
    }
}

- (void)hideMenuWithGesture:(UISwipeGestureRecognizer *)gesture {
    // Make a call to toggleMenu method for hiding the menu.
    [self toggleMenu];
    
    // Indicate that the menu is not shown.
    self.isMenuShown = NO;
}


-(void)configurePlaneScene:(SKScene*)planeScene{
    
    [planeScene setAnchorPoint:CGPointMake(0.5, 0.5)];
    [planeScene setBackgroundColor:[UIColor skyBlueColor]];
    SKTexture* planeTexture = [SKTexture textureWithImageNamed:@"planeYellow1"];
    SKSpriteNode* planeSprite = [[SKSpriteNode alloc] initWithTexture:planeTexture];
    
    [planeSprite setAnchorPoint:CGPointMake(0.5, 0.5)];
    [planeSprite setPosition:CGPointMake(0.0, 0.0)];
    [planeSprite setZPosition:0.00];
    
    SKAction* flightAction = [SKAction animateWithTextures:[NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"planeYellow1"],[SKTexture textureWithImageNamed:@"planeYellow2"],[SKTexture textureWithImageNamed:@"planeYellow3"], nil] timePerFrame:0.20];
    
    SKAction* repeatingFlight = [SKAction repeatActionForever:flightAction];
    
    [planeSprite runAction:repeatingFlight];
    
    [planeScene addChild:planeSprite];
    
    SKSpriteNode* cloudSprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cloud1"]];
    [cloudSprite setAnchorPoint:CGPointMake(0.5, 0.5)];
    [cloudSprite setPosition:CGPointMake(0.0, -10)];
    [cloudSprite setZPosition:-5];
    [cloudSprite setScale:0.5];
    [planeScene addChild:cloudSprite];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuOptions count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.optionCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optionCell"];
    }
    
    // Set the selection style.
    [cell setSelectionStyle:[[self.tableSettings objectForKey:@"selectionStyle"] intValue]];
    
    // Set the cell's text and specify various properties of it.
    cell.textLabel.text = [self.menuOptions objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[self.tableSettings objectForKey:@"font"]];
    [cell.textLabel setTextAlignment:[[self.tableSettings objectForKey:@"textAlignment"] intValue]];
    [cell.textLabel setTextColor:[self.tableSettings objectForKey:@"textColor"]];
    
    // If the menu option images array is not nil, then set the cell image.
    if (self.menuOptionImages != nil) {
        [cell.imageView setImage:[UIImage imageNamed:[self.menuOptionImages objectAtIndex:indexPath.row]]];
        [cell.imageView setTintColor:[UIColor whiteColor]];
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    if (self.selectionHandler) {
        self.selectionHandler(indexPath.row);
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

@end
