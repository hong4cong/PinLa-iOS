//
//  LoginView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LoginView.h"
#import "UIColor+Util.h"
#import "UIButton+Style.h"
#import "BaseStyleView.h"
#import "UITextField+ResignKeyboard.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv_name = [[UIImageView alloc]initWithFrame:CGRectMake(25, 30, 30, 30)];
        [iv_name setImage:[UIImage imageNamed:@"login_name"]];
        [self addSubview:iv_name];
        
        self.tf_phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv_name.frame) + 10, 35,200, 30)];
        self.tf_phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY];
        self.tf_phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_phone setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_phone.font = [UIFont systemFontOfSize:16];
        self.tf_phone.adjustsFontSizeToFitWidth = YES;
        self.tf_phone.textColor = color;
        self.tf_phone.keyboardType = UIKeyboardTypeNumberPad;
        self.tf_phone.keyboardAppearance = UIKeyboardAppearanceDark;
        [self.tf_phone setNormalInputAccessory];
        self.tf_phone.delegate = self;
        [self addSubview:self.tf_phone];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 70, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        UIImageView *iv_password = [[UIImageView alloc]initWithFrame:CGRectMake(25, 100, 30, 30)];
        [iv_password setImage:[UIImage imageNamed:@"login_password"]];
        [self addSubview:iv_password];
        
        self.tf_password = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv_password.frame) + 10,105, frame.size.width - 24, 30)];
        //        self.tf_password.borderStyle = UITextBorderStyleRoundedRect;
        self.tf_password.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf_password.secureTextEntry = YES;
        self.tf_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_password setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_password.font = [UIFont systemFontOfSize:16];
        self.tf_password.adjustsFontSizeToFitWidth = YES;
        self.tf_password.textColor = color;
        self.tf_password.delegate = self;
        self.tf_password.keyboardAppearance = UIKeyboardAppearanceDark;
        self.tf_password.returnKeyType = UIReturnKeyDone;
        [self.tf_password setNormalInputAccessory];
        [self addSubview:self.tf_password];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 140, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        self.btn_forgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(8,frame.size.height - 12 - 45,(frame.size.width - 16 - 2)/2,45)];
        [self.btn_forgetPassword setTitle:NSLocalizedString(@"忘记密码?", @"") forState:UIControlStateNormal];
        [self.btn_forgetPassword setBackgroundImage:[UIImage imageNamed:@"forgetPassword_left"] forState:UIControlStateNormal];
        [self.btn_forgetPassword setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        self.btn_forgetPassword.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 4];
        self.btn_forgetPassword.showsTouchWhenHighlighted = YES;
        [self addSubview:self.btn_forgetPassword];
        
        //登录按钮
        self.btn_login = [[UIButton alloc] initWithFrame:CGRectMake(8 + (frame.size.width - 16 - 2)/2 + 2,frame.size.height - 12 - 45,(frame.size.width - 16 - 2)/2,45)];
        [self.btn_login setTitle:NSLocalizedString(@"登 录", @"") forState:UIControlStateNormal];
        self.btn_login.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 4];
        [self.btn_login setTitleColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY] forState:UIControlStateNormal];
        [self.btn_login setBackgroundImage:[UIImage imageNamed:@"login_right"] forState:UIControlStateNormal];
        self.btn_login.showsTouchWhenHighlighted = YES;
        [self addSubview:self.btn_login];
        
        //错误信息
        self.lb_error_msg = [[UILabel alloc] initWithFrame:CGRectMake(0,145,320,20)];
        self.lb_error_msg.textAlignment = NSTextAlignmentCenter;
        self.lb_error_msg.textColor = [UIColor redColor];
        self.lb_error_msg.font = [UIFont systemFontOfSize:FONT_SIZE_CONTENT];
        [self addSubview:self.lb_error_msg];
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   [UIView animateWithDuration:0.15 animations:^{
       [self.btn_login setFrame:CGRectMake(8 + (self.frame.size.width - 16 - 2)/2 + 2,170,(self.frame.size.width - 16 - 2)/2,45)];
       [self.btn_forgetPassword setFrame:CGRectMake(8,170,(self.frame.size.width - 16 - 2)/2,45)];
   }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
    [self.btn_login setFrame:CGRectMake(8 + (self.frame.size.width - 16 - 2)/2 + 2,self.frame.size.height - 12 - 45,(self.frame.size.width - 16 - 2)/2,45)];
    [self.btn_forgetPassword setFrame:CGRectMake(8,self.frame.size.height - 12 - 45,(self.frame.size.width - 16 - 2)/2,45)];
    }];
}

- (UIView *)lineWithRect:(CGRect)frame
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
    return line;
}

@end
