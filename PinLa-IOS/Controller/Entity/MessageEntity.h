//
//  MessageEntity.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/29.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "PaticipantTradeEntity.h"

@interface MessageEntity : BaseEntity

@property (nonatomic,strong)NSString    *type;
@property (nonatomic,strong)NSString    *title;
@property (nonatomic,strong)NSString    *sell_msg;
@property (nonatomic,strong)NSString    *pic;
@property (nonatomic,strong)NSString    *datetime;
@property (nonatomic,strong)NSString    *messageDetail;
@property (nonatomic,strong)PaticipantTradeEntity     *trade_list;
@property (nonatomic,strong)NSString    *message_id;

+ (NSArray*)parseMessageArrayWithKeyValuesArray:(id)json;

+ (NSArray*)parseMessageWithKeyValuesArray:(id)json;

@end
