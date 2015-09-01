//
//  GMPMapController.h
//  GovMap
//
//  Created by Myroslava Polovka on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef enum : NSUInteger {
    GMPSearchTypeAddress,
    GMPSearchTypeCurrentPlacing,
    GMPSearchTypeGeonumbers,
} GMPSearchType;

#import "GMPBaseViewController.h"
#import "GMPLocationAddress.h"

@interface GMPMapController : GMPBaseViewController

@property (assign, nonatomic) GMPSearchType currentSearchType;
@property (strong, nonatomic) GMPLocationAddress *locationAddress;

@end
