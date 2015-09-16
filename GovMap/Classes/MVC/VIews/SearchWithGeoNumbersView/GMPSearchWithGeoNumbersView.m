//
//  GMPSearchWithGeoNumbersView.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithGeoNumbersView.h"

#import "GMPCadastre.h"

#import "UIView+MakeFromXib.h"
#import "UIView+Shaking.h"

NSString *const kBlock = @"Block";
NSString *const kSubblock = @"Subblock";

static NSString *const kAcceptableCharacters = @"0123456789";

@interface GMPSearchWithGeoNumbersView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *blockTextField;
@property (weak, nonatomic) IBOutlet UITextField *subblockTextField;

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
    if ([self.blockTextField isFirstResponder]) {
        [self.subblockTextField becomeFirstResponder];
    } else if ([self.subblockTextField isFirstResponder]) {
        [self.subblockTextField resignFirstResponder];
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
    NSDecimalNumber *block = [NSDecimalNumber decimalNumberWithString:self.blockTextField.text];
    NSDecimalNumber *subblock = [NSDecimalNumber decimalNumberWithString:self.subblockTextField.text];
    
    BOOL areValuesValidated = YES;
    
    if ([block isEqualToNumber:[NSDecimalNumber notANumber]]) {
        [self.blockTextField shakeView];
        areValuesValidated = NO;
    }
    if ([subblock isEqualToNumber:[NSDecimalNumber notANumber]]) {
        [self.subblockTextField shakeView];
        areValuesValidated = NO;
    }
    
    if (areValuesValidated) {
        
        if ([self.delegate respondsToSelector:@selector(searchWithGeoNumbersView: didPressSearchButtonWithCadactralNumbers:)]) {
            
            [self.delegate searchWithGeoNumbersView:self
           didPressSearchButtonWithCadactralNumbers:[GMPCadastre cadastreWithMajor:[block integerValue] minor:[subblock integerValue]]];
        }
    }
}

@end
