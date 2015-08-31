//
//  GMPMainMenuController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMainMenuController.h"
#import "GMPLocationObserver.h"
#import "GMPMenuView.h"


static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";
static NSString *const kSearchWithAddressControllerSegueIdentifier = @"searchWithAddressControllerSegue";
static NSString *const kSearchWithGeoNumbersControllerSegueIdentifier = @"searchWithGeoNumbersControllerSegue";

@interface GMPMainMenuController() <GMPMenuViewDelegate>

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
    [self performSegueWithIdentifier:kSearchWithAddressControllerSegueIdentifier sender:self];
}

- (void)menuViewDidPressSecondButton:(GMPMenuView *)menuView
{
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

- (void)menuViewDidPressThirdButton:(GMPMenuView *)menuView
{
    [self performSegueWithIdentifier:kSearchWithGeoNumbersControllerSegueIdentifier sender:self];
}

@end
