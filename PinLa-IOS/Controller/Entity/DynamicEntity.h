//  动态实体
//  DynamicEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "DynamicPicEntity.h"

@interface DynamicEntity : BaseEntity

@property (nonatomic, assign) NSInteger     dynamic_type;	//动态类型INT 拾取，交易
@property (nonatomic, strong) NSString     *dynamic_titile;	//动态title	STRING
@property (nonatomic, strong) NSString     *dynamic_detail;	//动态描述	STRING
@property (nonatomic, strong) NSString     *dynamic_time;	//动态时间	STRING(12321312系统毫秒级时间)
@property (nonatomic, strong) NSArray      *dynamic_pic_list;	//展示内容

+ (NSArray*)parseDynamicListWithKeyValuesArray:(id)json;

@end
