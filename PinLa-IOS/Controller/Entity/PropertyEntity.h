//  道具实体
//  PropertyEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface PropertyEntity : BaseEntity

@property (nonatomic, strong) NSString      *prop_father_id;    //碎片对应道具的父id
@property (nonatomic, strong) NSString      *prop_id;           //道具编号
@property (nonatomic, strong) NSString      *prop_title;        //道具名
@property (nonatomic, strong) NSString      *prop_detail;       //道具信息
@property (nonatomic, strong) NSString      *prop_validity;     //道具有效期
@property (nonatomic, assign) NSInteger      prop_type;         //道具类型
@property (nonatomic, strong) NSString      *prop_attr;         //道具属性
@property (nonatomic, assign) NSInteger      prop_lock;         //道具是否锁定
@property (nonatomic, strong) NSString      *prop_icon;         //道具图片
@property (nonatomic, assign) NSInteger      prop_status;       //道具状态

@property (nonatomic, assign) NSInteger      prop_quality;

@end
