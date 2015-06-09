//
//  PieceHexagonView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PieceHexagonView.h"
#import "PieceItemEntity.h"

#define JY_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;

@interface HazyLayerView ()

@property(nonatomic,strong)NSArray* arr_coverlist;

@end

@implementation HazyLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
    self = [super initWithFrame:frame];
    
    if (self)
    {
    }
    
    return self;
}

- (void)setPieceBranchList:(NSArray*)branch_list
{
    NSMutableArray* all_list = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    
    for (int i = 0; i < branch_list.count; i++) {
        NSString* branch = [branch_list objectAtIndex:i];
        
        if ([all_list containsObject:branch]) {
            [all_list removeObject:branch];
        }
    }
    
    self.arr_coverlist = all_list;
    [self setNeedsDisplay];
}

- (void)setPieceNumberingEntity:(PieceNumberingEntity*)entity
{
    NSMutableArray* all_list = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    [all_list removeObject:entity.piece_branch];
    
    self.arr_coverlist = all_list;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat radPerV = M_PI * 2 / 6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont* txtfont = [UIFont boldSystemFontOfSize:26.0];

    CGFloat _newR = _r;
    CGFloat miniR = 4.0;
    CGContextSetLineWidth(context, 2.0);
    
    
    for (int i = 0 ; i < _arr_coverlist.count; i++) {
        int j = [[_arr_coverlist objectAtIndex:i] intValue] - 1;
        
        CGContextSaveGState(context);
        [[UIColor clearColor] setStroke];
        [[[UIColor whiteColor] colorWithAlphaComponent:0.7] setFill];
        CGContextBeginPath(context);//标记
        
        CGFloat x = _centerPoint.x + miniR* sin(radPerV/2 + j*radPerV);
        CGFloat y = _centerPoint.y - miniR * cos(radPerV/2 + j*radPerV);
        CGContextMoveToPoint(context, x, y);
        
        CGContextAddLineToPoint(context, x +_newR*sin(j*radPerV), y - _newR*cos(j*radPerV));
        
        CGContextAddLineToPoint(context, x +_newR*sin((j+1)*radPerV),
                                y - _newR*cos((j+1)*radPerV));
        CGContextDrawPath(context,
                          kCGPathFillStroke);//绘制路径path
        CGContextRestoreGState(context);
        
        CGPoint _minicenterPoint = CGPointMake((x + x +_newR*sin(j*radPerV) + x +_newR*sin((j+1)*radPerV))/3, (y + y - _newR*cos(j*radPerV) + y - _newR*cos((j+1)*radPerV))/3);
        
        NSString* _text  = [NSString stringWithFormat:@"%d",j+1];
        UIGraphicsPushContext(context);
        CGFloat height = [txtfont lineHeight];
        CGSize attributeTextSize = JY_TEXT_SIZE(_text, txtfont);
        CGFloat width = attributeTextSize.width;
        CGRect cubeRect = CGRectMake(_minicenterPoint.x - (width)/2, _minicenterPoint.y - (height)/2, width, height);
        NSString *str = _text;
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attrs[NSFontAttributeName] = txtfont;
        [str drawInRect:cubeRect withAttributes:attrs];
        UIGraphicsPopContext();
    }
    
//    for (int i = 0; i < 6; i++) {
//        CGContextSaveGState(context);
//        [[UIColor clearColor] setStroke];
//        [[[UIColor whiteColor] colorWithAlphaComponent:0.7] setFill];
//        CGContextBeginPath(context);//标记
//        
//        CGFloat x = _centerPoint.x + miniR* sin(radPerV/2 + i*radPerV);
//        CGFloat y = _centerPoint.y - miniR * cos(radPerV/2 + i*radPerV);
//        CGContextMoveToPoint(context, x, y);
//        
//        CGContextAddLineToPoint(context, x +_newR*sin(i*radPerV), y - _newR*cos(i*radPerV));
//        
//        CGContextAddLineToPoint(context, x +_newR*sin((i+1)*radPerV),
//                                y - _newR*cos((i+1)*radPerV));
//        CGContextDrawPath(context,
//                          kCGPathFillStroke);//绘制路径path
//        CGContextRestoreGState(context);
//    
//        CGPoint _minicenterPoint = CGPointMake((x + x +_newR*sin(i*radPerV) + x +_newR*sin((i+1)*radPerV))/3, (y + y - _newR*cos(i*radPerV) + y - _newR*cos((i+1)*radPerV))/3);
//        
//        NSString* _text  = [NSString stringWithFormat:@"%d",i+1];
//        UIGraphicsPushContext(context);
//        CGFloat height = [txtfont lineHeight];
//        CGSize attributeTextSize = JY_TEXT_SIZE(_text, txtfont);
//        CGFloat width = attributeTextSize.width;
//        CGRect cubeRect = CGRectMake(_minicenterPoint.x - (width)/2, _minicenterPoint.y - (height)/2, width, height);
//        NSString *str = _text;
//        
//        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        attrs[NSFontAttributeName] = txtfont;
//        [str drawInRect:cubeRect withAttributes:attrs];
//        UIGraphicsPopContext();
//    }
}

@end


@implementation PieceHexagonView

- (instancetype)initWithFrame:(CGRect)frame
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _hazyLayerView = [[HazyLayerView alloc]initWithFrame:self.bounds];
        [self addSubview:_hazyLayerView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    _centerPoint = CGPointMake(frame.size.width / 2 +frame.origin.x, frame.size.height / 2 +frame.origin.y);
    _r = MIN(frame.size.width / 2, frame.size.height / 2);
    self = [super initWithFrame:frame];
    
    if (self)
    {
    }
    
    return self;
}


@end
