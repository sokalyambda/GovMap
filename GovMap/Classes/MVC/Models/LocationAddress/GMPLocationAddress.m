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

-(NSString *)fullStreetName
{
    return [NSString stringWithFormat:@"%@ %@", self.homeName, self.streetName];
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

+ (instancetype)locationAddressWithCityName:(NSString *)cityName andStreetName:(NSString *)streetName andHomeName:(NSString *)homeName
{
    return [[self alloc] initWithCityName:cityName andSreetName:streetName andHomeName:homeName];
}

@end
