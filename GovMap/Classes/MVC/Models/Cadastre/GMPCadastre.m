//
//  GMPCadastre.m
//  GovMap
//
//  Created by Pavlo on 8/31/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPCadastre.h"

@implementation GMPCadastre

- (instancetype)initWithMajor:(NSInteger)major minor:(NSInteger)minor
{
    if (self = [super init]) {
        _major = major;
        _minor = minor;
    }
    return self;
}

+ (instancetype)cadastreWithMajor:(NSInteger)major minor:(NSInteger)minor
{
    return [[self alloc] initWithMajor:major minor:minor];
}

@end
