//
//  GMPLocationObserver.h
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^ReverseGeocodingResult)(BOOL success, NSString *address);
typedef void(^GeocodingResult)(BOOL success, CLLocation *location);

@interface GMPLocationObserver : NSObject

@property (strong, nonatomic) CLLocation *currentLocation;

+ (GMPLocationObserver *)sharedInstance;

- (void)reverseGeocodingForCoordinate:(CLLocation *)location withResult: (ReverseGeocodingResult)result;
- (void)geocodingForAddress:(NSString *)address withResult:(GeocodingResult)result;

@end
