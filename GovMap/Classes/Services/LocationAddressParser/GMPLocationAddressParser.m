//
//  GMPLocationAddressParser.m
//  GovMap
//
//  Created by Myroslava Polovka on 9/2/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationAddressParser.h"
#import "GMPLocationAddress.h"

@implementation GMPLocationAddressParser

+ (GMPLocationAddress *)locationAddressWithGovMapAddress:(NSString *)address
{
    NSArray *addressObjects = [address componentsSeparatedByString:@", "];
    NSString *street = [[addressObjects[0] componentsSeparatedByString:@": "] lastObject];
    NSString *home   = [[addressObjects[1] componentsSeparatedByString:@": "] lastObject];
    NSString *city   = [[addressObjects[2] componentsSeparatedByString:@": "] lastObject];
    
    GMPLocationAddress *locationAddress = [GMPLocationAddress locationAddressWithCityName:city
                                                                            andStreetName:street
                                                                              andHomeName:home];
    return locationAddress;
}

@end
