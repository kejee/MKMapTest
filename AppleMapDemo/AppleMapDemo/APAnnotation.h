//
//  APAnnotation.h
//  AppleMapDemo
//
//  Created by apple on 2022/5/13.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
