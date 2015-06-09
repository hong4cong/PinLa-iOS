//
//  HexagonOverlayRenderer.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/28.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface HexagonOverlayRenderer : MAOverlayRenderer

/*!
 @brief 精度圈边线宽度,默认是2
 */
@property (nonatomic, assign) CGFloat lineWidth;

/*!
 @brief 精度圈填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

/*!
 @brief 精度圈边线颜色
 */
@property (nonatomic, strong) UIColor *strokeColor;

@end
