//
//  GMPAlertService.h
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface GMPAlertService : NSObject

+ (void)showInfoAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)())completion;

+ (void)showDialogAlertWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)controller withSuccessCompletion:(void(^)())successCompletion andFailCompletion:(void(^)())failCompletion;

+ (void)showChangeLocationPermissionsAlertForController:(UIViewController *)controller andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

@end
