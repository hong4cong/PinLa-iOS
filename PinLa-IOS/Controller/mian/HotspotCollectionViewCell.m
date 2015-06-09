//
//  HotspotCollectionViewCell.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HotspotCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@implementation HotspotCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
//    //添加风火轮，图片没有加载完成时显示
//    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    //设置显示样式,见UIActivityIndicatorViewStyle的定义
//    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    //设置背景色
//    self.indicator.color = [UIColor clearColor];
//    self.indicator.backgroundColor = [UIColor clearColor];
//    //设置背景透明
//    self.indicator.alpha = 0.5;
//    //设置背景为圆角矩形
//    //开始显示Loading动画
//    [self.indicator startAnimating];
//    [self addSubview:self.indicator];
    
//    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    self.imgView.tag = 1;
//    self.imgView.hidden = YES;
//    [self addSubview:self.imgView];
    
    _imgView = [[HexagonView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _imgView.tag = 1;
//    _imgView.hidden = YES;
    [self addSubview:_imgView];
    
//    UILabel* percent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    [percent setTextColor:[UIColor whiteColor]];
//    [percent setFont:[UIFont systemFontOfSize:12]];
//    percent.textAlignment = NSTextAlignmentCenter;
//    percent.tag = 2;
//    percent.backgroundColor = [UIColor blackColor];
//    percent.alpha = 0.4;
//    percent.hidden = YES;
//    [self addSubview:percent];
    
}

- (void)configureForImage:(NSArray*)arry {
    
}

- (void)startIndicatorAnimating
{
    [self.indicator startAnimating];
}

- (void)stopIndicatorAnimating
{
    [self.indicator stopAnimating];
}

- (void)contentDataWithEntity:(UserEntity*)entity
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:entity.user_icon] placeholderImage:[UIImage imageNamed:@"avatar"]];
}
@end
