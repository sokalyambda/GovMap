//
//  GMPReachabilityService.h
//  Relocate
//
//  Created by Eugenity on 04.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface GMPReachabilityService : NSObject

+ (void)checkConnectionOnSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

+ (void)setupReachabilityObserver;

@end
