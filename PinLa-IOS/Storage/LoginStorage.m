//
//  LoginStorage.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LoginStorage.h"

static NSString * const ISLOGIN = @"isLogin";

@implementation LoginStorage

+ (void)saveLoginStatus:(BOOL)loginStatus{
    [UserDefaultsUtils saveBoolValue:loginStatus withKey:ISLOGIN];
}

+ (BOOL)isLogin{
    return  [UserDefaultsUtils boolValueWithKey:ISLOGIN];
}

@end
