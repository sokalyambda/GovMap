//
//  GMPSplashScreenController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSplashScreenController.h"
#import "GMPMainMenuController.h"

#import "GMPCommunicator.h"

static NSString *const kTermsAndConditionsSegueIdentifier = @"termsAndConditionsSegueIdentifier";

@interface GMPSplashScreenController ()

@property (assign, nonatomic, getter=isTermsAndConditionsPassed) BOOL termsAndConditionsPassed;

@end

@implementation GMPSplashScreenController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GMPCommunicator sharedInstance] loadContent];
    [self moveToNextController];
}

#pragma mark - Accessors

- (BOOL)isTermsAndConditionsPassed
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:kTermsAndConditionsPassed];
}

#pragma mark - Actions

- (void)moveToNextController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isTermsAndConditionsPassed) {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GMPMainMenuController class])] animated:YES];
        } else {
            [self performSegueWithIdentifier:kTermsAndConditionsSegueIdentifier sender:self];
        }
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
