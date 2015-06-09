//
//  VersionEntity.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/2/5.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "BaseEntity.h"

@interface VersionEntity : BaseEntity

@property (nonatomic,copy) NSString *version;//版本号
@property (nonatomic,copy) NSString *updateURL;//升级URL
@property (nonatomic,copy) NSString *desc;//版本提示信息
@property (nonatomic,copy) NSString *minCode;//最小版本号（若当前版本小于该版本，则需要强制更新）

+ (VersionEntity *)parseVersionStatusJSON:(id)json;

@end
