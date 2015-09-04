//
//  GMPGoogleGeocoder.h
//  GovMap
//
//  Created by Pavlo on 9/4/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPLocationAddress;

typedef void(^GMSGeocodeLocationCallback)(GMPLocationAddress *address, NSError *error);
typedef void(^GMSReverseGeocodeAddressCallback)(CLLocation *location, NSError *error);

@interface GMPGoogleGeocoder : NSObject

+ (instancetype)sharedInstance;

- (void)geocodeLocation:(CLLocation *)location
      completionHandler:(GMSGeocodeLocationCallback)handler;

/**
 * Reverse geocodes an address.
 *
 * @param adress The address to reverse geocode.
 * @param handler The callback to invoke with the reverse geocode results.
 *        The callback will be invoked asynchronously from the main thread.
 */
- (void)reverseGeocodeAddress:(GMPLocationAddress *)address
     completionHandler:(GMSReverseGeocodeAddressCallback)handler;

@end
