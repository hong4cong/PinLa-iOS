//
//  BackpackEntity.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BackpackEntity.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"

@implementation BackpackEntity

+ (NSDictionary *)objectClassInArray{
    return @{
             @"piece_list":[PieceEntity class],
             @"prop_list":[PropertyEntity class]
             };
}

+ (BackpackEntity *)parseBackpackWithJson:(id)json{
    return [self parseObjectWithKeyValues:json];
}

@end
