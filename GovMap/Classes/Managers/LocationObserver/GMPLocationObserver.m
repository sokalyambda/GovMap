//
//  GMPLocationObserver.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationObserver.h"
#import <AddressBook/AddressBook.h>

//#import <CoreLocation/CoreLocation.h>

static NSString *const kCountryKey = @"IL";

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

#pragma mark - Public methods

- (void)reverseGeocodingForCoordinate:(CLLocation *)location withResult: (ReverseGeocodingResult)result;
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         if (!error && placemarks.count) {
             CLPlacemark *placemark = [placemarks firstObject];
             
             NSArray *adressArray = placemark.addressDictionary[@"FormattedAddressLines"];
             NSString *address = [NSString string];
             for (int i = 0; i < adressArray.count; i++) {
                 NSString *s = [NSString stringWithFormat:@"%@ ", adressArray[i]];
                 address = [address stringByAppendingString:s];
             }
             
             NSLog(@"%@", placemark.addressDictionary);
             if (result) {
                 result(YES, address);
             }
         } else {
             if (result) {
                 result(NO, nil);
             }
         }
     }];
}

- (void)geocodingForAddress:(GMPLocationAddress *)address withResult:(GeocodingResult)result
{
    NSString *street = [NSString stringWithFormat:@"%@ %@", address.homeName, address.streetName];
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        address.cityName, kABPersonAddressCityKey,
                                        kCountryKey, kABPersonAddressCountryKey,
                                        street, kABPersonAddressStreetKey,
                                        nil];
    [self.geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && placemarks.count) {
            CLPlacemark *placemark = [placemarks firstObject];
            
            if (result) {
                result(YES, placemark.location);
            }
        } else {
            if (result) {
                result(NO, nil);
            }
        }
    }];
    
}

@end
