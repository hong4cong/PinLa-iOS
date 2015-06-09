//
//  PieceNumbering.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/21.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PieceNumberingEntity.h"
#import "PieceItemEntity.h"

@implementation PieceNumberingEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"piece_list" : [PieceItemEntity class],
             };
}

@end
