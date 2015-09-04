//
//  GMPReachabilityService.m
//  Relocate
//
//  Created by Eugenity on 04.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPReachabilityService.h"

#import "Reachability.h"

@implementation GMPReachabilityService

#pragma mark - Lifecycle

+ (Reachability *)sharedReachability
{
    static Reachability *reachability = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    });
    
    return reachability;
}

/**
 *  Check internet reachability
 *
 *  @param success Success Block
 *  @param failure Failure Block
 */
+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)(NSError *error))failure
{
    BOOL isInternetAvaliable = [self isInternetAvaliable];
    if (isInternetAvaliable) {
        if (success) {
            success();
        }
    } else {
        NSError *internetError = [NSError errorWithDomain:@"" code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey: LOCALIZED(@"Internet is not reachable")}];
        if (failure) {
            failure(internetError);
        }
    }
}

/**
 *  Setup reachability notifier
 */
+ (void)setupReachabilityObserver
{
    [[self sharedReachability] startNotifier];
}

/**
 *  Checking for reachability
 *
 *  @return If internet is reachable - returns 'YES'
 */
+ (BOOL)isInternetAvaliable
{
    return [self sharedReachability].isReachable;
}

@end
