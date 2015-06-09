//
//  LockedView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ImageLableView.h"
#import "NSString+Size.h"

@implementation ImageLableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[[UIColor colorWithHexString:COLOR_TEXT_GRAY] CGColor]];
        self.iv_icon = [[UIImageView alloc]initWithFrame:CGRectMake(7,4,8,11)];
        [self addSubview:self.iv_icon];
        
        self.lb_number = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_icon.frame) + 3, 0, 20, 20)];
        [self.lb_number setFont:[UIFont systemFontOfSize:FONT_SIZE - 3]];
        [self.lb_number setTextColor:[UIColor colorWithHexString:COLOR_TEXT_GRAY]];
        [self addSubview:self.lb_number];
    }
    return self;
}

- (void)setLableText:(NSString *)str{
    [self.lb_number setText:str];
    float width = [str fittingLabelWidthWithHeight:20 andFontSize:[UIFont systemFontOfSize:FONT_SIZE - 3]];
    [self.lb_number setFrame:CGRectMake(CGRectGetMaxX(self.iv_icon.frame) + 3, 0, width, 20)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,CGRectGetMaxX(self.iv_icon.frame) + 3 + width + 5,20)];
}

@end
