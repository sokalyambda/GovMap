//
//  GMPLocationObserver.h
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "GMPLocationAddress.h"

extern NSString *const kLocationServiceEnabled;

typedef void(^ReverseGeocodingResult)(BOOL success, GMPLocationAddress *address);
typedef void(^GeocodingResult)(BOOL success, CLLocation *location);

@interface GMPLocationObserver : NSObject

@property (strong, nonatomic) CLLocation *currentLocation;

+ (GMPLocationObserver *)sharedInstance;

@end
