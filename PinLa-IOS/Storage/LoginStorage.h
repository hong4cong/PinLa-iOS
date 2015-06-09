//
//  LoginStorage.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"
#import "UserDefaultsUtils.h"

@interface LoginStorage : NSObject
+ (void)saveLoginStatus:(BOOL)loginStatus;

+ (BOOL)isLogin;
@end
