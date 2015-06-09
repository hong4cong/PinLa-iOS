//  碎片实体
//  PieceEntity.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PieceEntity.h"

@implementation PieceEntity

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"piece_status":@"status"
             };
}

+ (PieceEntity *)parsePieceWithJson:(id)json{
    
    return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parsePieceArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end