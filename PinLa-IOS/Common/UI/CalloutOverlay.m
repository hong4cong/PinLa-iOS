//
//  CalloutOverlay.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CalloutOverlay.h"

@interface CalloutOverlay ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) MAMapRect boundingMapRect;
@property (nonatomic, readwrite) CLLocationDistance radius;

@end

@implementation CalloutOverlay


- (id)initWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius
{
    if (self = [super init])
    {
        self.coordinate     = center;
        self.radius         = radius;
        
        MAMapPoint point    = MAMapPointForCoordinate(center);
        double width_2      = MAMapPointsPerMeterAtLatitude(center.latitude) * radius;
        
        self.boundingMapRect = MAMapRectMake(point.x - width_2, point.y - width_2, width_2 * 2, width_2 * 2);
    }
    
    return self;
}

@end
