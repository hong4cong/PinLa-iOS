//
//  DynamicEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "DynamicEntity.h"

@implementation DynamicEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"dynamic_pic_list" : [DynamicPicEntity class],
             };
}

+ (NSArray*)parseDynamicListWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end
