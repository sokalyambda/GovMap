//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressView.h"
#import "GMPSearchTextField.h"

#import "UIView+MakeFromXib.h"
#import "UIView+Shaking.h"

NSString *const kCity = @"City";
NSString *const kStreet = @"Street";
NSString *const kHome = @"Home";

@interface GMPSearchWithAddressView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet GMPSearchTextField *cityTextField;
@property (weak, nonatomic) IBOutlet GMPSearchTextField *streetTextField;
@property (weak, nonatomic) IBOutlet GMPSearchTextField *homeTextField;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation GMPSearchWithAddressView

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _containerView = [[self class] makeFromXibWithFileOwner:self];
        _containerView.frame = self.frame;
        [self addSubview:_containerView];
    }
    return self;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.cityTextField isFirstResponder]) {
        [self.streetTextField becomeFirstResponder];
    } else if ([self.streetTextField isFirstResponder]) {
        [self.homeTextField becomeFirstResponder];
    } else if ([self.homeTextField isFirstResponder]) {
        [self.homeTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)searchButtonPress:(id)sender
{
    [self performSearchAction];
}

/**
 *  Validate text fields and call the delegate method
 */
- (void)performSearchAction
{
    BOOL areValuesValidated = YES;
    
    if (!self.cityTextField.text.length) {
        [self.cityTextField shakeView];
        areValuesValidated = NO;
    }
    if (!self.streetTextField.text.length) {
        [self.streetTextField shakeView];
        areValuesValidated = NO;
    }
    if (!self.homeTextField.text.length) {
        [self.homeTextField shakeView];
        areValuesValidated = NO;
    }
    
    if (areValuesValidated) {
        if ([self.delegate respondsToSelector:@selector(searchWithAddressView:didPressSearchButtonWithAddress:)]) {
            [self.delegate searchWithAddressView:self
                 didPressSearchButtonWithAddress:@{ kCity : self.cityTextField.text,
                                                    kStreet : self.streetTextField.text,
                                                    kHome : self.homeTextField.text }];
        }
    }
}

@end
