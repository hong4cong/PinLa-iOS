//
//  ForgetPasswordView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SetPasswordView.h"
#import "UITextField+ResignKeyboard.h"

@implementation SetPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tf_newPassword = [[UITextField alloc] initWithFrame:CGRectMake(25, 35,170, 30)];
        self.tf_newPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY];
        self.tf_newPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入8-16位密码" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_newPassword setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_newPassword.font = [UIFont systemFontOfSize:16];
        self.tf_newPassword.adjustsFontSizeToFitWidth = YES;
        self.tf_newPassword.keyboardAppearance = UIKeyboardAppearanceDark;
        self.tf_newPassword.secureTextEntry = YES;
        self.tf_newPassword.tag = 1;
        self.tf_newPassword.returnKeyType = UIReturnKeyDone;
        self.tf_newPassword.delegate = self;
        self.tf_newPassword.returnKeyType = UIReturnKeyDone;
        [self.tf_newPassword setNormalInputAccessory];
        [self addSubview:self.tf_newPassword];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 70, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        self.iv_newPasswordStatus = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tf_newPassword.frame)+5, 39, 25, 25)];
        [self addSubview:self.iv_newPasswordStatus];
        
        self.btn_VisibleSwitch = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 25 - 28, 39, 25, 25)];
        [self.btn_VisibleSwitch setBackgroundImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
        self.btn_VisibleSwitch.tag = 1;
        [self.btn_VisibleSwitch addTarget:self action:@selector(visibleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn_VisibleSwitch];
        
        self.tf_confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(25,105,170, 30)];
        //        self.tf_password.borderStyle = UITextBorderStyleRoundedRect;
        self.tf_confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf_confirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_confirmPassword setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_confirmPassword.font = [UIFont systemFontOfSize:16];
        self.tf_confirmPassword.adjustsFontSizeToFitWidth = YES;
        self.tf_confirmPassword.secureTextEntry = YES;
        self.tf_confirmPassword.keyboardAppearance = UIKeyboardAppearanceDark;
        self.tf_confirmPassword.returnKeyType = UIReturnKeyDone;
        [self.tf_confirmPassword setNormalInputAccessory];
        self.tf_confirmPassword.tag = 2;
        self.tf_confirmPassword.returnKeyType = UIReturnKeyDone;
        self.tf_confirmPassword.delegate = self;
        [self addSubview:self.tf_confirmPassword];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 140, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        self.iv_confirmPasswordStatus = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tf_confirmPassword.frame)+5,109, 25, 25)];
        [self addSubview:self.iv_confirmPasswordStatus];
        
        self.btn_submit = [[UIButton alloc]initWithFrame:CGRectMake(8,frame.size.height - 12 - 45,frame.size.width - 16,45)];
        [self.btn_submit.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE + 4]];
        [self.btn_submit setTitle:@"提 交" forState:UIControlStateNormal];
        UIImage *imageBack = [UIImage imageNamed:@"button_background"];
        imageBack = [imageBack stretchableImageWithLeftCapWidth:floorf(imageBack.size.width/2) topCapHeight:floorf(imageBack.size.height/2)];
        [self.btn_submit setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self.btn_submit setBackgroundImage:imageBack forState:UIControlStateNormal];
        [self addSubview:self.btn_submit];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        if (self.tf_newPassword.text.length >= 8 && self.tf_newPassword.text.length <= 16) {
            [self.iv_newPasswordStatus setImage:[UIImage imageNamed:@"right_type2"]];
        }else{
            [self.iv_newPasswordStatus setImage:[UIImage imageNamed:@"wrong"]];
        }
    }else{
        if ([self.tf_newPassword.text isEqualToString:self.tf_confirmPassword.text] && (self.tf_confirmPassword.text.length >= 8 && self.tf_confirmPassword.text.length <= 16)) {
            [self.iv_confirmPasswordStatus setImage:[UIImage imageNamed:@"right_type2"]];
        }else{
            [self.iv_confirmPasswordStatus setImage:[UIImage imageNamed:@"wrong"]];
        }
    }
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_submit setFrame:CGRectMake(8,self.frame.size.height - 12 - 45,self.frame.size.width - 16,45)];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_submit setFrame:CGRectMake(8,170,self.frame.size.width - 16,45)];
    }];
}

- (void)visibleAction{
    
    if (self.btn_VisibleSwitch.tag == 1) {
        [self.btn_VisibleSwitch setBackgroundImage:[UIImage imageNamed:@"invisible"] forState:UIControlStateNormal];
        self.tf_newPassword.secureTextEntry = YES;
        self.tf_confirmPassword.secureTextEntry = YES;
        self.btn_VisibleSwitch.tag = 2;
    }else{
        [self.btn_VisibleSwitch setBackgroundImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
        self.tf_newPassword.secureTextEntry = NO;
        self.tf_confirmPassword.secureTextEntry = NO;
        self.btn_VisibleSwitch.tag = 1;
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
