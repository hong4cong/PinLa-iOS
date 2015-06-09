//
//  UserStorage.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "UserStorage.h"

static NSString * const USERID = @"userId";

static NSString * const USERSIGN = @"userSign";

static NSString * const USERNICKNAME = @"userNickName";

static NSString * const USERICON = @"userIcon";

static NSString * const ISLOGIN = @"isLogin";

static NSString * const ISFIRSTLOGIN = @"isFirstLogin";

static NSString * const SWITCHSTATUS = @"switchStatus";

static NSString * const USER_TOKEN = @"token";

static NSString * const PHYSICAL = @"physical";

static NSString * const PHYSICAL_TIME = @"physical_time";

static NSString * const RADII_TIME = @"RadiiTime";

static NSString * const RADII = @"radii";

static NSString * const COORDINATE = @"coordinate";

static NSString * const BGIMAGE = @"bgimage";

static NSString * const HOTSPOTPOLY = @"hotspotPolyEntity";

static NSString * const CITYCODE = @"citycode";

static NSString * const SHOWBACKAGE_REDPOINT = @"isShowBackageRedPoint";

@implementation UserStorage

+ (void)saveFirstLoginStatus:(BOOL)firstloginStatus{
    [UserDefaultsUtils saveBoolValue:firstloginStatus withKey:ISFIRSTLOGIN];
}

+ (BOOL)isFirstLogin{
    return  [UserDefaultsUtils boolValueWithKey:ISFIRSTLOGIN];
}

+ (void)saveLoginStatus:(BOOL)loginStatus{
    [UserDefaultsUtils saveBoolValue:loginStatus withKey:ISLOGIN];
}

+ (BOOL)isLogin{
    return  [UserDefaultsUtils boolValueWithKey:ISLOGIN];
}

+ (void)saveSwithStatus:(BOOL)switchStatus{
    [UserDefaultsUtils saveBoolValue:switchStatus withKey:SWITCHSTATUS];
}

+ (BOOL)isSwitch{
    return [UserDefaultsUtils boolValueWithKey:SWITCHSTATUS];
}

+ (void)saveUserId:(NSString *)userId{
    [UserDefaultsUtils saveValue:userId forKey:USERID];
}

+ (NSString *)userId{
    return [UserDefaultsUtils valueWithKey:USERID];
}

+ (NSString*)token{
    return [UserDefaultsUtils valueWithKey:USER_TOKEN];
}

+ (void)saveToken:(NSString*)token{
    [UserDefaultsUtils saveValue:token forKey:USER_TOKEN];
}

+ (void)saveUserSign:(NSString *)userSign{
    [UserDefaultsUtils saveValue:userSign forKey:USERSIGN];
}

+ (NSString *)userSign{
    return [UserDefaultsUtils valueWithKey:USERSIGN];
}

+ (void)saveUserNickName:(NSString *)userNickName{
     [UserDefaultsUtils saveValue:userNickName forKey:USERNICKNAME];
}

+ (NSString *)userNickName{
    return [UserDefaultsUtils valueWithKey:USERNICKNAME];
}

+ (void)saveUserIcon:(NSString *)userIcon{
    [UserDefaultsUtils saveValue:userIcon forKey:USERICON];
}

+ (NSString *)userIcon{
    return [UserDefaultsUtils valueWithKey:USERICON];
}

+ (void)savePhysical:(NSInteger)physical{
    [UserDefaultsUtils saveInteger:physical forKey:PHYSICAL];
}

+ (NSInteger)physical{
    return [UserDefaultsUtils integerWithKey:PHYSICAL];
}

+ (void)savePhysicalTime:(NSInteger)physicalTime{
    [UserDefaultsUtils saveInteger:physicalTime forKey:PHYSICAL_TIME];
}

+ (NSInteger)physicalTime{
    return [UserDefaultsUtils integerWithKey:PHYSICAL_TIME];
}

+ (void)saveRadiiTime:(NSInteger)radiiTime
{
    [UserDefaultsUtils saveInteger:radiiTime forKey:RADII_TIME];
}

+ (NSInteger)radiiTime{
    return [UserDefaultsUtils integerWithKey:RADII_TIME];
}

+ (void)saveRadii:(NSInteger)radii{
    [UserDefaultsUtils saveInteger:radii forKey:RADII];
}

+ (NSInteger)radii{
    return [UserDefaultsUtils integerWithKey:RADII];
}

+ (void)saveCoordinateEntity:(CoordinateEntity *)coordinateEntity{
    [UserDefaultsUtils saveObject:coordinateEntity forKey:COORDINATE];
}

+ (CoordinateEntity *)userCoordinate{
    return [UserDefaultsUtils objectWithKey:COORDINATE];
}

+ (void)saveBgImage:(UIImage *)bgImage{
    [UserDefaultsUtils saveObject:bgImage forKey:BGIMAGE];
}

+ (UIImage *)bgImage{
    return [UserDefaultsUtils objectWithKey:BGIMAGE];
}

+ (void)saveHotspotPolyEntity:(HotspotPolyEntity*)hotspotPolyEntity{
    [UserDefaultsUtils saveObject:hotspotPolyEntity forKey:HOTSPOTPOLY];
}

+ (HotspotPolyEntity *)hotspotPolyEntity{
    return [UserDefaultsUtils objectWithKey:HOTSPOTPOLY];
}

+ (void)saveCitycode:(NSString*)citycode{
    
    if (citycode && ![citycode isEqual:@""]) {
        [UserDefaultsUtils saveValue:citycode forKey:CITYCODE];
    }
}

+ (NSString*)citycode{
    return [UserDefaultsUtils valueWithKey:CITYCODE];
}

+ (void)saveIsShowBackageRedPoint:(BOOL)isShowBackageRedPoint{
    [UserDefaultsUtils saveBoolValue:isShowBackageRedPoint withKey:SHOWBACKAGE_REDPOINT];
}

+ (BOOL)isShowBackageRedPoint{
    return  [UserDefaultsUtils boolValueWithKey:SHOWBACKAGE_REDPOINT];
}

@end
