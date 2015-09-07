//
//  GMPSplashScreenController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSplashScreenController.h"

static NSString *const kMainMenuSegueIdentifier = @"mainMenuSegueIdentifier";

@interface GMPSplashScreenController ()

@end

@implementation GMPSplashScreenController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self moveToMainMenu];
}

#pragma mark - Actions

- (void)moveToMainMenu
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:kMainMenuSegueIdentifier sender:self];
    });
}

- (void)customizeNavigationItem
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
