//
//  UpdateHandler.h
//  ZLYDoc
//  应用更新处理者
//  Created by Ryan on 14-6-6.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"

@interface UpdateHandler : BaseHandler

/**
 *  检测版本更新
 */
+ (void)checkAppVersionWithPrepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed;

/** 
 * 闪屏图
 */
+ (void)getLanunchPicWithType:(NSInteger)type Prepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
