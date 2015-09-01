//
//  GMPSearchWithGeoNumbersView.h
//  GovMap
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPBaseSearchView.h"

@class GMPSearchWithGeoNumbersView;
@protocol GMPSearchWithGeoNumbersDelegate;

extern NSString *const kBlock;
extern NSString *const kSubblock;


@interface GMPSearchWithGeoNumbersView : GMPBaseSearchView

@property(weak, nonatomic) id<GMPSearchWithGeoNumbersDelegate> delegate;

@end


@protocol GMPSearchWithGeoNumbersDelegate <NSObject>

@optional
- (void)searchWithGeoNumbersView:(GMPSearchWithGeoNumbersView *)searchView didPressSearchButtonWithGeoNumbers:(NSDictionary *)geoNumbers;

@end
