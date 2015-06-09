//
//  BaseStyleView.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/14.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "BaseStyleView.h"

@interface BaseStyleView ()

@property(nonatomic,strong)UIView* topLine;
@property(nonatomic,strong)UIView* bottomLine;

@end

@implementation BaseStyleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.topLine = [UIView new];
    self.topLine.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
    [self addSubview:self.topLine];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
    [self addSubview:self.bottomLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), LINE_HEIGHT);
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), LINE_HEIGHT);
}

@end
