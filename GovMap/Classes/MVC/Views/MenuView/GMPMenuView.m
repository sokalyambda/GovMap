//
//  GMPMainMenuContainer.m
//  GovMap
//
//  Created by Myroslava Polovka on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMenuView.h"
#import "UIView+MakeFromXib.h"

@interface GMPMenuView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation GMPMenuView

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _containerView = [[self class] makeFromXibWithFileOwner:self];
        _containerView.frame = self.frame;
        [self addSubview:_containerView];
    }
    return self;
}

#pragma mark - Actions

- (IBAction)findGeoNumerByAddressPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidPressFirstButton:)]) {
        [self.delegate menuViewDidPressFirstButton:self];
    }
}

- (IBAction)findGeoNumberByPlacingPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidPressSecondButton:)]) {
        [self.delegate menuViewDidPressSecondButton:self];
    }
}

- (IBAction)findAddressByGeoNumberPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(menuViewDidPressThirdButton:)]) {
        [self.delegate menuViewDidPressThirdButton:self];
    }
}

@end
