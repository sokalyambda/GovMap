//
//  GMPCadastre.h
//  GovMap
//
//  Created by Pavlo on 8/31/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMPCadastre : NSObject

@property (assign, readwrite, nonatomic) NSInteger major;
@property (assign, readwrite, nonatomic) NSInteger minor;

+ (instancetype)cadastreWithMajor:(NSInteger)major minor:(NSInteger)minor;

@end
