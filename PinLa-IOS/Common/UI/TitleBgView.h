//
//  TitleBgView.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBgView : UIView

@property(nonatomic,strong)UILabel* lb_title;
@property (nonatomic, strong) UILabel   *lb_noti;
@property(nonatomic,strong)UIImageView* indicatorView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

@end
