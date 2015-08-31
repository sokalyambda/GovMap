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
@property (strong, nonatomic) GMPUserAnnotation * annotationView;

@end

@implementation GMPMapController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationObserver = [GMPLocationObserver sharedInstance];
    [self.locationObserver startUpdatingLocation];

}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    self.annotationView = [[GMPUserAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];
    [self.mapView addAnnotation:self.annotationView];
    
    
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
          //  pinView.canShowCallout = YES;

        } else {
            pinView.annotation = annotation;
        }        
        return pinView;
    }
    return nil;
}

@end
