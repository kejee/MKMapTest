//
//  APAnnotation.m
//  AppleMapDemo
//
//  Created by apple on 2022/5/13.
//

#import "APAnnotation.h"

@implementation APAnnotation

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.coordinate = CLLocationCoordinate2DMake([dict[@"coordinate"][@"latitude"] doubleValue], [dict[@"coordinate"][@"longitude"] doubleValue]);
        self.title = dict[@"title"];
        self.subtitle = dict[@"subtitle"];
        
    }
    
    return self;
}

@end
