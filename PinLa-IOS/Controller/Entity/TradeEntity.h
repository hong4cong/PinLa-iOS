//
//  TradeEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "UserEntity.h"

@interface TradeEntity : BaseEntity


@property (nonatomic, strong) NSString  *trade_id;
@property (nonatomic, strong) NSString  *trade_detail;
@property (nonatomic, strong) NSArray   *trade_piece_list;
@property (nonatomic, strong) NSArray   *trade_prop_list;
@property (nonatomic, strong) NSArray   *trade_num;
@property (nonatomic, strong) NSString  *trade_child_id;
@property (nonatomic, strong) NSString  *user_icon;

+ (TradeEntity *)parseTradeWithJson:(id)json;
+ (NSArray*)parseTradeArrayWithKeyValuesArray:(id)json;


@end
