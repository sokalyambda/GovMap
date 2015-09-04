//
//  GMPLocationObserver.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationObserver.h"

#import <AddressBook/AddressBook.h>

@import GoogleMaps;

static NSString *const kCountryKey = @"IL";
static NSString *const kAddressDictionaryKey = @"FormattedAddressLines";

@interface GMPLocationObserver ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation GMPLocationObserver

#pragma mark - Lifecycle

+ (GMPLocationObserver *)sharedInstance
{
    static GMPLocationObserver *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GMPLocationObserver alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _geocoder = [[CLGeocoder alloc] init];
        
        _locationManager.delegate           = self;
        _locationManager.distanceFilter     = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;
        _currentLocation = nil;
        
        [_locationManager requestWhenInUseAuthorization];
        [self startUpdatingLocation];
        
    }
    return self;
    
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = manager.location;
}

#pragma mark - Private methods

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;
}

@end
