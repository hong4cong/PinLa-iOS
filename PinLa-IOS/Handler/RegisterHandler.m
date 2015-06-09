//
//  Register.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "RegisterHandler.h"

@implementation RegisterHandler

+ (void)getAuthcodeWithPhoneNum:(NSString *)phoneNum success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSString *str_url = [self requestUrlWithPath:API_USER_VERIFY];
    NSDictionary *dic = @{@"phone":phoneNum};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *verify_code = [(NSDictionary *)responseObject objectForKey:@"verify_code"];
        success(verify_code);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
    
}

+ (void)verifyRegisterInformationWithAccount:(NSString *)account password:(NSString *)password verify_code:(NSString *)verify_code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_USER_REGISTER];
    NSDictionary *dic = @{@"account":account,
                          @"password":password,
                          @"verify_code":verify_code};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}
@end

