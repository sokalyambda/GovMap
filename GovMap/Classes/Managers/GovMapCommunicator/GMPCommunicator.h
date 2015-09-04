//
//  GMPCommunicator.h
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import <WebKit/WebKit.h>

@class GMPCadastre;
@protocol GMPCommunicatorDelegate;

typedef void(^RequestCadasterCompletionBlock)(GMPCadastre *cadastralInfo);
typedef void(^RequestAddressCompletionBlock)(NSString *address);

@interface GMPCommunicator : NSObject

@property (strong, nonatomic) id<GMPCommunicatorDelegate> delegate;
@property (assign, readonly, nonatomic) BOOL isReadyForRequests;

+ (instancetype)sharedInstance;
- (void)loadContent;
- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(RequestCadasterCompletionBlock)completionBlock;
- (void)requestAddressWithCadastralNumbers:(GMPCadastre *)cadastralInfo
                           completionBlock:(RequestAddressCompletionBlock)completionBlock;

@end
