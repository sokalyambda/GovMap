//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressView.h"
#import "UIView+MakeFromXib.h"

static NSString *const kDefaultCityTextFieldString = @"City";
static NSString *const kDefaultStreetTextFieldString = @"Street";
static NSString *const kDefaultHomeTextFieldString = @"Home";

@interface GMPSearchWithAddressView () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UITextField *cityTextField;
@property (nonatomic, weak) IBOutlet UITextField *streetTextField;
@property (nonatomic, weak) IBOutlet UITextField *homeTextField;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

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

- (void)searchButtonClick
{
    
}

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

@end
