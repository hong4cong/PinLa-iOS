//
//  PolyUserEntity.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "CoordinateEntity.h"
//聚合点 用户entity
@interface PolyUserEntity : BaseEntity

@property(nonatomic, strong)CoordinateEntity      *coordinate;
@property(nonatomic,strong)NSArray* user_id;
@property(nonatomic,assign)NSInteger user_num;

+ (NSArray*)parsePolyUserArrayWithKeyValuesArray:(id)json;

@end
