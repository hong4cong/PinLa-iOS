//
//  MessageEntity.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/29.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "MessageEntity.h"
#import "PaticipantTradeEntity.h"

@implementation MessageEntity

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"messageDetail":@"msg"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"trade_list":[PaticipantTradeEntity class]
             };
}

+ (NSArray*)parseMessageWithKeyValuesArray:(id)json
{
    return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parseMessageArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end
