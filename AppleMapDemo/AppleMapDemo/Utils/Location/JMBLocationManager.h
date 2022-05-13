//
//  JMBLocationManager.h
//  JMBox
//
//  Created by apple on 2022/4/28.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JMBLocationError) {
    kJMBLocationFail,
    kJMBAuthorizationStatusDenied,
    kJMBFullAccuracyLocation API_AVAILABLE(ios(14.0)),
    kJMBReducedAccuracyLocation API_AVAILABLE(ios(14.0))
};

@interface JMBLocationManager : NSObject

+ (instancetype)sharedManager;
//默认不需要接收这个回调
@property (nonatomic, copy) void (^handleErrorCallBack)(JMBLocationError error, NSString *info);

- (void)updatingLocation;
/*
 [[JMBLocationManager sharedManager] getFullAccuracyLocation:^(NSError * _Nullable error) {
     [[JMBLocationManager sharedManager] updatingLocation];
 }];
 */
- (void)getFullAccuracyLocation:(void(^ _Nullable)(NSError * _Nullable))completion;
//结果回调
@property (nonatomic, copy) void (^handleResultCallBack)(CLLocation * _Nullable location, CLPlacemark * _Nullable placeMark, NSString * _Nullable shorName);

@end

NS_ASSUME_NONNULL_END


