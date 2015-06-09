//
//  AppUtils.h
//  zlydoc+iphone
//
//  Created by Ryan on 14+5+23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"


#define ISAVAILABLE @"isAvailable"
#define JSON_AFTER_REGULATE @"json"

@interface AppUtils : NSObject

/********************** System Utils ***********************/

+ (NSString *)hidePhoneNumber:(NSString *)str;

+ (NSString *)formatPhoneNumber:(NSString *)str;

+ (NSString *)formatPriceNumber:(CGFloat)price;

+ (UIView *)tableViewsFooterViewWithMessage:(NSString *)message;

+ (UIBarButtonItem *)navibarBackBtnWithNoTitle;

+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

//传入金额，返回一个整数部分每3位用,分割的金钱格式字符串
+ (NSString *)getMoneyStrFromValue:(double)moneyValue;

//获取MD5加密后字符串
+ (NSString *)md5FromString:(NSString *)str;

+ (NSString *)priceByFitting:(double)price;

+ (NSString* )convertPrice:(double)price;

+ (UIView *)addLineWithFrame:(CGRect)frame;

+ (UIView *)addLineWithFrame:(CGRect)frame andColor:(UIColor *)color;

+ (void)addLineOnView:(UIView *)view WithFrame:(CGRect)frame;

+ (MainViewController *)getMainViewController;

+ (void)contentImageView:(UIImageView *)imageView withURLString:(NSString *)url andPlaceHolder:(UIImage*)image;

+ (BOOL)isCanSynthesis:(NSArray*)arr_entity;

+ (void)errorAlert:(NSString *)title message:(NSString *)message;

+ (void)errorAlert:(NSString *)title;

+ (void)errorAlertWithMessage:(NSString *)message;

+ (NSString *)timeMinutesFormatted:(NSInteger)totalSeconds;

+ (NSString *)timeHourFormatted:(NSInteger)totalSeconds;

@end