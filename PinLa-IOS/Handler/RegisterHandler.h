//
//  Register.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@interface RegisterHandler : BaseHandler

+ (void)getAuthcodeWithPhoneNum:(NSString *)phoneNum success:(SuccessBlock)success failed:(FailedBlock)failed;

+ (void)verifyRegisterInformationWithAccount:(NSString *)account password:(NSString *)password verify_code:(NSString *)verify_code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
