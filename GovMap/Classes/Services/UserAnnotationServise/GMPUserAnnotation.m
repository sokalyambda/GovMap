//
//  GMPUserAnnotationService.m
//  GovMap
//
//  Created by Myroslava Polovka on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPUserAnnotation.h"

#import <MapKit/MapKit.h>

@implementation GMPUserAnnotation

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

#pragma mark - Lifecycle

- (id)initWithLocation:(CLLocationCoordinate2D)paramCoordinate title:(NSString *)paramTitle{
    self = [super init];
    if (self) {
        _coordinate = paramCoordinate;
        _title      = paramTitle;
    }
    return self;
}

@end
