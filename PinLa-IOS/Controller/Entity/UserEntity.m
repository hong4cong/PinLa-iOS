//
//  UserEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

MJCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{
        @"card_list":[CardEntity class],
        @"dynamic_list":[DynamicEntity class]
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
        @"oCoordinate":@"old_coordinate",
        @"nCoordinage":@"new_coordinate"
    };
}

+ (UserEntity *)parseUserWithJson:(id)json{
    
     return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parseUserArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end
