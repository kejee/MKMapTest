//
//  JMBLocationStatusAlertView.m
//  JMBox
//
//  Created by apple on 2022/4/29.
//

#import "JMBLocationStatusAlertView.h"
#import "UIWindow+TheWindow.h"

@implementation JMBLocationStatusAlertView

+ (void)goSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            
        }];
    }
}

+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message {
    [self showAlertWithTitle:title Message:message CancelTitle:NSLocalizedString(@"取消", nil) OtherAction:NSLocalizedString(@"去设置", nil)];
}


+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelTitle OtherAction:(NSString *)otherTitle {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancel];
    
    UIAlertAction *setting = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goSettings];
    }];
    
    [alertController addAction:setting];
    
    UIViewController *vc = [UIWindow currentVisibleViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
    
}


@end
