//
//  AppUtils.m
//  zlydoc+iphone
//
//  Created by Ryan on 14+5+23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "AppUtils.h"
//#import <SVProgressHUD/SVProgressHUD.h>
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"
#import <AdSupport/AdSupport.h>
#import "REFrostedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PieceEntity.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation AppUtils

/********************* System Utils **********************/
// 隐藏手机号码6-10位显示*
+ (NSString *)hidePhoneNumber:(NSString *)str
{
    if (!str || str.length != 11) {
        return @"未知用户 ";
    }
    NSMutableString * phoneStr = [NSMutableString stringWithString:str];
    [phoneStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return phoneStr;
}

+ (NSString *)formatPhoneNumber:(NSString *)str
{
    NSString * phone;
    if(str.length == 10){
        phone = [NSString stringWithFormat:@"%@-%@-%@",[str substringWithRange:NSMakeRange(0, 3)],[str substringWithRange:NSMakeRange(3, 3)],[str substringWithRange:NSMakeRange(6, str.length - 6)]];
    }else if (str.length == 11){
        phone = [NSString stringWithFormat:@"%@-%@-%@",[str substringWithRange:NSMakeRange(0, 3)],[str substringWithRange:NSMakeRange(3, 4)],[str substringWithRange:NSMakeRange(7, str.length - 7)]];
    }
    
    return phone;
}

+ (NSString *)formatPriceNumber:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
    NSRange range = [priceStr rangeOfString:@"."];
    NSString *integer = nil;
    if (range.location != NSNotFound) {
        integer = [priceStr substringToIndex:range.location];
    } else {
        integer = [NSString stringWithString:priceStr];
    }
    return priceStr;
}

+ (NSString* )convertPrice:(double)price
{
    if(!(price-(int)price)){
        return [NSString stringWithFormat:@"%.0f", price];
    }
    
    return [NSString stringWithFormat:@"%.2f", price];
}

+ (UIView *)tableViewsFooterViewWithMessage:(NSString *)message
{
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor clearColor];
    UILabel *lb_footTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 16)];
    lb_footTitle.font = [UIFont systemFontOfSize:18];
    lb_footTitle.textColor = [UIColor whiteColor];
    lb_footTitle.textAlignment = NSTextAlignmentCenter;
    lb_footTitle.text = message;
    [coverView addSubview:lb_footTitle];
    [coverView setFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(lb_footTitle.frame) + 16)];
    return coverView;
}

+ (UIBarButtonItem *)navibarBackBtnWithNoTitle
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

//+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber{
//    if (phoneNumber.length == 11) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

+ (NSString *)getMoneyStrFromValue:(double)moneyValue {
    NSString *valueStr = [NSString stringWithFormat:@"%.2f", moneyValue];   //格式化为保留2位小数
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?=(?!\\b)(?:\\d{3})+(?!\\d))" options:NSRegularExpressionCaseInsensitive error:nil];  //使用正则查找需要插入,的位置
    
    return [regex stringByReplacingMatchesInString:valueStr options:0 range:NSMakeRange(0, [valueStr length]) withTemplate:@","];//插入,
}

//Hex
+ (NSString *)md5FromString:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)priceByFitting:(double)price {
    NSString *str_price;
    if (price >= 0) {
        str_price = [NSString stringWithFormat:@"+ %@", [AppUtils getMoneyStrFromValue:price]];
    } else {
        str_price = [NSString stringWithFormat:@"- %@", [AppUtils getMoneyStrFromValue:fabs(price)]];
    }
    
    return str_price;
}

+ (UIView *)addLineWithFrame:(CGRect)frame{
    UIView *v_line = [[UIView alloc]initWithFrame:frame];
    [v_line setBackgroundColor:[UIColor colorWithHexString:COLOR_LINE_GRAY]];
    return v_line;
}

+ (UIView *)addLineWithFrame:(CGRect)frame andColor:(UIColor *)color{
    UIView *v_line = [[UIView alloc]initWithFrame:frame];
    [v_line setBackgroundColor:color];
    return v_line;
}

+ (void)addLineOnView:(UIView *)view WithFrame:(CGRect)frame{
    UIView *v_line = [[UIView alloc]initWithFrame:frame];
    [v_line setBackgroundColor:[UIColor colorWithHexString:COLOR_LINE_GRAY]];
    [view addSubview:v_line];
}

+ (MainViewController *)getMainViewController {
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([controller isKindOfClass:[REFrostedViewController class]]) {
        UIViewController *contentViewController = ((REFrostedViewController *)controller).contentViewController;
        if ([contentViewController isKindOfClass:[RENavigationController class]]) {
            NSArray *stack = [(RENavigationController *)contentViewController viewControllers];
            if ([stack count] && [[stack firstObject] isKindOfClass:[MainViewController class]]) {
                return (MainViewController *)[stack firstObject];
            }
        }
    }
    
    return nil;
}

+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 ){
        return YES;
    }else{
        return NO;
    }
}

+ (void)contentImageView:(UIImageView *)imageView withURLString:(NSString *)urlString andPlaceHolder:(UIImage*)image{
    if (urlString) {
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imageView sd_setImageWithURL:url placeholderImage:image];
    }
}

+ (BOOL)isCanSynthesis:(NSArray*)arr_entity
{
    NSMutableDictionary * group = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < arr_entity.count; i++) {
        PieceEntity* piece = [arr_entity objectAtIndex:i];
        if (![group objectForKey:piece.piece_branch] && !piece.piece_lock) {
            [group setObject:[NSMutableArray arrayWithObject:piece] forKey:piece.piece_branch];
        }
    }
    
    if (group.count == 6) {
        return true;
    }else{
        return false;
    }
}

+ (void)errorAlert:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle tag:(NSInteger)tag {
    if (!title && !message && !cancelButtonTitle && !otherButtonTitle) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    alert.tag = tag;
    
    [alert show];
}

+ (void)errorAlert:(NSString *)title message:(NSString *)message {
    [AppUtils errorAlert:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil tag:0];
}

+ (void)errorAlert:(NSString *)title {
    [AppUtils errorAlert:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil tag:0];
}

+ (void)errorAlertWithMessage:(NSString *)message {
    [AppUtils errorAlert:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil tag:0];
}

+ (NSString *)timeMinutesFormatted:(NSInteger)totalSeconds
{
    if (totalSeconds == 0) {
        return @"";
    }
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)timeHourFormatted:(NSInteger)totalSeconds
{
    if (totalSeconds == 0) {
        return @"";
    }
    int minutes = (totalSeconds / 60) % 60;
    int hour = (totalSeconds / (60*60)) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", hour, minutes];
}

@end