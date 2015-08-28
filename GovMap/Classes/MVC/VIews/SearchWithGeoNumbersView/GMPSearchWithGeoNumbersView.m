//
//  GMPSearchWithGeoNumbersView.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithGeoNumbersView.h"
#import "UIView+MakeFromXib.h"
#import "UIView+Shaking.h"

static NSString *const kDefaultLatitudeTextFieldString = @"Latitude";
static NSString *const kDefaultLongitudeTextFieldString = @"Longitude";
static NSString *const kAcceptableCharacters = @"0123456789.";

@interface GMPSearchWithGeoNumbersView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation GMPSearchWithGeoNumbersView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _containerView = [[self class] makeFromXibWithFileOwner:self];
        _containerView.frame = self.frame;
        [self addSubview:_containerView];
        
        _latitudeTextField.delegate = self;
        _longitudeTextField.delegate = self;
        
        _tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(dismissKeyboard)];
        
        [self addGestureRecognizer:_tap];
    }
    return self;
}

#pragma mark - Responder

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAcceptableCharacters] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL isEqual = [string isEqualToString:filtered];
    return isEqual;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:kDefaultLongitudeTextFieldString] ||
        [textField.text isEqualToString:kDefaultLatitudeTextFieldString]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        switch (textField.tag) {
            case 0:
                textField.text = kDefaultLongitudeTextFieldString;
                break;
                
            case 1:
                textField.text = kDefaultLatitudeTextFieldString;
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Actions

- (IBAction)searchButtonPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchWithGeoNumbersView:didPressSearchButtonWithGeoNumbers:)]) {
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
            [self.delegate searchWithGeoNumbersView:self
                 didPressSearchButtonWithGeoNumbers:@{@"latitude" : latitude, @"longitude" : longitude}];
        }
    }
}

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

@end
