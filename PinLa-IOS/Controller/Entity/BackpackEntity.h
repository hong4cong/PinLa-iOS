//
//  BackpackEntity.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface BackpackEntity : BaseEntity

@property(nonatomic,assign)NSInteger bag_num;
@property(nonatomic,assign)NSInteger use_bag;
@property(nonatomic,strong)NSArray* piece_list;

@property(nonatomic,strong)NSArray* prop_list;

+ (BackpackEntity *)parseBackpackWithJson:(id)json;

@end
