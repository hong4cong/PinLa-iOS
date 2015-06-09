//
//  LargeHModalPanel.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LargeHModalPanel.h"

@implementation LargeHModalPanel

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentViewFrame = self.bounds;
        
        UIImageView *iv_bg = [[UIImageView alloc] initWithFrame:contentViewFrame];
        iv_bg.image = [UIImage imageNamed:@"img_common_largePanelBg"];
        [self.contentView addSubview:iv_bg];
        
        self.lb_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 17,CGRectGetWidth(contentViewFrame)-60, 14)];
        self.lb_title.text = title;
        [self.lb_title setTextColor:[UIColor grayColor]];
        [self.lb_title setFont:[UIFont boldSystemFontOfSize:FONT_SIZE - 1]];
        [self.contentView addSubview:self.lb_title];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, CGRectGetWidth(contentViewFrame), 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.contentView addSubview:self.line];
        
        self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame) - 42, 0, 40, 40)];
        [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_back];
        
        //设置下面两个按钮的title
        NSString *leftTitle = @"确认";
        NSString *rightTitle = @"取消";
        
        if (buttonTitles && buttonTitles.count>=2) {
            leftTitle = [buttonTitles objectAtIndex:0];
            rightTitle = [buttonTitles objectAtIndex:1];
        }
        
        self.btn_bottomLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_bottomLeft.frame = CGRectMake(0, CGRectGetHeight(contentViewFrame)-57, CGRectGetWidth(contentViewFrame)/2, 57);
        self.btn_bottomLeft.layer.borderColor = [[UIColor grayColor] CGColor];
        self.btn_bottomLeft.layer.borderWidth = 1.0f;
        self.btn_bottomLeft.tag = 100001;
        [self.btn_bottomLeft setTitle:leftTitle forState:UIControlStateNormal];
        [self.btn_bottomLeft setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self.btn_bottomLeft addTarget:self action:@selector(clickBottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_bottomLeft];
        
        self.btn_bottomRight = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_bottomRight.frame = CGRectMake(CGRectGetWidth(contentViewFrame)/2, CGRectGetHeight(contentViewFrame)-57, CGRectGetWidth(contentViewFrame)/2, 57);
        self.btn_bottomRight.tag = 100002;
        self.btn_bottomRight.layer.borderColor = [[UIColor grayColor] CGColor];
        self.btn_bottomRight.layer.borderWidth = 1.0f;
        [self.btn_bottomRight setTitle:rightTitle forState:UIControlStateNormal];
        [self.btn_bottomRight addTarget:self action:@selector(clickBottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_bottomRight];

        
    }
    return self;
}

- (void)clickBottomButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 100001:
        {
            if ([self.delegate respondsToSelector:@selector(modelView:clickBottomButtonAction:)]) {
                [self.delegate modelView:self clickBottomButtonAction:LargeHMPButtonTypeLeft];
            }
        }
            break;
        case 100002:
        {
            if ([self.delegate respondsToSelector:@selector(modelView:clickBottomButtonAction:)]) {
                [self.delegate modelView:self clickBottomButtonAction:LargeHMPButtonTypeRight];
            }
        }
            break;
        default:
            break;
    }
}


- (void)goBack:(id)sender{
    if ([self.delegate respondsToSelector:@selector(modelView:goBackAction:)]) {
        [self.delegate modelView:self goBackAction:sender];
    }
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
