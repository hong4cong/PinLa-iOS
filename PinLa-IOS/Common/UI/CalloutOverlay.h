//
//  CalloutOverlay.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HexagonOverlay.h"

@interface CalloutOverlay : NSObject<MAOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

@property (nonatomic, readonly) CLLocationDistance radius;

@property (nonatomic, strong)NSArray* user_id;

@property (nonatomic, assign) NSInteger     hotspot_level;

- (id)initWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius;


@end
