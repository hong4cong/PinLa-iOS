//
//  ProductEntity.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface ProductEntity : BaseEntity

@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *prop_detail;
@property(nonatomic,strong)NSString *prop_father_id;
@property(nonatomic,strong)NSString *prop_icon;
@property(nonatomic,strong)NSString *prop_quality;
@property(nonatomic,strong)NSString *prop_title;

@end
