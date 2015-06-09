//
//  StoreHandler.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@interface StoreHandler : BaseHandler

/**
 *  检测版本更新
 */
+ (void)getGoodsListWithPrepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
