//
//  GMPSerialViewsConstructor.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSerialViewsConstructor.h"

static NSString *const kBackArrowImageName = @"back_arrow";

@implementation GMPSerialViewsConstructor

/**
 *  Create custom back button for controller
 *
 *  @param controller Receiver of custom back button
 *
 *  @return Custom Back Button
 */
+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller withAction:(SEL)action
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kBackArrowImageName] style:UIBarButtonItemStylePlain target:controller action:action];
    return backButton;
}

@end
