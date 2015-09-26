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
static NSString *const kSelectedIndex = @"SelectedIndex";

@implementation GMPAppLanguageSwitchController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *ar = [[NSUserDefaults standardUserDefaults]valueForKey:kAppleLanguages];
    if ([ar.firstObject isEqualToString:@"en"]) {
        self.appLanguageSegmentControl.selectedSegmentIndex = 0;
    } else {
        self.appLanguageSegmentControl.selectedSegmentIndex = 1;
    }
}


#pragma mark - Actions

- (IBAction)appLanguageChanged:(id)sender
{
    if (self.appLanguageSegmentControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey: kAppleLanguages];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kSelectedIndex];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"he", nil] forKey: kAppleLanguages];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:kSelectedIndex];
    }
    [GMPAlertService showInfoAlertControllerWithTitle:LOCALIZED(@"") andMessage:LOCALIZED(@"Setting will take effect after restarting application") forController:self withCompletion:nil];
}

@end
