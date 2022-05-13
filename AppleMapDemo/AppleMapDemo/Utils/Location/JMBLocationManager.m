//
//  JMBLocationManager.m
//  JMBox
//
//  Created by apple on 2022/4/28.
//

#import "JMBLocationManager.h"
#import "JMBLocationStatusAlertView.h"

@interface JMBLocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
//用来设置60秒内，使用旧数据
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLPlacemark *lastPlaceMark;
@end

@implementation JMBLocationManager

+ (instancetype)sharedManager {
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeLocationService];
    }
    return self;
}

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestWhenInUseAuthorization];
    
//    [self updatingLocation];
    
}

- (void)updatingLocation {
    [_locationManager startUpdatingLocation];
}

- (void)getFullAccuracyLocation:(void(^ _Nullable)(NSError * _Nullable))completion {
    if (@available(iOS 14.0, *)) {
        [_locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"evidence" completion:^(NSError * _Nullable error) {
            NSLog(@"%@", error);
            if (completion) {
                completion(error);
            }
        }];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    NSLog(@"locationManagerDidChangeAuthorization");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (@available(iOS 14.0, *)) {
        CLAccuracyAuthorization accuracyAuthorization = manager.accuracyAuthorization;
        if (accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
            NSLog(@"模糊的位置信息");
            if (self.handleErrorCallBack) {
                self.handleErrorCallBack(kJMBReducedAccuracyLocation, @"模糊的位置信息");
            } else {
                [JMBLocationStatusAlertView showAlertWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"为了提高定位精确度，请在App设置中打开「位置-精确位置」选项", nil)];
            }
            
        } else {
            NSLog(@"准确的位置信息");
            if (self.handleErrorCallBack) {
                self.handleErrorCallBack(kJMBFullAccuracyLocation, @"准确的位置信息");
            }
        }
    }
    
    //locations is an array of CLLocation objects in chronological order.(按时间顺序排列)
    __block CLLocation *location = [locations lastObject];
    
    NSLog(@"location: %g, %g, \n%@\nfloor:%@", location.coordinate.latitude, location.coordinate.longitude, locations, location.floor);
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            //这里面出错一般是没联网
            NSLog(@"geoCoder error:%@", error.localizedDescription);
            if (self.handleResultCallBack) {
                NSTimeInterval timeInterval = [location.timestamp timeIntervalSinceDate:self.lastLocation.timestamp];
                //设置60秒内，使用旧数据
                if (timeInterval > 60) {
                    self.handleResultCallBack(location, nil, nil);
                } else {
                    self.handleResultCallBack(self.lastLocation, self.lastPlaceMark, self.lastPlaceMark.name);
                }
            }
            
            return;
        }
        for (int i = 0; i < placemarks.count; ++i) {
            CLPlacemark *placeMark = placemarks[i];
        
            if (self.handleResultCallBack) {
                self.handleResultCallBack(location, placeMark, placeMark.name);
            }
            
            self.lastPlaceMark = placeMark;
            
            
            NSLog(@"%@",placeMark.country);//当前国家
            NSLog(@"%@",placeMark.locality);//当前国家
            NSLog(@"%@",placeMark.subLocality);//当前的位置
            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            NSLog(@"%@",placeMark.name);//具体地址
        }
        
        self.lastLocation = location;
        
        
    }];
    
    

    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location error: %@", error);
    
    if (error && self.handleResultCallBack) {
        self.handleResultCallBack(nil, nil, nil);
    }
    
    CLAuthorizationStatus authorizationStatus;
    if (@available(iOS 14.0, *)) {
        authorizationStatus = manager.authorizationStatus;
    } else {
        authorizationStatus = [CLLocationManager authorizationStatus];
    }
    
    switch (authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户尚未对该应用做出选择(允许一次)");
            [JMBLocationStatusAlertView showAlertWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"如已定位，请忽略。\n选择「位置-使用期间（或者始终）」，或者重启App", nil) CancelTitle:NSLocalizedString(@"忽略", nil) OtherAction:NSLocalizedString(@"去设置", nil)];
            
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"此应用程序未被授权使用位置服务");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户已经明确地拒绝了对该应用的授权, 定位服务在App设置中被禁用");
            if (self.handleErrorCallBack) {
                self.handleErrorCallBack(kJMBAuthorizationStatusDenied, @"定位服务在App设置中被禁用");
            } else {
                [JMBLocationStatusAlertView showAlertWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"请在App设置中允许定位服务", nil)];
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"用户已经授权在任何时候使用他们的位置");
            break;
        // -allowsBackgroundLocationUpdates.
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"用户已经获得授权，只在使用你的应用程序时使用他们的位置");
            break;
        default:
            break;
    }
    
    
}


@end
