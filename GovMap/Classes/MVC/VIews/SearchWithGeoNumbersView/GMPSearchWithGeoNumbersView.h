//
//  GMPSearchWithGeoNumbersView.h
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@class GMPSearchWithGeoNumbersView;

@protocol GMPSearchWithGeoNumbersDelegate <NSObject>

@optional
- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithGeoNumbers:(NSDictionary *)geoNumbers;

@end

@interface GMPSearchWithGeoNumbersView : UIView

@property(weak, nonatomic) id<GMPSearchWithGeoNumbersDelegate> delegate;

@end
