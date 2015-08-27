//
//  GMPMainMenuContainer.h
//  GovMap
//
//  Created by Myroslava Polovka on 8/27/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@protocol GMPMenuViewDelegate;

@interface GMPMenuView : UIView

@property(weak, nonatomic) id<GMPMenuViewDelegate> delegate;

@end

@protocol GMPMenuViewDelegate <NSObject>

@optional
- (void)menuViewDidPressFirstButton:(GMPMenuView *)menuView;
- (void)menuViewDidPressSecondButton:(GMPMenuView *)menuView;
- (void)menuViewDidPressThirdButton:(GMPMenuView *)menuView;

@end