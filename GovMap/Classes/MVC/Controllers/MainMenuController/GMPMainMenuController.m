//
//  GMPMainMenuController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMainMenuController.h"
#import "GMPMapController.h"
#import "GMPAppLanguageSwitchController.h"

#import "GMPLocationObserver.h"

#import "GMPMenuView.h"

static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";
static NSString *const kSearchWithAddressControllerSegueIdentifier = @"searchWithAddressControllerSegue";
static NSString *const kSearchWithGeoNumbersControllerSegueIdentifier = @"searchWithGeoNumbersControllerSegue";

@interface GMPMainMenuController() <GMPMenuViewDelegate>

@property (weak, nonatomic) IBOutlet GMPMenuView *menuView;
@property (strong, nonatomic) GMPAppLanguageSwitchController *appLanguageSwitchController;

@end

@implementation GMPMainMenuController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuView.delegate = self;
    
    self.appLanguageSwitchController = [[GMPAppLanguageSwitchController alloc] initWithNibName:NSStringFromClass([GMPAppLanguageSwitchController class]) bundle:nil];
    
    [self.navigationController addChildViewController:self.appLanguageSwitchController];
    [self.appLanguageSwitchController didMoveToParentViewController:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.appLanguageSwitchController removeFromParentViewController];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeCurrentPlacing;
    }
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitleView:self.appLanguageSwitchController.view];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

@end
