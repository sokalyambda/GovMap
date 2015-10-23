//
//  GMPAboutController.m
//  Relocate
//
//  Created by Pavlo on 10/22/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "GMPAboutController.h"

#import "GMPSerialViewsConstructor.h"

@interface GMPAboutController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation GMPAboutController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateVersionLabel];
}

#pragma mark - Actions

- (void)updateVersionLabel
{
    NSString *versionString = @"v. ";
    versionString = [versionString stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.versionLabel.text = versionString;
}

- (void)customizeNavigationItem
{
    self.navigationItem.title = LOCALIZED(@"About");
}

@end
