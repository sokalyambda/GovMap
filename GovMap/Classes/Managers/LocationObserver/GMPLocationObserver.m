//
//  GMPLocationObserver.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationObserver.h"
#import <CoreLocation/CoreLocation.h>

@interface GMPLocationObserver ()<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation GMPLocationObserver

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
        
        _locationManager.delegate           = self;
        _locationManager.distanceFilter     = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;
        _updatedLocation = nil;
        
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
        
    }
    return self;
    
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.updatedLocation = manager.location;
}

#pragma mark - Public methods

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

@end
