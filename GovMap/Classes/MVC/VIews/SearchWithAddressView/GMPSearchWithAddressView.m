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

static NSString *const kDefaultCityTextFieldString = @"City";
static NSString *const kDefaultStreetTextFieldString = @"Street";
static NSString *const kDefaultHomeTextFieldString = @"Home";

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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        switch (textField.tag) {
            case 0:
                textField.text = kDefaultCityTextFieldString;
                break;
                
            case 1:
                textField.text = kDefaultStreetTextFieldString;
                break;
                
            case 2:
                textField.text = kDefaultHomeTextFieldString;
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Actions

- (IBAction)searchButtonPress:(id)sender
{
    BOOL areValuesValidated = YES;
    
    if ([self.cityTextField.text isEqualToString:kDefaultCityTextFieldString]) {
        [self.cityTextField shakeView];
        areValuesValidated = NO;
    }
    if ([self.streetTextField.text isEqualToString:kDefaultStreetTextFieldString]) {
        [self.streetTextField shakeView];
        areValuesValidated = NO;
    }
    if ([self.homeTextField.text isEqualToString:kDefaultHomeTextFieldString]) {
        [self.homeTextField shakeView];
        areValuesValidated = NO;
    }
    
    if (areValuesValidated) {
        if ([self.delegate respondsToSelector:@selector(searchWithAddressView:didPressSearchButtonWithAddress:)]) {
            [self.delegate searchWithAddressView:self
                 didPressSearchButtonWithAddress:@{ @"city" : self.cityTextField.text,
                                                    @"street" : self.streetTextField.text,
                                                    @"home" : self.homeTextField.text }];
        }
    }
}

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

@end
