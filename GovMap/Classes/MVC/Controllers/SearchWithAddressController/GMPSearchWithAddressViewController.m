//
//  GMPSearchWithAddressViewController.m
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPSearchWithAddressViewController.h"
#import "GMPSearchWithAddressView.h"

@interface GMPSearchWithAddressViewController () <GMPSearchWithAdressDelegate>

@property (weak, nonatomic) IBOutlet GMPSearchWithAddressView *searchWithAddressView;

@end

@implementation GMPSearchWithAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchWithAddressView.delegate = self;
}

#pragma mark - GMPSearchWithAddressDelegate methods

- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(NSDictionary *)address{
    NSLog(@"City: %@, street: %@, home: %@", address[kCity], address[kStreet], address[kHome]);
}

@end
