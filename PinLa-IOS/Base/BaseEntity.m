//
//  BaseEntity.m
//  ZLYDoc
//
//  Created by Ryan on 14-4-3.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "BaseEntity.h"
#import "DateUtils.h"


@interface BaseEntity ()

@end

@implementation BaseEntity



+ (NSArray *)parseObjectArrayWithKeyValuesArray:(id)json

{
    if([NSJSONSerialization isValidJSONObject:json]){
        
        NSArray * result = nil;
        @try {
            result = [self objectArrayWithKeyValuesArray:json];
        }
        @catch (NSException *exception) {
            
            DLog(@"error = %@",exception.description);
            return nil;
        }
        
        return result;
    }else{
        return [NSArray array];
    }
}

+ (id)parseObjectWithKeyValues:(NSDictionary *)keyValues
{
    id result = nil;
    @try {
        result = [self objectWithKeyValues:keyValues];
    }
    @catch (NSException *exception) {
        
        DLog(@"error = %@",exception.description);
        return nil;
    }
    return result;
}

@end
