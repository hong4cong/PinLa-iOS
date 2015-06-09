//
//  UIView+Shadow.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/2/4.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)setNormalShadow
{
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = .3;
//    self.layer.shadowRadius = 2;
//    CGRect shadowFrame = self.layer.bounds;
//    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//    self.layer.shadowPath = shadowPath;
}

@end
