//
//  LoginHandler.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@interface LoginHandler : BaseHandler

+ (void)LoginWithAccount:(NSString *)account password:(NSString *)password  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
