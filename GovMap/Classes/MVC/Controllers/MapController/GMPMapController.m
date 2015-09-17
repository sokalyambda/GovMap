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
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControl;

@property (strong, nonatomic) GMPLocationObserver *locationObserver;
@property (strong, nonatomic) GMPUserAnnotation *annotation;
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
    
    [self.mapTypeSegmentControl setTitle:LOCALIZED(@"Standart Map") forSegmentAtIndex:0];
    [self.mapTypeSegmentControl setTitle:LOCALIZED(@"Satellite Map") forSegmentAtIndex:1];
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
            pinView = [[MKPinAnnotationView
                        alloc] initWithAnnotation:annotation
                       reuseIdentifier:NSStringFromClass([GMPUserAnnotation class])];
            
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
        case MKAnnotationViewDragStateStarting: {
            WEAK_SELF;
            
            // Check for connection
            [GMPReachabilityService checkConnectionOnSuccess:^{ } failure:^(NSError *error) {
                
                view.dragState = MKAnnotationViewDragStateCanceling;
                [GMPAlertService showDialogAlertWithTitle:LOCALIZED(@"")
                                               andMessage:LOCALIZED(@"No internet connection. Do you want to try again?")
                                            forController:self
                                    withSuccessCompletion:^{
                                        
                                    }
                                        andFailCompletion:^{
                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                        }];
            }];
            break;
        }
            
        case MKAnnotationViewDragStateDragging: {
            WEAK_SELF;
            
            [[GMPGoogleGeocoder sharedInstance] geocodeLocation:[[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude]
                                              completionHandler:^(GMPLocationAddress *address, NSError *error) {
                                                  if (!error) {
                                                      [annotation setTitle:LOCALIZED(address.fullAddress)];
                                                      weakSelf.currentAddress = address;
                                                  } else {
                                                      // Google geocoding error
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
        case MKAnnotationViewDragStateEnding: {
            [annotation setSubtitle:@""];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    // GOOGLE Manager
    [[GMPGoogleGeocoder sharedInstance] geocodeLocation:location
                                      completionHandler:^(GMPLocationAddress *address, NSError *error) {
                                          if (!error) {
                                              
                                              if (!weakSelf.currentAddress) {
                                                  weakSelf.currentAddress = address;
                                              }
                                              weakSelf.annotation = [[GMPUserAnnotation alloc] initWithLocation:coordinate title:weakSelf.currentAddress.fullAddress];
                                              [weakSelf.mapView addAnnotation:weakSelf.annotation];
                                              
                                              [weakSelf searchCurrentGeodata];
                                          } else {
                                              // Google geocoding error
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
}

/**
 *  Setup first map's appearance
 */
- (void)setupMapAppearing
{
    WEAK_SELF;
    
    // Internet check SUCCESS
    [GMPReachabilityService checkConnectionOnSuccess:^{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
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
                            } else {
                                // Google geocoding error
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
        
        // Internet check FAILED
    } failure:^(NSError *error) {
        [GMPAlertService showDialogAlertWithTitle:LOCALIZED(@"")
                                       andMessage:LOCALIZED(@"No internet connection. Do you want to try again?")
                                    forController:self
                            withSuccessCompletion:^{
                                [weakSelf setupMapAppearing];
                            }
                                andFailCompletion:^{
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];
    }];
}

- (void)searchCurrentGeodata
{
    WEAK_SELF;
    [self.communicator requestCadastralNumbersWithAddress:self.currentAddress.fullAddress completionBlock:^(GMPCadastre *cadastralInfo) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.mapView selectAnnotation:weakSelf.annotation animated:YES];
        if (cadastralInfo) {
            [weakSelf.annotation setSubtitle:[NSString stringWithFormat:@"%@ %ld %@ %ld", LOCALIZED(@"Lot "), cadastralInfo.major, LOCALIZED(@"Parcel "), cadastralInfo.minor]];
        } else {
            [weakSelf.annotation setSubtitle:[NSString localizedStringWithFormat:@"%@", LOCALIZED(@"Can't find Lot & Parcel")]];
        }
    }];
}

#pragma mark - Actions

- (IBAction)mapViewTypeChanged:(id)sender
{
    if (self.mapTypeSegmentControl.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else {
        self.mapView.mapType = MKMapTypeSatellite;
    }
}

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
