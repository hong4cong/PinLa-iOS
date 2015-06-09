//
//  UIImage+Util.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/13.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
/**
 *  传入UIColor得到纯色UIImage
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return
 */
+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

+ (UIImage *)convertViewToImage;

+ (UIImage *)stretchImageWithImage:(UIImage *)image atPos:(CGPoint)pos;

@end
