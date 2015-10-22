//
//  GMPAppLanguageSwitchController.m
//  Relocate
//
//  Created by Myroslava Polovka on 9/25/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPAppLanguageSwitchController.h"

#import "GMPAlertService.h"

static NSString *const kAppleLanguages = @"AppleLanguages";

@implementation GMPAppLanguageSwitchController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *ar = [[NSUserDefaults standardUserDefaults]valueForKey:kAppleLanguages];
    if ([ar.firstObject isEqualToString:@"en"]) {
        self.appLanguageSegmentControl.selectedSegmentIndex = 0;
    } else if ([ar.firstObject isEqualToString:@"he"]){
        self.appLanguageSegmentControl.selectedSegmentIndex = 1;
    } else {
        self.appLanguageSegmentControl.selectedSegmentIndex = -1;
    }
}

#pragma mark - Actions

- (IBAction)appLanguageChanged:(id)sender
{
    if (self.appLanguageSegmentControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey: kAppleLanguages];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"he", nil] forKey: kAppleLanguages];
    }
    [GMPAlertService showInfoAlertControllerWithTitle:LOCALIZED(@"") andMessage:LOCALIZED(@"Setting will take effect after restarting application") forController:self withCompletion:nil];
}

@end
