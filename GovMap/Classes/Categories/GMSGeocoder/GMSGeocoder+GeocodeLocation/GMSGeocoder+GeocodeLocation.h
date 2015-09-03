//
//  GMSGeocoder+GeocodeLocation.h
//  GovMap
//
//  Created by Pavlo on 9/3/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@class GMPLocationAddress;

typedef void(^GMSGeocodeLocationCallback)(GMPLocationAddress *address, NSError *error);

@interface GMSGeocoder (GeocodeAddress)

- (void)geocodeLocation:(CLLocation *)location
     completionHandler:(GMSGeocodeLocationCallback)handler;

@end
