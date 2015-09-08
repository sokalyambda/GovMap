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
#import "GMPGoogleGeocoder.h"

#import "GMPUserAnnotation.h"

#import "GMPWazeNavigationService.h"

#import "GMPLocationAddressParser.h"

#import "GMPCadastre.h"

#import "GMPCommunicatorDelegate.h"

static NSString *const kAddressNotFound = @"לא נמצאו תוצאות מתאימות";

@interface GMPMapController () <MKMapViewDelegate, GMPCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goToWazeButton;

@property (strong, nonatomic) GMPLocationObserver *locationObserver;
@property (strong, nonatomic) GMPUserAnnotation *annotation;
@property (strong, nonatomic) GMPCommunicator *communicator;

@property (assign, nonatomic) CLLocationCoordinate2D previousCoordinate;

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
    GMPUserAnnotation *annotation = (GMPUserAnnotation *)view.annotation;
    switch (newState) {
        case MKAnnotationViewDragStateDragging: {
            WEAK_SELF;
            
            [[GMPGoogleGeocoder sharedInstance] geocodeLocation:[[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]
                                              completionHandler:^(GMPLocationAddress *address, NSError *error) {
                                                  if (!error) {
                                                      [annotation setTitle:LOCALIZED(address.fullAddress)];
                                                      weakSelf.currentAddress = address;
                                                  }
                                              }];
            break;
        }
        case MKAnnotationViewDragStateEnding: {
            [annotation setSubtitle:@""];
            [self searchCurrentGeodata];
            break;
        }
        default:
            break;
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
    
    // GOOGLE Manager
    [[GMPGoogleGeocoder sharedInstance] geocodeLocation:location
                                      completionHandler:^(GMPLocationAddress *address, NSError *error) {
        if (!error) {
            weakSelf.annotation = [[GMPUserAnnotation alloc] initWithLocation:coordinate title:address.fullAddress];
            [weakSelf.mapView addAnnotation:weakSelf.annotation];
            
            if (!weakSelf.currentAddress) {
                weakSelf.currentAddress = address;
            }
            [weakSelf searchCurrentGeodata];
        }
    }];
}

/**
 *  Setup first map's appearance
 */
- (void)setupMapAppearing
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WEAK_SELF;
    switch (self.currentSearchType) {
        case GMPSearchTypeAddress: {
            
            // GOOGLE Manager
            [[GMPGoogleGeocoder sharedInstance] reverseGeocodeAddress:self.currentAddress completionHandler:^(CLLocation *location, NSError *error) {
                
                if (!error) {
                    [weakSelf setupMapAttributesForCoordinate:location.coordinate];
                } else {
                    
                    [GMPAlertService showDialogAlertWithTitle:LOCALIZED(@"")
                                                   andMessage:LOCALIZED(@"Address not found")
                                                forController:self
                                        withSuccessCompletion:^{
                                            [weakSelf setupMapAppearing];
                                        }
                                            andFailCompletion:^{
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
                
                NSString *addressData = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (addressData && ![addressData isEqualToString:kAddressNotFound]) {
                    
                    // GOOGLE Manager
                    GMPLocationAddress *locAddress = [GMPLocationAddressParser locationAddressWithGovMapAddress:address];
                    [[GMPGoogleGeocoder sharedInstance] reverseGeocodeAddress:locAddress completionHandler:^(CLLocation *location, NSError *error) {
                        if (!error) {
                            [weakSelf setupMapAttributesForCoordinate:location.coordinate];
                        }
                    }];
                    
                } else {
                    WEAK_SELF;
                    [GMPAlertService showDialogAlertWithTitle:LOCALIZED(@"")
                                                   andMessage:LOCALIZED(@"Address not found")
                                                forController:self
                                        withSuccessCompletion:^{
                                            [weakSelf setupMapAppearing];
                                        }
                                            andFailCompletion:^{
                                                [weakSelf.navigationController popViewControllerAnimated:YES];
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
    [self.communicator requestCadastralNumbersWithAddress:self.currentAddress.fullAddress completionBlock:^(GMPCadastre *cadastralInfo) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.mapView selectAnnotation:weakSelf.annotation animated:YES];
        if (cadastralInfo) {
            [weakSelf.annotation setSubtitle:[NSString localizedStringWithFormat:@"%@ %ld, %@ %ld", LOCALIZED(@"Block "), (long)cadastralInfo.major, LOCALIZED(@"Smooth "), (long)cadastralInfo.minor]];
        } else {
            [weakSelf.annotation setSubtitle:[NSString localizedStringWithFormat:@"%@", LOCALIZED(@"Can't find Block & Smooth")]];
        }
    }];
}

#pragma mark - Actions

- (IBAction)goToWazeClick:(id)sender
{
    CLLocationCoordinate2D coord = self.annotation.coordinate;
    [GMPWazeNavigationService navigateToWazeWithLatitude:coord.latitude longitude:coord.longitude];
}

/**
 *  Customize current navigation item
 */
- (void)customizeNavigationItem
{
    self.goToWazeButton.title = LOCALIZED(@"Open Waze");
    self.navigationItem.rightBarButtonItems = @[self.goToWazeButton];
}

@end
