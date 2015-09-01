//
//  GMPSearchWithAddressViewController.h
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseSearchView.h"

@class GMPLocationAddress;
@class GMPSearchWithAddressView;

@protocol GMPSearchWithAdressDelegate;

extern NSString *const kCity;
extern NSString *const kStreet;
extern NSString *const kHome;


@interface GMPSearchWithAddressView : GMPBaseSearchView

@property(weak, nonatomic) id<GMPSearchWithAdressDelegate> delegate;

@end


@protocol GMPSearchWithAdressDelegate <NSObject>

@optional
- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(GMPLocationAddress *)address;

@end
