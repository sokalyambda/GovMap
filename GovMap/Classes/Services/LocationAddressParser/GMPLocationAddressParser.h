//
//  GMPLocationAddressParser.h
//  GovMap
//
//  Created by Myroslava Polovka on 9/2/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPLocationAddress;

@interface GMPLocationAddressParser : NSObject

+ (GMPLocationAddress *)locationAddressWithGovMapAddress:(NSString *)address;

@end
