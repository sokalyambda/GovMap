//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressViewController.h"
#import "GMPMapController.h"

#import "GMPSearchWithAddressView.h"

static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";

@interface GMPSearchWithAddressViewController () <GMPSearchWithAdressDelegate>

@property (weak, nonatomic) IBOutlet GMPSearchWithAddressView *searchWithAddressView;

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

- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(NSDictionary *)address
{
    NSLog(@"City: %@, street: %@, home: %@", address[kCity], address[kStreet], address[kHome]);
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeAddress;
    }
}

@end
