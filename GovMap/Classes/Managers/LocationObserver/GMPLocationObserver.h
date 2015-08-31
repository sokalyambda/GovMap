//
//  GMPLocationObserver.h
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface GMPLocationObserver : NSObject

@property (strong, nonatomic) CLLocation *updatedLocation;

+ (GMPLocationObserver *)sharedInstance;
- (void)startUpdatingLocation;

@end
