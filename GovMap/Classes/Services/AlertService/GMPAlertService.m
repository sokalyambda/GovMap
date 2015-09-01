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
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
