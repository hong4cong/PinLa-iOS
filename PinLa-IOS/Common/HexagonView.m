//
//  HeaderView.m
//  IQIrregularView Demo
//
//  Created by 洪聪 on 15/4/9.
//  Copyright (c) 2015年 Canopus. All rights reserved.
//

#import "HexagonView.h"
#import <QuartzCore/QuartzCore.h>

@interface HexagonView ()
{
    CGPoint _centerPoint;
    int _r;
}

@end

@implementation HexagonView

- (instancetype)initWithFrame:(CGRect)frame
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
     CGPathRef path = [self pathFromFrame:self.frame];
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUserInteractionEnabled:YES];
       
        CGAffineTransform t = CGAffineTransformMakeTranslation(-CGRectGetMinX(self.frame), -CGRectGetMinY(self.frame));
        [[self layer] setFillColor:[UIColor clearColor].CGColor];
        [self layer].strokeColor = [UIColor colorWithHexString:COLOR_MAIN].CGColor;
        [[self layer] setPath:CGPathCreateCopyByTransformingPath(path, &t)];
        [[self layer] setFillMode:kCALineJoinRound];
        [self layer].backgroundColor = [UIColor clearColor].CGColor;
        [[self layer] setMasksToBounds:YES];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
    CGPathRef path = [self pathFromFrame:self.frame];

    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUserInteractionEnabled:YES];
        
//        UIImage* imageV = [self deleteBackgroundOfImage:image];
        self.image = image;
        CGAffineTransform t = CGAffineTransformMakeTranslation(-CGRectGetMinX(self.frame), -CGRectGetMinY(self.frame));
        [[self layer] setFillColor:[UIColor clearColor].CGColor];
        [self layer].strokeColor = [UIColor colorWithHexString:COLOR_MAIN].CGColor;
        [[self layer] setPath:CGPathCreateCopyByTransformingPath(path, &t)];
        [[self layer] setFillMode:kCALineJoinRound];
        [self layer].backgroundColor = [UIColor clearColor].CGColor;
        [[self layer] setMasksToBounds:YES];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    
    UIImage* imageV = [self deleteBackgroundOfImage:image];
    [super setImage:imageV];
    
}

- (CGPathRef)pathFromFrame:(CGRect)frame
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radPerV = M_PI * 2 / 6;
    for (NSInteger i = 0; i <= 6; i++)
    {
        if (i == 0) {
            [path moveToPoint:CGPointMake(_centerPoint.x, _centerPoint.y - _r)];
        }else{
            [path addLineToPoint:CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV))];
        }
    }
    [path closePath];
    return CGPathCreateCopy(path.CGPath);
}

- (UIImage *)deleteBackgroundOfImage:(UIImage *)image
{
    
    CGRect rect = CGRectZero;
    rect.size = image.size;
    
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 );
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat radPerV = M_PI * 2 / 6;
        for (NSInteger i = 0; i <= 6; i++)
        {
            if (i == 0) {
                CGPoint p1 = [self convertCGPoint:CGPointMake(centerPoint.x, centerPoint.y - _r) fromRect1:self.frame.size toRect2:image.size];
                [path moveToPoint:p1];
            }else{
                CGPoint p = [self convertCGPoint:CGPointMake(centerPoint.x - _r * sin(i * radPerV), centerPoint.y - _r * cos(i * radPerV)) fromRect1:self.frame.size toRect2:image.size];
                [path addLineToPoint:p];
            }
        }
        [path closePath];
        [path fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskedImage;
}

- (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}

#pragma mark - Overrided methods.

+(Class)layerClass
{
    return [CAShapeLayer class];
}

-(CAShapeLayer*)layer
{
    return (CAShapeLayer*)[super layer];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [[self layer] setFillColor:backgroundColor.CGColor];
    
    [[self layer] setStrokeColor:[UIColor colorWithHexString:COLOR_MAIN].CGColor];
    
}

-(UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:[[self layer] fillColor]];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGPathContainsPoint([[self layer] path], NULL, point, ([[self layer] fillRule] == kCAFillRuleEvenOdd)))
    {
        return [super hitTest:point withEvent:event];
    }
    else
    {
        return nil;
    }
    
}


@end
