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

@synthesize coordinate, title, subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)paramCoordinate title:(NSString *)paramTitle{
    self = [super init];
    if (self) {
        coordinate = paramCoordinate;
        title      = paramTitle;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

- (void)setTitle:(NSString *)newTitle{
    title = newTitle;
}

@end
