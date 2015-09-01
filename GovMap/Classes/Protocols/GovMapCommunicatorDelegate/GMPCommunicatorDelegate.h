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

/**
 *  Tells the delegate the communicator failed to load HTML frame.
 *
 *  @param communicator Communicator object informing the delegate.
 *  @param frameNumber  Number of HTML frame that failed to load.
 *  @param error        Error description.
 */
- (void)communicator:(GMPCommunicator *)communicator didFailLoadingContentWithFrameNumber:(NSInteger)frameNumber error:(NSError *)error;

/**
 *  Tells the delegate the communicator successfully loaded all necessary content and ready for requests.
 *
 *  @param communicator Communiactor object informing the delegate
 */
- (void)communicatorDidFinishLoadingContent:(GMPCommunicator *)communicator;

/**
 *  Tells the delegate the communicator was not ready to process request
 *
 *  @param communicator Communiactor object informing the delegate
 */
- (void)communicatorWasNotReadyForRequest:(GMPCommunicator *)communicator;

@end
