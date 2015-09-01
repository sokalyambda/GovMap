//
//  GMPLocationAddress.h
//  GovMap
//
//  Created by Eugenity on 01.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface GMPLocationAddress : NSObject

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *homeName;

+ (instancetype)locationAddressWithCityName:(NSString *)cityName andStreetName:(NSString *)streetName andHomeName:(NSString *)homeName;

@end
