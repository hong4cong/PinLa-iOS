//
//  IndicatorView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/15.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "IndicatorView.h"
#import "UIColor+Util.h"

@implementation IndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CAShapeLayer * layer = [self createIndicatorWithColor:[UIColor colorWithHexString:@"#2BFEBB"] andPosition:CGPointMake(0, 0)];
        [self.layer addSublayer:layer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer * layer = [self createIndicatorWithColor:[UIColor colorWithHexString:@"#2BFEBB"] andPosition:CGPointMake(0, 0)];
        [self.layer addSublayer:layer];
    }
    return self;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 6)];
    [path closePath];
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(-CGRectGetMinX(self.frame), -CGRectGetMinY(self.frame));
    [layer setPath:CGPathCreateCopyByTransformingPath(path.CGPath, &t)];
    
//    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
//
//    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapSquare, kCGLineJoinMiter, layer.miterLimit);
//    layer.bounds = CGPathGetBoundingBox(bound);
//    
    layer.position = point;
    
    return layer;
}


@end
