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

#pragma mark - GMPSearchWithAddressDelegate methods

- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(NSDictionary *)address
{
    self.locationAddress = [GMPLocationAddress locationAddressWithCityName:address[kCity] andStreetName:address[kStreet] andHomeName:address[kHome]];
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeAddress;
        controller.locationAddress = self.locationAddress;
    }
}

@end
