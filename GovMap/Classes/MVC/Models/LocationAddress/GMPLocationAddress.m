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

- (NSString *)fullStreetName
{
    return [NSString stringWithFormat:@"%@ %@", self.streetName, self.cityName];
}

#pragma mark - Lifecycle

- (instancetype)initWithCityName:(NSString *)cityName andSreetName:(NSString *)streetName andHomeName:(NSString *)homeName
{
    self = [super init];
    if (self) {
        _cityName = cityName;
        _streetName = streetName;
        _homeName = homeName;
    }
    return self;
}

- (instancetype)initWithGMSAddress:(GMSAddress *)address
{
    self = [super init];
    if (self) {
        _cityName = address.locality;
        _streetName = address.thoroughfare;
    }
    return self;
}

+ (instancetype)locationAddressWithCityName:(NSString *)cityName andStreetName:(NSString *)streetName andHomeName:(NSString *)homeName
{
    return [[self alloc] initWithCityName:cityName andSreetName:streetName andHomeName:homeName];
}

+ (instancetype)locationAddressWithGMSAddress:(GMSAddress *)address
{
    return [[self alloc] initWithGMSAddress:address];
}

@end
