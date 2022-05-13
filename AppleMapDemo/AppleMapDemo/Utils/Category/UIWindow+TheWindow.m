//
//  UIWindow+TheWindow.m
//  JMBox
//
//  Created by apple on 2022/4/25.
//

#import "UIWindow+TheWindow.h"

@implementation UIWindow (TheWindow)

+ (UIWindow *)theWindow {
//    当只支持 >=iOS 13,并且使用了SceneDelegate
    if (@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        if (array.count == 0) {
            return [UIApplication sharedApplication].windows.lastObject;
        }
        UIWindowScene *windowScene = (UIWindowScene *)array[0];
        /*
         SceneDelegate * delegate = (SceneDelegate *)windowScene.delegate;
         UIWindow * mainWindow = delegate.window;
         */
        UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
        if (mainWindow) {
            return mainWindow;
        } else {
            return [UIApplication sharedApplication].windows.lastObject;
        }
    } else {
        return [UIApplication sharedApplication].delegate.window;
    }
    
}


+ (UIEdgeInsets)edgeValue {
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edge = [self theWindow].safeAreaInsets;
    }
    return edge;
}

+ (UINavigationController *)topNavigationController {
    UIWindow *window = [self theWindow];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController.navigationController;
}

+ (UIViewController *)currentVisibleViewController {
    UIWindow *window = [self theWindow];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    UINavigationController *navVC = topViewController.navigationController;
    
    return navVC? navVC.visibleViewController: topViewController;
}

@end
