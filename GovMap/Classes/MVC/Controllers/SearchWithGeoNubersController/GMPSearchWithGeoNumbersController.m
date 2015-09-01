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

#pragma mark - GMPSearchWithGeoNumbersDelegate methods

- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithGeoNumbers:(NSDictionary *)geoNumbers
{
    self.currentCadastre = [GMPCadastre cadastreWithMajor:[geoNumbers[kLatitude] integerValue] minor:[geoNumbers[kLongitude] integerValue]];
    NSLog(@"Latitute: %@ Longitude: %@", geoNumbers[kLatitude], geoNumbers[kLongitude]);
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
        controller.currentSearchType = GMPSearchTypeGeonumbers;
        controller.currentCadastre = self.currentCadastre;
    }
}

@end
