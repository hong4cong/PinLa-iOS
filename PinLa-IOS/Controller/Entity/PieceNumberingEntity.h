//
//  PieceNumbering.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/21.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface PieceNumberingEntity : BaseEntity

@property (nonatomic,strong)NSArray         *piece_list;
@property (nonatomic,strong)NSString        *piece_icon;
@property (nonatomic,strong)NSString        *piece_title;
@property (nonatomic,strong)NSString        *piece_detail;      //碎片信息
@property (nonatomic,strong)NSString        *prop_father_id;

@property (nonatomic,strong)NSString        *piece_branch;

@end
