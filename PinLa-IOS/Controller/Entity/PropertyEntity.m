//  道具实体
//  PropertyEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PropertyEntity.h"

@implementation PropertyEntity

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"prop_status":@"status"
             };
}

+ (PropertyEntity *)parsePropertyWithJson:(id)json{
    
    return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parsePropertyArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end
