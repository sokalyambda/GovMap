//
//  GMPBaseViewController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseViewController.h"

@interface GMPBaseViewController ()

@end

@implementation GMPBaseViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    return;
}

@end
