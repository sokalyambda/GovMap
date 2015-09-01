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
#import "GMPCommunicator.h"

#import "GMPUserAnnotation.h"

#import "GMPWazeNavigationService.h"

#import "GMPCadastre.h"

static NSInteger const kBarButtonsFixedSpace = 10.f;

@interface GMPMapController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goToWazeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchGeoDataButton;

@property (strong, nonatomic) GMPLocationObserver *locationObserver;
@property (strong, nonatomic) GMPUserAnnotation *annotation;
@property (assign, nonatomic) CLLocationCoordinate2D previousCoordinate;
@property (strong, nonatomic) GMPCommunicator *communicator;

@end

@implementation GMPMapController

#pragma mark - Accessors

- (GMPCommunicator *)communicator
{
    if (!_communicator) {
        _communicator = [GMPCommunicator sharedInstance];
    }
    return _communicator;
}

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
            pinView.draggable = self.currentSearchType != GMPSearchTypeCurrentPlacing;
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
                [annotation setTitle:LOCALIZED(address)];
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
            [weakSelf.mapView addAnnotation:self.annotation];
        }
    }];
}

/**
 *  Setup first map's appearance
 */
- (void)setupMapAppearing
{
    switch (self.currentSearchType) {
        case GMPSearchTypeAddress: {
            [self.locationObserver geocodingForAddress:self.currentAddress withResult:^(BOOL success, CLLocation *location) {
                if(success) {
                    [self setupMapAttributesForCoordinate:location.coordinate];
                } else {
                    WEAK_SELF;
                    [GMPAlertService showInfoAlertControllerWithTitle:@"" andMessage:LOCALIZED(@"This address can not be found") forController:self withCompletion:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
            break;
        }
        case GMPSearchTypeCurrentPlacing: {
            [self setupMapAttributesForCoordinate:self.locationObserver.currentLocation.coordinate];
            break;
        }
            
        case GMPSearchTypeGeonumbers: {
            [self.communicator requestAddressWithCadastralNumbers:self.currentCadastre completionBlock:^(NSString *address) {
                // hardcodet address
                address = @"רחוב: מבצע נחשון, בית: 3, עיר: ראשון לציון";
                if (address) {
                    NSArray *addressObjects = [address componentsSeparatedByString:@", "];
                    NSString *street = [[addressObjects[0] componentsSeparatedByString:@": "] lastObject];
                    NSString *home = [[addressObjects[1] componentsSeparatedByString:@": "] lastObject];
                    NSString *city = [[addressObjects[2] componentsSeparatedByString:@": "] lastObject];
                    
                    GMPLocationAddress *locAddress = [GMPLocationAddress locationAddressWithCityName:city andStreetName:street andHomeName:home];
                    [self.locationObserver geocodingForAddress:locAddress withResult:^(BOOL success, CLLocation *location) {
                        if (success) {
                            [self setupMapAttributesForCoordinate:location.coordinate];
                        }
                    }];
                    
                }
            }];
            break;
        }
    }

}

- (void)searchCurrentGeodata
{
    WEAK_SELF;
    switch (self.currentSearchType) {
        case GMPSearchTypeAddress: {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.communicator requestCadastralNumbersWithAddress:[NSString stringWithFormat:@"%@ %@ %@", self.currentAddress.cityName, self.currentAddress.streetName, self.currentAddress.homeName] completionBlock:^(GMPCadastre *cadastralInfo) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                if (cadastralInfo) {
                   [weakSelf.annotation setSubtitle:[NSString localizedStringWithFormat:@"%@ %ld, %@ %ld", LOCALIZED(@"Major:"), (long)cadastralInfo.major, LOCALIZED(@"Minor:"), (long)cadastralInfo.minor]];
                } else {
                    [GMPAlertService showInfoAlertControllerWithTitle:@"" andMessage:LOCALIZED(@"Something wrong, try again") forController:weakSelf withCompletion:nil];
                }
                
            }];
           break;
        }
        case GMPSearchTypeCurrentPlacing: {
            break;
        }
        case GMPSearchTypeGeonumbers: {
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
    [self searchCurrentGeodata];
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
