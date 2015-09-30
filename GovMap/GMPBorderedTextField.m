//
//  GMPBorderedTextField.m
//  Relocate
//
//  Created by Myroslava Polovka on 9/7/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBorderedTextField.h"

static CGFloat kLeftViewWidth = 10.f;

@implementation GMPBorderedTextField

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addLeftView];
    [self addRightView];
    
    self.textAlignment = NSTextAlignmentNatural;
    
    if ([NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages].firstObject] == NSLocaleLanguageDirectionRightToLeft) {
        self.textAlignment = NSTextAlignmentRight;
    }

    self.layer.cornerRadius  = 5.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor   = UIColorFromRGB(0x03a9f4).CGColor;
    self.layer.borderWidth   = 0.5f;
}

- (void)addLeftView
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftViewWidth, CGRectGetHeight(self.frame))];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addRightView
{
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - kLeftViewWidth , 0, kLeftViewWidth, CGRectGetHeight(self.frame))];
    self.rightViewMode = UITextFieldViewModeAlways;
}


@end
