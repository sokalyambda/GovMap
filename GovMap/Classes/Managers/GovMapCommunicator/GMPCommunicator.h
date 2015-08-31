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
@protocol GMPCommunicatorDelegate;

typedef void(^CommunicatorCompletionBlock)(GMPCadastre *cadastralInfo, NSError *error);

@interface GMPCommunicator : NSObject

@property (strong, nonatomic) id<GMPCommunicatorDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)reloadContent;
- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(CommunicatorCompletionBlock)completionBlock;

@end
