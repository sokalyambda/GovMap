//
//  GMPCommunicatorDelegate.h
//  GovMap
//
//  Created by Pavlo on 8/31/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMPCommunicator;

@protocol GMPCommunicatorDelegate <NSObject>

@optional
- (void)communicator:(GMPCommunicator *)communicator
didFailToLoadContentWithFrameNumber:(NSInteger)frameNumber
               error:(NSError *)error;
//- (void)communicator:(GMPCommunicator *)communicator didFail

@end
