//
//  AddRelationView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AddRelationView.h"
#import "UITextField+ResignKeyboard.h"

@implementation AddRelationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tf_UID = [[UITextField alloc] initWithFrame:CGRectMake(80, 35,CGRectGetWidth(frame)-64*2 - 50, 30)];
        _tf_UID.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
        UIColor *color = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        _tf_UID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入对方的UID" attributes:@{NSForegroundColorAttributeName: color}];
        [_tf_UID setNormalInputAccessory];
        _tf_UID.keyboardType = UIKeyboardTypeNumberPad;
        _tf_UID.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        _tf_UID.keyboardAppearance = UIKeyboardAppearanceDark;
        _tf_UID.returnKeyType = UIReturnKeyDone;
        [self addSubview:_tf_UID];
        
        self.btn_search = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tf_UID.frame)+1, 30, 30, 30)];
        [self.btn_search setBackgroundImage:[UIImage imageNamed:@"iconfont-search"] forState:UIControlStateNormal];
        [self.btn_search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn_search];
        
        UIView *v_line = [[UIView alloc]initWithFrame:CGRectMake(64, 69, CGRectGetWidth(frame)-64*2, 1)];
        [v_line setBackgroundColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]];
        [self addSubview:v_line];
        
        self.bg_color = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(v_line.frame)+31, CGRectGetWidth(frame), 80)];
        self.bg_color.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        self.bg_color.alpha = 0.2;
        
        self.v_background = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(v_line.frame)+31, CGRectGetWidth(frame), 80)];
        
        self.lb_memo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 80)];
        [self.lb_memo setText:@"无可添加联系人"];
        [self.lb_memo setTextColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]];
        [self.lb_memo setFont:[UIFont systemFontOfSize:FONT_SIZE + 3]];
        [self.lb_memo setTextAlignment:NSTextAlignmentCenter];
        [self.v_background addSubview:self.lb_memo];
        
        _v_user = [[RelationCell alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), 80)];
        [_v_user.iv_status setImage:[UIImage imageNamed:@"sendMessage"]];
        _btn_addFromContact = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_addFromContact.frame = CGRectMake(50, CGRectGetMaxY(self.bg_color.frame)+50, 80, 80);
        [_btn_addFromContact setImage:[UIImage imageNamed:@"iconfont-phone"] forState:UIControlStateNormal];
        [_btn_addFromContact addTarget:self action:@selector(addRelationFromContactAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_btn_addFromContact];
        
        _btn_addFromWchat = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_addFromWchat.frame = CGRectMake(CGRectGetMaxX(_btn_addFromContact.frame)+60, CGRectGetMaxY(self.bg_color.frame)+50, 80, 80);
        [_btn_addFromWchat setImage:[UIImage imageNamed:@"iconfont-weixin"] forState:UIControlStateNormal];
        [_btn_addFromWchat addTarget:self action:@selector(addRelationFromWchatAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_btn_addFromWchat];
        
        UILabel *lb_contact = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btn_addFromContact.frame) + 10,180, 20)];
        lb_contact.textAlignment = NSTextAlignmentCenter;
        lb_contact.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        lb_contact.textColor = [UIColor whiteColor];
        lb_contact.text = @"通过通讯录添加";
//        [self addSubview:lb_contact];
        
        UILabel *lb_wchat = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 180, CGRectGetMaxY(_btn_addFromWchat.frame) + 10,180, 20)];
        lb_wchat.textAlignment = NSTextAlignmentCenter;
        lb_wchat.textColor = [UIColor whiteColor];
        lb_wchat.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        lb_wchat.text = @"邀请微信好友";
//        [self addSubview:lb_wchat];
        
    }
    return self;
}

- (void)searchAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(searchAction:)]) {
        [self.delegate searchAction:sender];
    }
}


- (void)addRelationFromContactAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(addRelationFromContactAction:)]) {
        [self.delegate addRelationFromContactAction:sender];
    }
}

- (void)addRelationFromWchatAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(addRelationFromWchatAction:)]) {
        [self.delegate addRelationFromWchatAction:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
