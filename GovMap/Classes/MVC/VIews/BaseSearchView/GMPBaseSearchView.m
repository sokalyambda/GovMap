//
//  GMPBaseSearchView.m
//  GovMap
//
//  Created by Pavlo on 9/1/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseSearchView.h"

#import "UIResponder+FirstResponder.h"

@interface GMPBaseSearchView ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (assign, readwrite, nonatomic) CGFloat additionalOffset;

@end

@implementation GMPBaseSearchView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _additionalOffset = self.bounds.size.height / 15;
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [self addGestureRecognizer:_tap];
    }
    return self;
}

#pragma mark - Public

- (void)subscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)dismissKeyboard
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

#pragma mark - Notificaion handlers

- (void)keyboardWillShow:(NSNotification*)notification
{    
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyBoardFrame = [self convertRect:keyBoardFrame fromView:nil];
    
    CGSize kbSize = keyBoardFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    UITextField *selectedTextField = [UIResponder currentFirstResponder];
    
    CGRect intersection = CGRectIntersection(keyBoardFrame, selectedTextField.frame);
    if (intersection.size.height > 0) {
        self.scrollView.contentOffset = CGPointMake(0, intersection.size.height + self.additionalOffset);
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - Gesture recognizers

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tap
{
    [self dismissKeyboard];
}

@end
