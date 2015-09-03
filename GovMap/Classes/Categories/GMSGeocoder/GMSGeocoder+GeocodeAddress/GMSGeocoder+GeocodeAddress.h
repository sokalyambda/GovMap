//
//  GMSGeocoder+GeocodeAddress.h
//  GovMap
//
//  Created by Pavlo on 9/3/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@import GoogleMaps;

typedef void(^GMSGeocodeAddressCallback)(CLLocation *location, NSError *error);

@interface GMSGeocoder (GeocodeAddress)

/**
 * Reverse geocodes an address.
 *
 * @param adress The address to reverse geocode.
 * @param handler The callback to invoke with the reverse geocode results.
 *        The callback will be invoked asynchronously from the main thread.
 */
- (void)geocodeAddress:(NSString *)address
            completionHandler:(GMSGeocodeAddressCallback)handler;

@end
