//
//  GMPSearchWithAddressViewController.h
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPSearchWithAddressView;
@protocol GMPSearchWithAdressDelegate;

extern NSString *const kCity;
extern NSString *const kStreet;
extern NSString *const kHome;


@interface GMPSearchWithAddressView : UIView

@property(weak, nonatomic) id<GMPSearchWithAdressDelegate> delegate;

@end


@protocol GMPSearchWithAdressDelegate <NSObject>

@optional
- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(NSDictionary *)address;

@end
