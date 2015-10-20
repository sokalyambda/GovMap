//
//  GMPAlertService.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPAlertService.h"

#import "GMPBaseNavigationController.h"

#import "AppDelegate.h"

@implementation GMPAlertService

+ (void)showInfoAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)controller withCompletion:(void(^)())completion
{
    if (!controller) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion();
        }
    }];
    [alertController addAction:confirmAction];
    [self showCurrentAlertController:alertController forController:controller];
    
}

+ (void)showDialogAlertWithTitle:(NSString *)title andMessage:(NSString *)message forController:(UIViewController *)controller withSuccessCompletion:(void(^)())successCompletion andFailCompletion:(void(^)())failCompletion
{
    if (!controller) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction
                                    actionWithTitle:LOCALIZED(@"Cancel")
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction *action) {
                                        if (failCompletion) {
                                            failCompletion();
                                        }
                                    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:LOCALIZED(@"OK")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (successCompletion) {
                                 successCompletion();
                             }
                         }];
    
    [alertController addAction:ok];
    [self showCurrentAlertController:alertController forController:controller];
}

+ (void)showChangeLocationPermissionsAlertForController:(UIViewController *)controller andCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZED(@"Location services are off") message:LOCALIZED(@"Location services are disabled, to use all functionality of application, please enable them in Settings menu.") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion) {
            completion(action, YES);
        }
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Go to Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        if (completion) {
            completion(action, NO);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self showCurrentAlertController:alertController forController:controller];
}

+ (void)showCurrentAlertController:(UIAlertController *)alertController forController:(UIViewController *)currentController
{
    if (!currentController) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        GMPBaseNavigationController *navigationController = (GMPBaseNavigationController *)appDelegate.window.rootViewController;
        UIViewController *lastPresentedViewController = ((UIViewController *)navigationController.viewControllers.lastObject).presentedViewController;
        
        if (lastPresentedViewController) {
            [lastPresentedViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            [navigationController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        [currentController presentViewController:alertController animated:YES completion:nil];
    }
}

@end