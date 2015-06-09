//
//  VersionEntity.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/2/5.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "VersionEntity.h"

@implementation VersionEntity

+ (VersionEntity *)parseVersionStatusJSON:(id)json
{
    return [self parseObjectWithKeyValues:json];
}

@end
