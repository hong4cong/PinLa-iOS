//
//  AccountHandler.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AccountHandler.h"
#import "UserStorage.h"
#import "UserEntity.h"
#import "CoordinateEntity.h"
#import "BackpackEntity.h"
#import "DynamicEntity.h"
#import "CardEntity.h"
#import "PhysicalEntity.h"
#import "MessageEntity.h"

@implementation AccountHandler

+ (void)LoginWithAccount:(NSString *)account password:(NSString *)password prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_USER_LOGIN];
    
//    NSString* md5 = [AppUtils md5FromString:password];
    
    NSDictionary *dic = @{@"account":account,
                          @"password":password,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if (result == 1) {
            [UserStorage saveLoginStatus:YES];
            UserEntity *user = [UserEntity parseUserWithJson:responseObject];
            [UserStorage saveUserId:user.user_id];
            [UserStorage saveUserSign:user.user_sign];
            [UserStorage saveUserNickName:user.nick_name];
            [UserStorage saveUserIcon:user.user_icon];
            [UserStorage saveToken:user.token];
            success(user);
        }else{
            failed(result,msg);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)logoutWithCoordinate:(CoordinateEntity*)coordinate prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_LOGOUT];
    
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"coordinate":coordinate.keyValues
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)getAuthcodeWithPhoneNum:(NSString *)phoneNum prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSString *str_url = [self requestUrlWithPath:API_USER_VERIFY];
    
    NSDictionary *dic = @{@"phone":phoneNum};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if (result == 1) {
            success(nil);
        }else{
            failed(result,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
    
}

+ (void)verifyRegisterInformationWithAccount:(NSString *)account password:(NSString *)password verify_code:(NSString *)verify_code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_USER_REGISTER];
    if(!verify_code){
        verify_code = @"";
    }
    NSDictionary *dic = @{@"account":account,
                          @"password":password,
                          @"verify_code":verify_code};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
        NSString* user_id = [responseObject objectForKey:@"user_id"];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if (result == 1) {
            success(user_id);
        }else{
            failed(result,msg);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)modifyUserInfoWithNickname:(NSString*)name avatar:(void (^)(id <AFMultipartFormData> formData))imageFileblock userSign:(NSString*)userSign prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    
    NSString *str_url = [self requestUrlWithPath:API_USER_MODIFY_USERINFO];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"nick_name":name,
                          @"user_sign":userSign,
                          @"user_icon":@""};
    
    [[RTHttpClient defaultClient] requestWithPath:str_url parameters:dic constructingBodyWithBlock:imageFileblock prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)modifyUserInfoWithNickname:(NSString*)name avatarData:(NSString*)avatarData userSign:(NSString*)userSign prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_MODIFY_USERINFO];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"nick_name":name,
                          @"user_sign":userSign,
                          @"user_icon":avatarData};
    
    [[RTHttpClient defaultClient] requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSString* user_icon = [responseObject objectForKey:@"user_icon"];
            success(user_icon);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)verifyWithPhoneNum:(NSString *)phoneNum securityCode:(NSString*)code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_PASSWORD_VERIFY_CONFIRM];
    NSDictionary *dic = @{@"phone":phoneNum,
                          @"verify_code":code
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str_userId = [(NSDictionary *)responseObject objectForKey:@"user_id"];
        success(str_userId);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//忘记密码修改密码
+ (void)modifyUserId:(NSString *)userId password:(NSString*)password prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_PASSWORD_MODIFY];
    NSDictionary *dic = @{@"user_id":userId,
                          @"password":password
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//同步背包
+ (void)getBackpackWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_GET_BACKPACK];
    NSDictionary *dic = @{@"user_id":userId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            BackpackEntity* entity = [BackpackEntity parseBackpackWithJson:responseObject];
            success(entity);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//同步卡包
+ (void)getCardpackWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_GET_CARDPACK];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray* card_list = [responseObject objectForKey:@"card_list"];
            NSArray* cardEntityList = [CardEntity parseObjectArrayWithKeyValuesArray:card_list];
            success(cardEntityList);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//获取用户动态
+ (void)getDynamicWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_GET_DYNAMIC];
    NSDictionary *dic = @{
                          @"user_id":[UserStorage userId]
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray* dynamicList = [responseObject objectForKey:@"dynamic_list"];
            NSArray* arr = [DynamicEntity parseDynamicListWithKeyValuesArray:dynamicList];
            success(arr);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//关注用户
+ (void)followerUserId:(NSString*)userId otherUserIdList:(NSArray*) id_arr prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_FOLLOWER_USER];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"user_id_list":id_arr
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//取消关注用户
+ (void)unfollowerUserId:(NSString*)userId otherUserIdList:(NSArray*) id_arr prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_UNFOLLOWER_USER];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"user_id_list":id_arr
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//获取关注用户
+ (void)getFollowerUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_USER_GET_FOLLOWERS];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray* user_list = [responseObject objectForKey:@"user_list"];
        NSArray* userList = [UserEntity parseUserArrayWithKeyValuesArray:user_list];
        success(userList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//反馈
+ (void)feedbackWithMessage:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_SYSTEM_FEEDBACK];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"msg":msg,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        success(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//登录验证
+ (void)loginVerifyWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    if (![UserStorage userId]) {
        return;
    }
    NSString *str_url = [self requestUrlWithPath:API_LOGIN_VERiIFY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            PhysicalEntity * entity = [PhysicalEntity parseObjectWithKeyValues:responseObject];
            success(entity);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)getUserInfoWithUserId:(NSString*)userId otherUserId:(NSString *)otherUserId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_GET_USERINFO];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"other_user_id":otherUserId
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray* dynamicList = [responseObject objectForKey:@"dynamic_list"];
            NSArray* dynamicArr = [DynamicEntity parseDynamicListWithKeyValuesArray:dynamicList];
            
            NSDictionary* user_entity = [responseObject objectForKey:@"user_list"];
            UserEntity *userEntity = [UserEntity parseUserWithJson:user_entity];
            userEntity.dynamic_list = dynamicArr;
            success(userEntity);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)UpdateAddressWithUserId:(NSString*)userId phone_list:(NSArray *)phone_list prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_POST_ASSOCIATE];
    NSDictionary *dic = @{@"user_id":userId,
                          @"phone_list":phone_list};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr_list = [responseObject objectForKey:@"relation_list"];
        NSArray *arr_addressList = [UserEntity parseUserArrayWithKeyValuesArray:arr_list];
        success(arr_addressList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)getMessageWithUserId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_GET_MESSAGE];
    NSDictionary *dic = @{@"user_id":userId};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray *arr_list = [responseObject objectForKey:@"massage"];
            NSArray *arr_messageList = [MessageEntity parseMessageArrayWithKeyValuesArray:arr_list];
            success(arr_messageList);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}
+ (void)deleteMessageWithUserId:(NSString *)userId messageId:(NSString *)messageid prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_DELETE_MESSAGE];
    NSDictionary *dic = @{@"user_id":userId,
                          @"message_id":messageid};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity* entity = [BaseEntity parseObjectWithKeyValues:responseObject];
        if (entity.result == 1) {
            success(nil);
        }else{
            failed(404,@"");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];}
@end
