//
//  LoginHandler.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LoginHandler.h"
#import "UserEntity.h"
#import "LoginStorage.h"
#import "UserStorage.h"
@implementation LoginHandler

+ (void)LoginWithAccount:(NSString *)account password:(NSString *)password prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_USER_LOGIN];
    
    NSString* str = @"http://interface.pinla.today/v1/user/password_modify.php?user_id=1&password=12356&device_mark=1&channel=2&app_version=1.0";
    
    NSDictionary *dic = @{@"account":account,
                          @"password":password,
                         };
    [[RTHttpClient defaultClient]requestWithPath:str method:RTHttpRequestGet parameters:nil prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        [LoginStorage saveLoginStatus:YES];
        UserEntity *user = [UserEntity parseUserWithJson:responseObject];
        [UserStorage saveUserId:user.user_id];
        [UserStorage saveUserSign:user.user_sign];
        [UserStorage saveUserNickName:user.nick_name];
        [UserStorage saveUserIcon:user.user_icon];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
    
}
@end
