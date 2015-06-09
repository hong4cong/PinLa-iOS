//
//  BaseEntity.h
//  ZLYDoc
//
//  Created by Ryan on 14-4-3.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#define SUCCESS 0

@interface BaseEntity : NSObject

@property (nonatomic,copy)      NSString    *_id;//ID
@property (nonatomic,copy)      NSString    *msg;//状态信息
@property (nonatomic,assign)    NSInteger    result;

+ (NSArray *)parseObjectArrayWithKeyValuesArray:(id)json;//parseObjectArrayWithJSONData

+ (id)parseObjectWithKeyValues:(NSDictionary *)keyValues;

@end
