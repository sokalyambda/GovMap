//
//  GMPGoogleGeocoder.m
//  GovMap
//
//  Created by Pavlo on 9/4/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPGoogleGeocoder.h"

#import "GMPLocationAddress.h"

static NSString *const kLocationBaseURLString = @"https://maps.googleapis.com/maps/api/geocode/json?latlng=";
static NSString *const kAddressBaseURLString = @"https://maps.google.com/maps/api/geocode/json?address=";
static NSString *const kAPIKey = @"";//@"&key=AIzaSyCe5NsemBVFbuMYSUoxzi0qao7cKqiEECc";

static NSString *const kResults = @"results";
static NSString *const kStatus = @"status";
static NSString *const kGeometry = @"geometry";
static NSString *const kLocation = @"location";
static NSString *const kLatitude = @"lat";
static NSString *const kLongitude = @"lng";
static NSString *const kAddressComponents = @"address_components";
static NSString *const kLongName = @"long_name";

@implementation GMPGoogleGeocoder

#pragma mark - Lifecycle

+ (instancetype)sharedInstance
{
    static GMPGoogleGeocoder *sharedCommunicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[GMPGoogleGeocoder alloc] init];
    });
    
    return sharedCommunicator;
}

#pragma mark - Public methods

- (void)geocodeLocation:(CLLocation *)location completionHandler:(GMSGeocodeLocationCallback)handler
{
    NSString *fullURLString = [NSString stringWithFormat:@"%@%f,%f%@",
                               kLocationBaseURLString,
                               location.coordinate.latitude,
                               location.coordinate.longitude,
                               kAPIKey];
    
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
        if (![JSONObject[kStatus] isEqualToString:@"OK"]) {
            NSError *googleError = [NSError errorWithDomain:JSONObject[kStatus] code:-1 userInfo:nil];
            handler(nil, googleError);
            return;
        }
        
        NSArray *results = JSONObject[kResults];
        NSArray *addressComponents = results[0][kAddressComponents];

        NSString *home   = 0 < addressComponents.count? addressComponents[0][kLongName]: @"";
        NSString *street = 1 < addressComponents.count? addressComponents[1][kLongName]: @"";
        NSString *city   = 2 < addressComponents.count? addressComponents[2][kLongName]: @"";
        
        NSArray *homes = [home componentsSeparatedByString:@"-"];
        
        handler([GMPLocationAddress locationAddressWithCityName:city andStreetName:street andHomeName:homes.firstObject], nil);
    }];
    
    [task resume];
}

- (void)reverseGeocodeAddress:(GMPLocationAddress *)address completionHandler:(GMSReverseGeocodeAddressCallback)handler
{
    NSString *fullURLString = [NSString stringWithFormat:@"%@%@%@", kAddressBaseURLString, address.fullAddress, kAPIKey];
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
        if (![JSONObject[kStatus] isEqualToString:@"OK"]) {
            NSError *googleError = [NSError errorWithDomain:JSONObject[kStatus] code:-1 userInfo:nil];
            handler(nil, googleError);
            return;
        }
        
        NSArray *results = JSONObject[kResults];
        NSDictionary *geometry = results[0][kGeometry];
        NSDictionary *location = geometry[kLocation];
        NSNumber *latitude = location[kLatitude];
        NSNumber *longitude = location[kLongitude];
        
        CLLocationDegrees lat = latitude.doubleValue;
        CLLocationDegrees lng = longitude.doubleValue;
        
        handler([[CLLocation alloc] initWithLatitude:lat longitude:lng], nil);
    }];
    
    [task resume];
}

@end
