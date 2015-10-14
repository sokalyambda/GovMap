//
//  GMPTermsAndConditionsController.m
//  Relocate
//
//  Created by Myroslava Polovka on 10/14/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "GMPTermsAndConditionsController.h"

#import "GMPCheckBoxButton.h"
#import "GMPRoundedCornersButton.h"

static NSString * const kMainMenuSegueIdentifier = @"mainMenuSegueIdentifier";
NSString * const kTermsAndConditionsPassed       = @"termsAndConditionsPassed";

@interface GMPTermsAndConditionsController ()

@property (weak, nonatomic) IBOutlet GMPRoundedCornersButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet GMPCheckBoxButton *checkBoxButton;

@end

#pragma mark - View Lifecycle

@implementation GMPTermsAndConditionsController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)mainMenuButtonClick:(id)sender
{
    if (self.checkBoxButton.isSelected) {
        [self setTermsAndConditionsPassed];
        [self performSegueWithIdentifier:kMainMenuSegueIdentifier sender:self];
    } else {
        [self setCheckBoxButtonAnimation];
    }
}

#pragma mark - Private Methods

- (void)setTermsAndConditionsPassed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isTermsAndConditionsPassed = [defaults boolForKey:kTermsAndConditionsPassed];
    if (isTermsAndConditionsPassed) {
        return;
    } else {
        [defaults setBool:YES forKey:kTermsAndConditionsPassed];
        [defaults synchronize];
    }
}
- (void)setCheckBoxButtonAnimation
{
    [self.checkBoxButton setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
    [UIView animateWithDuration:0.2f animations:^{
        [self.checkBoxButton setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
        self.checkBoxButton.alpha = 1.f;
    }];
}

@end
