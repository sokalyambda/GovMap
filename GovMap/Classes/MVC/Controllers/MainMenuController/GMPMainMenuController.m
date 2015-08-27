//
//  GMPMainMenuController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMainMenuController.h"
#import "GMPMenuView.h"

@interface GMPMainMenuController ()<GMPMenuViewDelegate>

@property (weak, nonatomic) IBOutlet GMPMenuView *menuView;

@end

@implementation GMPMainMenuController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuView.delegate = self;
    
}

#pragma mark - GMPMenuViewDelegate methods

- (void)menuViewDidPressFirstButton:(GMPMenuView *)menuView
{
    NSLog(@"firstButtonDidPressed");
}

- (void)menuViewDidPressSecondButton:(GMPMenuView *)menuView
{
    NSLog(@"secondButtonDidPressed");
}

- (void)menuViewDidPressThirdButton:(GMPMenuView *)menuView
{
    NSLog(@"thirdButtonDidPressed");
}

@end
