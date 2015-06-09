//
//  HotspotHexOverlayRenderer.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/30.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "UsersHexOverlayRenderer.h"
#import "HexagonOverlay.h"

#define JY_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;

@implementation UsersHexOverlayRenderer

- (void)drawMapRect:(MAMapRect)mapRect zoomScale:(MAZoomScale)zoomScale inContext:(CGContextRef)context
{
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
    
    HexagonOverlay *overlay = (HexagonOverlay *)self.overlay;
    
    if (overlay == nil)
    {
        NSLog(@"overlay is nil");
        return;
    }
    
    MAMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect          = [self rectForMapRect:theMapRect];
    self.scaleFont = [UIFont systemFontOfSize:13.0/zoomScale];
    
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor);
    CGContextSetLineWidth(context, self.lineWidth / zoomScale);
    CGPoint _centerPoint = CGPointMake(theRect.size.width / 2 + theRect.origin.x, theRect.size.height / 2 + theRect.origin.y);
    CGFloat _r = MIN(theRect.size.width / 2, theRect.size.height / 2);
    CGFloat radPerV = M_PI * 2 / 6;
    
    
    
    CGFloat miniR = _r/3;
    _minicenterPoint = CGPointMake(_centerPoint.x, _centerPoint.y + _r/3*2);
    _firstPoint = CGPointMake(_centerPoint.x, _minicenterPoint.y - miniR);
    
    
    
    for (NSInteger i = 0; i <= 6; i++)
    {
        if (i == 0) {
            CGContextMoveToPoint(context, _minicenterPoint.x, _minicenterPoint.y - miniR);
        }else{
            CGContextAddLineToPoint(context, _minicenterPoint.x - miniR * sin(i * radPerV), _minicenterPoint.y - miniR * cos(i * radPerV));
        }
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIGraphicsPopContext();
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor);
    
    UIGraphicsPushContext(context);
    CGFloat height = [self.scaleFont lineHeight];
    CGSize attributeTextSize = JY_TEXT_SIZE(_text, self.scaleFont);
    CGFloat width = attributeTextSize.width;
    CGRect cubeRect = CGRectMake(_minicenterPoint.x - (width)/2, _minicenterPoint.y - (height)/2, width, height);
    NSString *str = _text;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = self.scaleFont;
    [str drawInRect:cubeRect withAttributes:attrs];
    UIGraphicsPopContext();

}

@end
