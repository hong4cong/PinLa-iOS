//
//  CompleteView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/27.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CompleteView.h"

@implementation CompleteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iv_complete = [[UIImageView alloc]initWithFrame:CGRectMake(140, 37, frame.size.width - 280, frame.size.width - 280)];
        [self.iv_complete setImage:[UIImage imageNamed:@"right_type1"]];
        [self addSubview:self.iv_complete];
        
        self.lb_title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iv_complete.frame) + 18,frame.size.width, 30)];
        [self.lb_title setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_title setFont:[UIFont systemFontOfSize:FONT_SIZE + 3]];
        [self.lb_title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lb_title];
        
        self.lb_UID = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lb_title.frame) + 5,frame.size.width, 30)];
        [self.lb_UID setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_UID setFont:[UIFont systemFontOfSize:FONT_SIZE + 3]];
        [self.lb_UID setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lb_UID];
        
        self.btn_login = [[UIButton alloc]initWithFrame:CGRectMake(8,frame.size.height - 12 - 45,frame.size.width - 16,45)];
        [self.btn_login.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE + 4]];
        [self.btn_login setTitle:@"登 录" forState:UIControlStateNormal];
        UIImage *imageBack = [UIImage imageNamed:@"button_background"];
        imageBack = [imageBack stretchableImageWithLeftCapWidth:floorf(imageBack.size.width/2) topCapHeight:floorf(imageBack.size.height/2)];
        [self.btn_login setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self.btn_login setBackgroundImage:imageBack forState:UIControlStateNormal];
        [self addSubview:self.btn_login];
    }
    return self;
}
@end
