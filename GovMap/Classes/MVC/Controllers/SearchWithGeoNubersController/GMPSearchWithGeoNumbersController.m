//
//  GMPSearchWithGeoNumbersController.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithGeoNumbersController.h"
#import "GMPMapController.h"

#import "GMPSearchWithGeoNumbersView.h"

#import "GMPCadastre.h"

static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";

@interface GMPSearchWithGeoNumbersController () <GMPSearchWithGeoNumbersDelegate>

@property (weak, nonatomic) IBOutlet GMPSearchWithGeoNumbersView *searchWithGeoNumbersView;

@property (strong, nonatomic) GMPCadastre *currentCadastre;

@end

@implementation GMPSearchWithGeoNumbersController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchWithGeoNumbersView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchWithGeoNumbersView subscribeForNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.searchWithGeoNumbersView unsubscribeFromNotifications];
}

#pragma mark - GMPSearchWithGeoNumbersDelegate methods

- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithCadactralNumbers:(GMPCadastre *)geoNumbers
{
    self.currentCadastre = geoNumbers;
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeGeonumbers;
        controller.currentCadastre = self.currentCadastre;
        [self.view.window endEditing:YES];
    }
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    self.navigationItem.title = LOCALIZED(@"Search By Lot & Parcel");
}

@end
