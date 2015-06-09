//
//  TitleBgView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "TitleBgView.h"
#import "NSString+Size.h"

@implementation TitleBgView

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        [self initView:title];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:title];
    }
    return self;
}

- (void)initView:(NSString*)title
{
    int width = [title fittingLabelWidthWithHeight:20 andFontSize:[UIFont boldSystemFontOfSize:18]];
    
    self.lb_title = [[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_title.frame = CGRectMake(0, 0, width, 20);
    self.lb_title.font = [UIFont boldSystemFontOfSize:18];
    self.lb_title.textColor = [UIColor whiteColor];
    self.lb_title.textAlignment = NSTextAlignmentCenter;
    self.lb_title.text = @"碎片";
    [self addSubview:self.lb_title];
    
    self.indicatorView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.indicatorView.frame = CGRectMake(CGRectGetMaxX(self.lb_title.frame)+3, 8, 10, 8);
    self.indicatorView.image = [UIImage imageNamed:@"img_dropdown_icon"];
    [self addSubview:self.indicatorView];
    
    self.lb_noti = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.indicatorView.frame)+3, 0, 10 , 10)];
    self.lb_noti.backgroundColor = [UIColor redColor];
    self.lb_noti.layer.cornerRadius = 5.f;
    [self.lb_noti.layer setMasksToBounds:YES];
    self.lb_noti.hidden = YES;
    [self addSubview:self.lb_noti];
    
    self.frame = CGRectMake((200 - width - 20)/2, 0, width + 10 + 3, 20);
    
}

@end
