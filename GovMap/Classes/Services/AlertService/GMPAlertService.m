//
//  GMPAlertService.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPAlertService.h"

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller.navigationController.visibleViewController presentViewController:alertController animated:YES completion:nil];
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller.navigationController.visibleViewController presentViewController:alertController animated:YES completion:nil];
    });

}

@end
