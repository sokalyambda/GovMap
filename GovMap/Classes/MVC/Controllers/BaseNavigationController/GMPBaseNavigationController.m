//
//  GMPBaseNavigationController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseNavigationController.h"

#import "GMPSerialViewsConstructor.h"

@interface GMPBaseNavigationController ()

@end

@implementation GMPBaseNavigationController

#pragma mark - Accessors

- (UIBarButtonItem *)customBackButton
{
    if (!_customBackButton) {
        _customBackButton = [GMPSerialViewsConstructor backButtonForController:self withAction:@selector(backClick:)];
    }
    return _customBackButton;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationBar];
}

#pragma mark - Actions

/**
 *  Customize navigation bar
 */
- (void)customizeNavigationBar
{
    [self.navigationBar setBarTintColor:UIColorFromRGB(0xF5A928)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationBar.translucent = NO;
    [self.view setBackgroundColor:UIColorFromRGB(0xffefd5)];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

/**
 *  Custom back action
 *
 *  @param sender Back button
 */
- (void)backClick:(UIBarButtonItem *)sender
{
//    if ([BZRProjectFacade isOperationInProcess]) {
//        return;
//    }
    [self popViewControllerAnimated:YES];
}

@end
