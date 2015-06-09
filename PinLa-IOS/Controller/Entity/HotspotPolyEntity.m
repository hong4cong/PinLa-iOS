//
//  HotspotPolyEntity.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HotspotPolyEntity.h"
#import "HotspotEntity.h"
#import "PolyUserEntity.h"

@implementation HotspotPolyEntity

MJCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{
             @"user_list":[PolyUserEntity class],
             @"hotspot_list":[HotspotEntity class]
             };
}

+ (HotspotPolyEntity *)parseHotspotPolyUserWithJson:(id)json{
    
    return [self parseObjectWithKeyValues:json];
}

@end
