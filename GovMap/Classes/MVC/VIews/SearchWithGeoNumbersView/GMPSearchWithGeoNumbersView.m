//
//  GMPSearchWithGeoNumbersView.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithGeoNumbersView.h"
#import "GMPSearchTextField.h"

#import "UIView+MakeFromXib.h"
#import "UIView+Shaking.h"

NSString *const kLatitude = @"Latitude";
NSString *const kLongitude = @"Longitude";

static NSString *const kAcceptableCharacters = @"0123456789.";

@interface GMPSearchWithGeoNumbersView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet GMPSearchTextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet GMPSearchTextField *longitudeTextField;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation GMPSearchWithGeoNumbersView

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

#pragma mark - UIResponder

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.longitudeTextField isFirstResponder]) {
        [self.latitudeTextField becomeFirstResponder];
    } else if ([self.latitudeTextField isFirstResponder]) {
        [self.latitudeTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAcceptableCharacters] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL isEqual = [string isEqualToString:filtered];
    return isEqual;
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
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString:self.latitudeTextField.text];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString:self.longitudeTextField.text];
    
    BOOL areValuesValidated = YES;
    
    if ([latitude isEqualToNumber:[NSDecimalNumber notANumber]]) {
        [self.latitudeTextField shakeView];
        areValuesValidated = NO;
    }
    if ([longitude isEqualToNumber:[NSDecimalNumber notANumber]]) {
        [self.longitudeTextField shakeView];
        areValuesValidated = NO;
    }
    
    if (areValuesValidated) {
        if ([self.delegate respondsToSelector:@selector(searchWithGeoNumbersView:didPressSearchButtonWithGeoNumbers:)]) {
            [self.delegate searchWithGeoNumbersView:self
                 didPressSearchButtonWithGeoNumbers:@{ kLatitude : latitude, kLongitude : longitude }];
        }
    }
}

@end
