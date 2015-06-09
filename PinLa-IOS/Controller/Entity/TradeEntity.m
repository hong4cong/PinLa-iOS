//
//  TradeEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "TradeEntity.h"
#import "PropertyEntity.h"
#import "PieceEntity.h"

@implementation TradeEntity

+ (NSDictionary *)objectClassInArray{
    return @{
             @"trade_piece_list":[PieceEntity class],
             @"trade_prop_list":[PropertyEntity class],
             @"user_info":[UserEntity class],
             };
}

+ (TradeEntity *)parseTradeWithJson:(id)json{
    
    return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parseTradeArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}


@end
