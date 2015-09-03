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

- (void)setFullAddress:(NSString *)fullAddress{
    
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

- (instancetype)initWithGMSAddress:(GMSAddress *)address
{
    self = [super init];
    if (self) {
        
        _cityName = address.locality;
        _streetName = address.thoroughfare;
        
        NSString *digitsRegex = @".*[\\d]";
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:digitsRegex
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        [regex enumerateMatchesInString:self.streetName options:0 range:NSMakeRange(0, [self.streetName length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
            
            NSString *digitsString = [self.streetName substringWithRange:match.range];
            
            self.streetName = [self.streetName stringByReplacingOccurrencesOfString:digitsString withString:@""];
            
            if ([digitsString containsString:@"-"]) {
                NSArray *homeNumbers = [digitsString componentsSeparatedByString:@"-"];
                if (homeNumbers.count) {
                    _homeName = homeNumbers.firstObject;
                }
            } else {
                _homeName = digitsString;
            }
        }];
    }
    return self;
}
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

+ (instancetype)locationAddressWithGMSAddress:(GMSAddress *)address
{
    return [[self alloc] initWithGMSAddress:address];
}

@end
