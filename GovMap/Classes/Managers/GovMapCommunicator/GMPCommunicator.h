//
//  GMPCommunicator.h
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class GMPCadastre;

typedef void(^CommunicatorCompletionBlock)(GMPCadastre *, NSError *);

@interface GMPCommunicator : NSObject

+ (instancetype)sharedInstance;
- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(CommunicatorCompletionBlock)completionBlock;

@end
