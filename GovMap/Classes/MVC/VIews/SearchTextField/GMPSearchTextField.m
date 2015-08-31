//
//  GMPSearchTextField.m
//  GovMap
//
//  Created by Eugenity on 31.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchTextField.h"

@implementation GMPSearchTextField

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self pointInside:point withEvent:event]) {
        [self resignFirstResponder];
    }
    return [super hitTest:point withEvent:event];
}

@end
