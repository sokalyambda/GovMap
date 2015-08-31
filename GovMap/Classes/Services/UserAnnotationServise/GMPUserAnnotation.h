//
//  GMPUserAnnotationService.h
//  GovMap
//
//  Created by Myroslava Polovka on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GMPUserAnnotation: NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)paramCoordinate title:(NSString *)paramTitle;

@end
