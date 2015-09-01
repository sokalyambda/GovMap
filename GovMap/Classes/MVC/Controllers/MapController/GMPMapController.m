//
//  GMPMapController.m
//  GovMap
//
//  Created by Myroslava Polovka on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "GMPMapController.h"

#import "GMPLocationObserver.h"

#import "GMPUserAnnotation.h"

#import "GMPWazeNavigationService.h"

static NSInteger const kBarButtonsFixedSpace = 10.f;

@interface GMPMapController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goToWazeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchGeoDataButton;

@property (strong, nonatomic) GMPLocationObserver *locationObserver;
@property (strong, nonatomic) GMPUserAnnotation *annotation;
@property (assign, nonatomic) CLLocationCoordinate2D previousCoordinate;
@property (copy, nonatomic) NSString *userAddress;

@end

@implementation GMPMapController

#pragma mark - Accessors

- (GMPLocationObserver *)locationObserver
{
    if (!_locationObserver) {
        _locationObserver = [GMPLocationObserver sharedInstance];
    }
    return _locationObserver;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupMapAppearing];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self setupMapAttributesForCoordinate:userLocation.location.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[GMPUserAnnotation class]]) {
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([GMPUserAnnotation class])];
        
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateDragging) {
        
        GMPUserAnnotation *annotation = (GMPUserAnnotation *)view.annotation;
        CLLocation *location = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [self.locationObserver reverseGeocodingForCoordinate:location withResult:^(BOOL success, NSString *address) {
            if (success) {
                if (self.previousCoordinate.latitude != annotation.coordinate.latitude ||
                    self.previousCoordinate.longitude != annotation.coordinate.longitude) {
                    
                    [annotation setSubtitle:@""];
                }
                [annotation setTitle:address];
            }
        }];
    }
}

#pragma mark - Private Methods

- (void)setupMapAttributesForCoordinate:(CLLocationCoordinate2D)coordinate
{
    WEAK_SELF;
    self.previousCoordinate = coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.locationObserver reverseGeocodingForCoordinate:location withResult:^(BOOL success, NSString *address) {
        if (success) {
            weakSelf.annotation = [[GMPUserAnnotation alloc] initWithLocation:coordinate title:address];
            [weakSelf.annotation setSubtitle:@"Subtitle"];
            [weakSelf.mapView addAnnotation:self.annotation];
        }
    }];
}

- (void)setupMapAppearing
{
    switch (self.currentSearchType) {
        case GMPSearchTypeAddress: {
            
            [self.locationObserver geocodingForAddress:@"1005 Gravenstein Highway North, Sebastopol, USA" withResult:^(BOOL success, CLLocation *location) {
                if(success) {
                    [self setupMapAttributesForCoordinate:location.coordinate];
                }
            }];
            break;
        }
        case GMPSearchTypeCurrentPlacing: {
            [self setupMapAttributesForCoordinate:self.locationObserver.currentLocation.coordinate];
            break;
        }
            
        default:
            break;
    }

}

#pragma mark - Actions

- (IBAction)goToWazeClick:(id)sender
{
    CLLocationCoordinate2D coord = self.annotation.coordinate;
    [GMPWazeNavigationService navigateToWazeWithLatitude:coord.latitude longitude:coord.longitude];
}

- (IBAction)searchGeoDataClick:(id)sender
{
    
}

/**
 *  Customize current navigation item
 */
- (void)customizeNavigationItem
{
    self.goToWazeButton.title = LOCALIZED(@"Open Waze");
    self.searchGeoDataButton.title = LOCALIZED(@"Search Geo Data");
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = kBarButtonsFixedSpace;
    self.navigationItem.rightBarButtonItems = @[self.goToWazeButton, fixedSpace, self.searchGeoDataButton];
}

@end
