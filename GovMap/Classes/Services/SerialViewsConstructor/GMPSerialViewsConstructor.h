//
//  GMPSerialViewsConstructor.h
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface GMPSerialViewsConstructor : NSObject

+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller withAction:(SEL)action;

+ (UIBarButtonItem *)customBarButtonWithImage:(UIImage *)image forController:(UIViewController *)controller withAction:(SEL)action;

@end
