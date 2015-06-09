//
//  UIButton+Style.m
//  zlycare-iphone
//
//  Created by 洪聪 on 14/12/8.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "UIButton+Style.h"

@implementation UIButton (Style)

+ (UIButton*)normalStyleWithFrame:(CGRect)frame
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    UIImage* normalBg = [UIImage imageWithColor:[UIColor colorWithHexString:COLOR_BUTTON_MAIN] andSize:CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame))];
//    UIImage* highlightedBg = [UIImage imageWithColor:[UIColor colorWithHexString:@"#1483af"] andSize:CGSizeMake(140, 35)];
    
    [btn.layer setCornerRadius:2.0];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
    [btn setBackgroundImage:normalBg forState:UIControlStateNormal];
//    [btn setBackgroundImage:highlightedBg forState:UIControlStateHighlighted];
    
    return btn;
}

@end
