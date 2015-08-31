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

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

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

#pragma mark - Public methods

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;

}

- (void)reverseGeocodingForCoordinate:(CLLocation *)location withResult: (ReverseGeocodingResult)result;
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (!error && placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString  *addres = [NSString stringWithFormat:@"%@ %@", placemark.locality, placemark.thoroughfare];
             if (result) {
                result(YES, addres);
             }
             
         } else {
             if (result) {
                 result(NO, nil);
             }
         }
     }];
}

@end
