//
//  GMSGeocoder+GeocodeAddress.m
//  GovMap
//
//  Created by Pavlo on 9/3/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMSGeocoder+GeocodeAddress.h"

static NSString *const kBaseURLString = @"https://maps.google.com/maps/api/geocode/json?address=";
static NSString *const kKey = @"";//@"&key=AIzaSyCe5NsemBVFbuMYSUoxzi0qao7cKqiEECc";

@implementation GMSGeocoder (GeocodeAddress)

- (void)geocodeAddress:(NSString *)address completionHandler:(GMSGeocodeCallback)handler
{
    NSString *fullURLString = [NSString stringWithFormat:@"%@%@%@", kBaseURLString, address, kKey];
    fullURLString = [fullURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        NSDictionary *geometry = results[0][@"geometry"];
        NSDictionary *location = geometry[@"location"];
        NSNumber *latitude = location[@"lat"];
        NSNumber *longitude = location[@"lng"];
        
        CLLocationDegrees lat = latitude.doubleValue;
        CLLocationDegrees lng = longitude.doubleValue;
        
        handler([[CLLocation alloc] initWithLatitude:lat longitude:lng], nil);
    }];
    
    [task resume];
}

@end
