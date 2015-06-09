//
//  HotspotEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HotspotEntity.h"

@implementation HotspotEntity

MJCodingImplementation

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{
        @"user_list":[UserEntity class]
             };
}

@end
