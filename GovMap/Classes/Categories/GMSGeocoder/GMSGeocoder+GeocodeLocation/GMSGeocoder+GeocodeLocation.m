//
//  GMSGeocoder+GeocodeLocation.m
//  GovMap
//
//  Created by Pavlo on 9/3/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPLocationAddress.h"

#import "GMSGeocoder+GeocodeLocation.h"

static NSString *const kBaseURLString = @"https://maps.googleapis.com/maps/api/geocode/json?latlng=";
static NSString *const kKey = @"";//@"&key=AIzaSyCe5NsemBVFbuMYSUoxzi0qao7cKqiEECc";

@implementation GMSGeocoder (GeocodeLocation)

- (void)geocodeLocation:(CLLocation *)location completionHandler:(GMSGeocodeLocationCallback)handler
{
    NSString *fullURLString = [NSString stringWithFormat:@"%@%f,%f%@",
                               kBaseURLString,
                               location.coordinate.latitude,
                               location.coordinate.longitude,
                               kKey];
    
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Handle connection error
        if (error) {
            handler(nil, error);
            return;
        }
        
        NSError *JSONExtractionError = nil;
        NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&JSONExtractionError];
        
        // Handle parsing error
        if (JSONExtractionError) {
            handler(nil, JSONExtractionError);
            return;
        }
        
        // Handle denied request by Google
        if (![JSONObject[@"status"] isEqualToString:@"OK"]) {
            NSError *googleError = [NSError errorWithDomain:JSONObject[@"status"] code:-1 userInfo:nil];
            handler(nil, googleError);
            return;
        }
        
        NSArray *results = JSONObject[@"results"];
        NSArray *addressComponents = results[0][@"address_components"];
        
        NSString *home = addressComponents[0][@"long_name"];
        NSString *street = addressComponents[1][@"long_name"];
        NSString *city = addressComponents[2][@"long_name"];
        
        NSArray *homes = [home componentsSeparatedByString:@"-"];
        
        handler([GMPLocationAddress locationAddressWithCityName:city andStreetName:street andHomeName:homes.firstObject], nil);
    }];
    
    [task resume];
}

@end
