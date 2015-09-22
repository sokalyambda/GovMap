//
//  GMPBaseViewController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseViewController.h"
#import "GMPBaseNavigationController.h"

@interface GMPBaseViewController ()

@property (weak, nonatomic) GMPBaseNavigationController *baseNavigationController;

@end

@implementation GMPBaseViewController

#pragma mark - Accessors

- (GMPBaseNavigationController *)baseNavigationController
{
    if (!_baseNavigationController && [self.navigationController isKindOfClass:[GMPBaseNavigationController class]]) {
        _baseNavigationController = (GMPBaseNavigationController *)self.navigationController;
    }
    return _baseNavigationController;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.multipleTouchEnabled = NO;
    self.view.exclusiveTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = self.baseNavigationController.customBackButton;
    [self customizeNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/**
 *  Setup the base status bar style
 *
 *  @return UIStatusBarStyleLightContent
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    return;
}

@end
