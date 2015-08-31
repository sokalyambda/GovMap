//
//  GMPMapController.m
//  GovMap
//
//  Created by Myroslava Polovka on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMapController.h"
#import <MapKit/MapKit.h>
#import "GMPLocationObserver.h"
#import "GMPUserAnnotation.h"

@interface GMPMapController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) GMPLocationObserver *locationObserver;
@property (strong, nonatomic) GMPUserAnnotation * annotation;

@end

@implementation GMPMapController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationObserver = [GMPLocationObserver sharedInstance];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupMapAttributesForCoordinate:self.locationObserver.currentLocation.coordinate];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self setupMapAttributesForCoordinate:userLocation.location.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[GMPUserAnnotation class]]) {
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier: NSStringFromClass([GMPUserAnnotation class])];
        
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:NSStringFromClass([GMPUserAnnotation class])];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.draggable = YES;
            pinView.canShowCallout = YES;

        } else {
            pinView.annotation = annotation;
        }        
        return pinView;
    }
    return nil;
}
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    GMPUserAnnotation *annotation = (GMPUserAnnotation *)view.annotation;
//    CLLocation *location = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
//    
//    [self.locationObserver reverseGeocodingForCoordinate:location withResult:^(BOOL success, NSString *address) {
//        if (success) {
//            [annotation setTitle:address];
//        }
//    }];
//    
//}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {
        
        GMPUserAnnotation *annotation = (GMPUserAnnotation *)view.annotation;
        CLLocation *location = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [self.locationObserver reverseGeocodingForCoordinate:location withResult:^(BOOL success, NSString *address) {
            if (success) {
                [annotation setTitle:address];
            }
        }];
    }
}
- (void)setupMapAttributesForCoordinate:(CLLocationCoordinate2D)coordinate
{
    WEAK_SELF;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.locationObserver reverseGeocodingForCoordinate:location withResult:^(BOOL success, NSString *address) {
        if (success) {
            weakSelf.annotation = [[GMPUserAnnotation alloc]initWithLocation:coordinate title:address];
            [weakSelf.mapView addAnnotation:self.annotation];
        }
    }];
    
}

@end
