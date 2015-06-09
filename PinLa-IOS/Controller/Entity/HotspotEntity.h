//  热点实体
//  HotspotEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "UserEntity.h"
#import "CoordinateEntity.h"

@interface HotspotEntity : BaseEntity

@property (nonatomic, strong) NSString      *hotspot_id; 	//热点编号
@property (nonatomic, assign) NSInteger     hotspot_level;	//热力级别
@property (nonatomic, assign) NSInteger      hotspot_radio;
@property (nonatomic, strong) CoordinateEntity      *coordinate;	//热点位置



@end
