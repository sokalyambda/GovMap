//
//  AppDelegate.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "AppDelegate.h"

#import "GMPCommunicator.h"

#import "GMPLocationObserver.h"

static NSString *const kGoogleMapsAPIKey = @"AIzaSyCe5NsemBVFbuMYSUoxzi0qao7cKqiEECc";

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMPLocationObserver sharedInstance];
    
    [GMPReachabilityService setupReachabilityObserver];
    
    [[GMPCommunicator sharedInstance] loadContent];
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    return YES;
}

@end
