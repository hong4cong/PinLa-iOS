//
//  PieceItemEntity.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface PieceItemEntity : BaseEntity

@property (nonatomic,strong)NSArray         *lock_id;
@property (nonatomic,strong)NSArray         *normal_id;
@property (nonatomic,strong)NSString        *piece_branch;

@end
