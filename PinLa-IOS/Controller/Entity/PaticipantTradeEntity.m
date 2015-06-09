//
//  PaticipantExchangeEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PaticipantTradeEntity.h"
#import "TradeEntity.h"

@implementation PaticipantTradeEntity


+ (NSArray*)parsePaticipantTradeArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}



@end
