//
//  GMPRoundedCornersButton.m
//  GovMap
//
//  Created by Eugenity on 04.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPRoundedCornersButton.h"

@implementation GMPRoundedCornersButton

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
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

- (void)awakeFromNib
{
    [self commonInit];
}

#pragma mark - Actions

- (void)commonInit
{
    self.layer.cornerRadius = 5.f;
}

@end
