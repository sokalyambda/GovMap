//
//  GMPSearchWithGeoNumbersController.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithGeoNumbersController.h"
#import "GMPSearchWithGeoNumbersView.h"

@interface GMPSearchWithGeoNumbersController () <GMPSearchWithGeoNumbersDelegate>

@property (weak, nonatomic) IBOutlet GMPSearchWithGeoNumbersView *searchWithGeoNumbersView;

@end

@implementation GMPSearchWithGeoNumbersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchWithGeoNumbersView.delegate = self;
}

#pragma mark - GMPSearchWithGeoNumbersDelegate methods

- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithGeoNumbers:(NSDictionary *)geoNumbers
{
    NSLog(@"Latitute: %@ Longitude: %@", geoNumbers[kLatitude], geoNumbers[kLongitude]);
}

@end
