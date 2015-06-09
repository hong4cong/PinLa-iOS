//
//  UserStorage.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultsUtils.h"
#import "CoordinateEntity.h"
#import "HotspotPolyEntity.h"

@interface UserStorage : NSObject
//登录相关
+ (void)saveLoginStatus:(BOOL)loginStatus;

+ (BOOL)isLogin;

+ (void)saveSwithStatus:(BOOL)switchStatus;

+ (BOOL)isSwitch;

+ (NSString*)token;

+ (void)saveToken:(NSString*)token;

//用户信息相关
+ (void)saveUserId:(NSString *)userId;

+ (NSString *)userId;

+ (void)saveUserSign:(NSString *)userSign;

+ (NSString *)userSign;

+ (void)saveUserNickName:(NSString *)userNickName;

+ (NSString *)userNickName;

+ (void)saveUserIcon:(NSString *)userIcon;

+ (NSString *)userIcon;

+ (void)savePhysical:(NSInteger)physical;

+ (NSInteger)physical;

+ (void)savePhysicalTime:(NSInteger)physicalTime;

+ (NSInteger)physicalTime;

+ (void)saveRadiiTime:(NSInteger)radiiTime;

+ (NSInteger)radiiTime;

+ (void)saveRadii:(NSInteger)radii;

+ (NSInteger)radii;

+ (void)saveCoordinateEntity:(CoordinateEntity *)coordinateEntity;

+ (CoordinateEntity *)userCoordinate;

+ (void)saveBgImage:(UIImage *)bgImage;
+ (UIImage *)bgImage;

+ (void)saveHotspotPolyEntity:(HotspotPolyEntity*)hotspotPolyEntity;

+ (HotspotPolyEntity *)hotspotPolyEntity;

+ (void)saveCitycode:(NSString*)citycode;

+ (NSString*)citycode;

+ (BOOL)isFirstLogin;

+ (void)saveFirstLoginStatus:(BOOL)firstloginStatus;

+ (void)saveIsShowBackageRedPoint:(BOOL)isShowBackageRedPoint;

+ (BOOL)isShowBackageRedPoint;

@end
