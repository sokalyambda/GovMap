//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressView.h"

#import "UIView+MakeFromXib.h"
#import "UIView+Shaking.h"

NSString *const kCity = @"City";
NSString *const kStreet = @"Street";
NSString *const kHome = @"Home";

@interface GMPSearchWithAddressView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTextField;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation GMPSearchWithAddressView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _containerView = [[self class] makeFromXibWithFileOwner:self];
        _containerView.frame = self.frame;
        [self addSubview:_containerView];
        
        _cityTextField.delegate = self;
        _streetTextField.delegate = self;
        _homeTextField.delegate = self;
        
        _tap = [[UITapGestureRecognizer alloc]
               initWithTarget:self
               action:@selector(dismissKeyboard)];
        
        [self addGestureRecognizer:_tap];
    }
    return self;
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

#pragma mark - Actions

- (IBAction)searchButtonPress:(id)sender
{
    BOOL areValuesValidated = YES;
    
    if (self.cityTextField.text.length == 0) {
        [self.cityTextField shakeView];
        areValuesValidated = NO;
    }
    if (self.streetTextField.text.length == 0) {
        [self.streetTextField shakeView];
        areValuesValidated = NO;
    }
    if (self.homeTextField.text.length == 0) {
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

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

@end
