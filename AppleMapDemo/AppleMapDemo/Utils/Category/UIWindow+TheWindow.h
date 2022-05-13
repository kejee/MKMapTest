//
//  UIWindow+TheWindow.h
//  JMBox
//
//  Created by apple on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TheWindow)
+ (UIWindow *)theWindow;
+ (UIEdgeInsets)edgeValue;
+ (UINavigationController *)topNavigationController;
+ (UIViewController *)currentVisibleViewController;


@end

NS_ASSUME_NONNULL_END
