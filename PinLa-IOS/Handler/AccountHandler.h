//
//  AccountHandler.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@class CoordinateEntity;

@interface AccountHandler : BaseHandler

//登录
+ (void)LoginWithAccount:(NSString *)account password:(NSString *)password  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//登出
+ (void)logoutWithCoordinate:(CoordinateEntity*)coordinate prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//忘记密码获取手机验证码
+ (void)getAuthcodeWithPhoneNum:(NSString *)phoneNum prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//注册
+ (void)verifyRegisterInformationWithAccount:(NSString *)account password:(NSString *)password verify_code:(NSString *)verify_code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//修改用户信息
+ (void)modifyUserInfoWithNickname:(NSString*)name avatar:(void (^)(id <AFMultipartFormData> formData))imageFileblock userSign:(NSString*)userSign prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//修改用户信息
+ (void)modifyUserInfoWithNickname:(NSString*)name avatarData:(NSString*)avatarData userSign:(NSString*)userSign prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//忘记密码提交验证
+ (void)verifyWithPhoneNum:(NSString *)phoneNum securityCode:(NSString*)code prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//忘记密码修改密码
+ (void)modifyUserId:(NSString *)userId password:(NSString*)password prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//同步背包
+ (void)getBackpackWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//同步卡包
+ (void)getCardpackWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取用户动态
+ (void)getDynamicWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//关注用户
+ (void)followerUserId:(NSString*)userId otherUserIdList:(NSArray*)id_arr prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//取消关注用户
+ (void)unfollowerUserId:(NSString*)userId otherUserIdList:(NSArray*) id_arr prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取关注用户
+ (void)getFollowerUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//反馈
+ (void)feedbackWithMessage:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//登录验证
+ (void)loginVerifyWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据uuid 获取用户信息
+ (void)getUserInfoWithUserId:(NSString*)userId otherUserId:(NSString *)otherUserId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//上传通讯录手机号
+ (void)UpdateAddressWithUserId:(NSString*)userId phone_list:(NSArray *)phone_list prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//获取消息
+ (void)getMessageWithUserId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
//删除消息
+ (void)deleteMessageWithUserId:(NSString *)userId messageId:(NSString *)messageid prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
