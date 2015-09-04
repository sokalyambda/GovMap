//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressViewController.h"
#import "GMPMapController.h"
#import "GMPLocationAddress.h"

#import "GMPSearchWithAddressView.h"

static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";

@interface GMPSearchWithAddressViewController () <GMPSearchWithAdressDelegate>

@property (weak, nonatomic) IBOutlet GMPSearchWithAddressView *searchWithAddressView;
@property (strong, nonatomic) GMPLocationAddress *locationAddress;

@end

@implementation GMPSearchWithAddressViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchWithAddressView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchWithAddressView subscribeForNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.searchWithAddressView unsubscribeFromNotifications];
}

#pragma mark - GMPSearchWithAddressDelegate methods

- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(GMPLocationAddress *)address
{
    self.locationAddress = address;
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeAddress;
        controller.currentAddress = self.locationAddress;
    }
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    self.navigationItem.title = LOCALIZED(@"Search By Address");
}

@end
