//
//  AppDelegate.h
//  Seoul Tourism Aid
//
//  Created by Aleksander Makedonski on 7/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <OIDAuthorizationService.h>
#import <OIDAuthState.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(nonatomic, strong, nullable)
id<OIDAuthorizationFlowSession> currentAuthorizationFlow;


@end

