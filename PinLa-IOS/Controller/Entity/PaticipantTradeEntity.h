//
//  PaticipantExchangeEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "TradeEntity.h"

@interface PaticipantTradeEntity : BaseEntity

@property (nonatomic, strong) NSString      *trade_child_id;
@property (nonatomic, strong) NSString      *trade_id;
@property (nonatomic, strong) TradeEntity       *sell_trade;
@property (nonatomic, strong) TradeEntity       *buy_trade;

+ (NSArray*)parsePaticipantTradeArrayWithKeyValuesArray:(id)json;

@end
