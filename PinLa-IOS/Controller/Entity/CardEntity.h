//  卡券实体
//  CardEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface CardEntity : BaseEntity

@property (nonatomic, strong) NSString      *card_father_id;    //卡片父id
@property (nonatomic, strong) NSString      *card_id;           //卡片编号
@property (nonatomic, strong) NSString      *card_title;        //卡片名
@property (nonatomic, strong) NSString      *card_detail;       //卡片信息
@property (nonatomic, strong) NSString      *card_validity;     //卡片有效期
@property (nonatomic, assign) NSInteger      card_use;          //卡片是否使
@property (nonatomic, assign) NSInteger      card_type;         //卡片类型
@property (nonatomic, assign) NSInteger      card_attr;         //卡片属性
@property (nonatomic, strong) NSString      *card_icon;         //icon
@property (nonatomic, strong) NSString      *card_no;
@property (nonatomic, strong) NSString      *exchange;

@end
