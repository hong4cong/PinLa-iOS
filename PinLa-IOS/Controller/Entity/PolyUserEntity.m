//
//  PolyUserEntity.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PolyUserEntity.h"

@implementation PolyUserEntity

MJCodingImplementation

+ (PolyUserEntity *)parsePolyUserWithJson:(id)json{
    
    return [self parseObjectWithKeyValues:json];
}

+ (NSArray*)parsePolyUserArrayWithKeyValuesArray:(id)json
{
    return [self parseObjectArrayWithKeyValuesArray:json];
}

@end
