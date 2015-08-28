//
//  GMPSearchWithAddressViewController.h
//  GovMap
//
//  Created by Pavlo on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPSearchWithAddressView;

@protocol GMPSearchWithAdressDelegate <NSObject>

@optional
- (void)searchWithAddressView:(GMPSearchWithAddressView *)searchView didPressSearchButtonWithAddress:(NSDictionary *)address;

@end

@interface GMPSearchWithAddressView : UIView

@property(weak, nonatomic) id<GMPSearchWithAdressDelegate> delegate;

@end
