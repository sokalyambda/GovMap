//
//  GMPWazeNavigationService.m
//  GovMap
//
//  Created by Eugenity on 31.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPWazeNavigationService.h"

static NSString *const kWazeURLPrefix = @"waze://";
static NSString *const kWazeAppStoreURL = @"http://itunes.apple.com/us/app/id323229106";

@implementation GMPWazeNavigationService

+ (void)navigateToWazeWithLatitude:(double)latitude
                  longitude:(double)longitude
{
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:kWazeURLPrefix]]) {
        // Waze is installed. Launch Waze and start navigation
        NSString *urlStr = [NSString stringWithFormat:@"%@?ll=%f,%f&navigate=yes", kWazeURLPrefix, latitude, longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        // Waze is not installed. Launch AppStore to install Waze app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWazeAppStoreURL]];
    }
}

@end
