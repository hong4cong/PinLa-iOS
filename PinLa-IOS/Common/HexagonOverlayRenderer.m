//
//  HexagonOverlayRenderer.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/28.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HexagonOverlayRenderer.h"
#import "HexagonOverlay.h"

@implementation HexagonOverlayRenderer

- (id)initWithOverlay:(id <MAOverlay>)overlay
{
    self = [super initWithOverlay:overlay];
    if(self){
        _lineWidth = 2.0;
        _fillColor = [[UIColor colorWithHexString:COLOR_LINE_BLUE] colorWithAlphaComponent:0.3];
        _strokeColor = [UIColor colorWithHexString:COLOR_LINE_BLUE];
    }
    return self;
}

- (void)drawMapRect:(MAMapRect)mapRect zoomScale:(MAZoomScale)zoomScale inContext:(CGContextRef)context
{
    HexagonOverlay *overlay = (HexagonOverlay *)self.overlay;
    
    if (overlay == nil)
    {
        NSLog(@"overlay is nil");
        return;
    }
    
    MAMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect          = [self rectForMapRect:theMapRect];
//    double width            = theRect.size.width;
    
    //绘制path
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth / zoomScale);
    
    CGPoint _centerPoint = CGPointMake(theRect.size.width / 2 + theRect.origin.x, theRect.size.height / 2 + theRect.origin.y);
    CGFloat _r = MIN(theRect.size.width / 2, theRect.size.height / 2);
    CGFloat radPerV = M_PI * 2 / 6;
    for (NSInteger i = 0; i <= 6; i++)
    {
        if (i == 0) {
            CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r);
        }else{
            CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
        }
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
