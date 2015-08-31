//
//  GMPCommunicator.h
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface GMPCadastre : NSObject

@property (nonatomic, readwrite) int major;
@property (nonatomic, readwrite) int minor;

- (instancetype)initWithMajor:(int)major minor:(int)minor;
+ (instancetype)cadastreWithMajor:(int)major minor:(int)minor;

@end

@interface GMPCommunicator : NSObject

+ (instancetype)sharedInstance;
- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(void(^)(GMPCadastre *cadastralInfo, NSError *error))completionBlock;

@end
