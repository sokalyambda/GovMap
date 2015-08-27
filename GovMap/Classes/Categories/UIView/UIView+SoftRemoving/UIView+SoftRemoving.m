//
//  UIView+SoftRemoving.m
//  vdiabete
//
//  Created by Eugene Sokolenko on 22.04.15.
//  Copyright (c) 2015 kttsoft. All rights reserved.
//

#import "UIView+SoftRemoving.h"

static CGFloat const kRemovingDuration = .3f;

@implementation UIView (SoftRemoving)

- (void)softRemove
{
    WEAK_SELF;
    [UIView transitionWithView:self.superview
                      duration:kRemovingDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ {
                        [weakSelf removeFromSuperview];
                    }
                    completion:nil];
}

@end
