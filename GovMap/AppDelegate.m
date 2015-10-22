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
    
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    // Disable RTL for navigation bars and segment controls in iOS 9
    if ([NSProcessInfo processInfo].operatingSystemVersion.majorVersion >= 9) {
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [[UISegmentedControl appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    return YES;
}

@end
