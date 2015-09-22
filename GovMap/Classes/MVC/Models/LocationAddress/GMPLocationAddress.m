//
//  GMPLocationAddress.m
//  GovMap
//
//  Created by Eugenity on 01.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationAddress.h"

@implementation GMPLocationAddress

#pragma mark - Accessors

- (NSString *)fullAddress
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.cityName, self.homeName, self.streetName];
}

- (NSString *)calloutTitleAddress
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.cityName, self.streetName, self.homeName];
}

- (NSString *)cityName {
    if (!_cityName) {
        _cityName = @"";
    }
    return _cityName;
}

- (NSString *)homeName {
    if (!_homeName) {
        _homeName = @"";
    }
    return _homeName;
}

- (NSString *)streetName {
    if (!_streetName) {
        _streetName = @"";
    }
    return _streetName;
}

#pragma mark - Lifecycle

- (instancetype)initWithCityName:(NSString *)cityName andFullSreetName:(NSString *)fullStreetName
{
    self = [super init];
    if (self) {
        _cityName = cityName;
        _streetName = fullStreetName;
    }
    return self;
}

+ (instancetype)locationAddressWithCityName:(NSString *)cityName andStreetName:(NSString *)streetName andHomeName:(NSString *)homeName
{
    NSString *fullStreetName = [NSString stringWithFormat:@"%@ %@", homeName, streetName];
    return [[self alloc] initWithCityName:cityName andFullSreetName:fullStreetName];
}

@end
