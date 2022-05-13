//
//  JMBLocationStatusAlertView.h
//  JMBox
//
//  Created by apple on 2022/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBLocationStatusAlertView : NSObject
+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelTitle OtherAction:(NSString *)otherTitle;
@end

NS_ASSUME_NONNULL_END
