//
//  APMapViewController.m
//  AppleMapDemo
//
//  Created by apple on 2022/5/13.
//

#import "APMapViewController.h"
//#import "JMBLocationManager.h"
#import <MapKit/MapKit.h>
#import "APAnnotation.h"

@interface APMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;

@property (nonatomic, strong) NSMutableArray *locationArray;

@end

@implementation APMapViewController

- (NSMutableArray *)locationArray {
    if (_locationArray == nil) {
        _locationArray = [[NSMutableArray alloc] init];
    }
    return _locationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeMapView];
//    [self loadTestData];
    
    
//    [JMBLocationManager sharedManager].handleResultCallBack = ^(CLLocation * _Nullable location, CLPlacemark * _Nullable placeMark, NSString * _Nullable shorName) {
//
////        self.textView.text = shorName;
////        if (!shorName) {
////            self.textView.text = NSLocalizedString(@"位置未知", nil);
////        }
//    };
    
    
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[JMBLocationManager sharedManager] updatingLocation];
    
}

- (void)initializeMapView {
    self.mapView.delegate = self;
    
    //MKMapTypeStandard = 0, // 标准地图
    //MKMapTypeSatellite, // 卫星云图
    //MKMapTypeHybrid, // 混合(在卫星云图上加了标准地图的覆盖层)
    //MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D立体
    //MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D混合
    self.mapView.mapType = MKMapTypeStandard;
   
    //是否可以滚动
    self.mapView.scrollEnabled = YES;
    //缩放
    self.mapView.zoomEnabled = YES;
    //旋转
    self.mapView.rotateEnabled = YES;
    
    // 显示建筑物
    self.mapView.showsBuildings = YES;
    // 指南针
    self.mapView.showsCompass = YES;
    // 兴趣点
//    self.mapView.pointOfInterestFilter = ;
    // 比例尺
    self.mapView.showsScale = YES;
    // 交通
    self.mapView.showsTraffic = YES;
    
    
    // 显示用户位置
//    [self locationM];
    // 显示用户位置, 但是地图并不会自动放大到合适比例
//    self.mapView.showsUserLocation = YES;
    
    /**
     *  MKUserTrackingModeNone = 0, 不追踪
     MKUserTrackingModeFollow,  追踪
     MKUserTrackingModeFollowWithHeading, 带方向的追踪
     */
    // 不但显示用户位置, 而且还会自动放大地图到合适的比例(也要进行定位授权)
    // 不灵光
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    
    
}

//让地图显示标注的区域
//[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];

- (void)loadTestData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"PinData" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *dict in tempArray) {
        APAnnotation *myAnnotationModel = [[APAnnotation alloc]initWithAnnotationModelWithDict:dict];
        
        [self.locationArray addObject:myAnnotationModel];
    }
    
    [self.mapView addAnnotations:self.locationArray];
    
}


- (void)makeMapView:(MKMapView *)mapView regionFitWith:(CLLocationCoordinate2D)coordinate {
//    MKCoordinateRegion region;
//    region.center = coordinate;
//    region.span = MKCoordinateSpanMake(0.01, 0.01);
//    region = [mapView regionThatFits:region];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [mapView setRegion:region animated:YES];
    
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    userLocation.title  = @"当前位置";
//    userLocation.subtitle = @"😊";
    
//    [self makeMapView:mapView regionFitWith:userLocation.coordinate];
    
//    如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    [self loadTestData];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *ID = @"anno";
    
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示气泡
        annoView.canShowCallout = YES;
        //
//        annoView.pinTintColor = ;
        //显示图片,取代大头针
        annoView.image = [UIImage imageNamed:@"datouzhen"];

        //在气泡视图中显示图片
//        annoView.rightCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datouzhen"]];
        
        
    }
    
    return annoView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"选中了标注");
    
    //让地图显示标注的区域
//    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    [self makeMapView:mapView regionFitWith:view.annotation.coordinate];
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"取消了标注");
}



@end
