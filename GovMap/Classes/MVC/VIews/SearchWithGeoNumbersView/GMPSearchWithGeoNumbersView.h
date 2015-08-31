//
//  GMPSearchWithGeoNumbersView.h
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPSearchWithGeoNumbersView;
@protocol GMPSearchWithGeoNumbersDelegate;

extern NSString *const kLatitude;
extern NSString *const kLongitude;


@interface GMPSearchWithGeoNumbersView : UIView

@property(weak, nonatomic) id<GMPSearchWithGeoNumbersDelegate> delegate;

@end


@protocol GMPSearchWithGeoNumbersDelegate <NSObject>

@optional
- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithGeoNumbers:(NSDictionary *)geoNumbers;

@end
