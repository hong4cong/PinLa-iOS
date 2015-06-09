//
//  RegisterFirstView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "VerifyPhoneNumberView.h"
#import "BaseStyleView.h"
#import "UITextField+ResignKeyboard.h"

@implementation VerifyPhoneNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv_name = [[UIImageView alloc]initWithFrame:CGRectMake(25, 30, 30, 30)];
        [iv_name setImage:[UIImage imageNamed:@"phoneNumber"]];
        [self addSubview:iv_name];
        
        self.tf_phone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv_name.frame) + 10, 35,160, 30)];
        self.tf_phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY];
        self.tf_phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_phone setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_phone.font = [UIFont systemFontOfSize:16];
        self.tf_phone.adjustsFontSizeToFitWidth = YES;
        self.tf_phone.delegate = self;
        self.tf_phone.keyboardType = UIKeyboardTypeNumberPad;
        self.tf_phone.keyboardAppearance = UIKeyboardAppearanceDark;
        [self.tf_phone setNormalInputAccessory];
        [self addSubview:self.tf_phone];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 70, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        self.btn_send = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tf_phone.frame) + 5, 35, 64, 30)];
        [self.btn_send setTitle:@"发送" forState:UIControlStateNormal];
        [self.btn_send setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        self.btn_send.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self.btn_send setBackgroundImage:[UIImage imageNamed:@"button_background"] forState:UIControlStateNormal];
        self.btn_send.showsTouchWhenHighlighted = YES;
        [self.btn_send setEnabled:NO];
        [self addSubview:self.btn_send];
        
        UIImageView *iv_password = [[UIImageView alloc]initWithFrame:CGRectMake(30, 100, 30, 30)];
        [iv_password setImage:[UIImage imageNamed:@"verify_code"]];
        [self addSubview:iv_password];
        
        self.tf_verificationCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv_password.frame) + 10,105, frame.size.width - 24, 30)];
        //        self.tf_password.borderStyle = UITextBorderStyleRoundedRect;
        self.tf_verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf_verificationCode.secureTextEntry = YES;
        self.tf_verificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:color}];
        [self.tf_verificationCode setTextColor:[UIColor colorWithHexString:COLOR_BUTTON_LIGHTGRAY]];
        self.tf_verificationCode.font = [UIFont systemFontOfSize:16];
        self.tf_verificationCode.adjustsFontSizeToFitWidth = YES;
        [self.tf_verificationCode setNormalInputAccessory];
        self.tf_verificationCode.delegate = self;
        self.tf_verificationCode.keyboardType = UIKeyboardTypeNumberPad;
        self.tf_verificationCode.keyboardAppearance = UIKeyboardAppearanceDark;
        self.tf_verificationCode.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.tf_verificationCode];
        
        [self addSubview:[AppUtils addLineWithFrame:CGRectMake(25, 140, frame.size.width - 50, LINE_HEIGHT) andColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]]];
        
        self.btn_nextStep = [[UIButton alloc]initWithFrame:CGRectMake(8,frame.size.height - 12 - 45,frame.size.width - 16,45)];
        [self.btn_nextStep.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE + 4]];
        [self.btn_nextStep setTitle:@"下一步 >" forState:UIControlStateNormal];
        UIImage *imageBack = [UIImage imageNamed:@"button_background"];
        imageBack = [imageBack stretchableImageWithLeftCapWidth:floorf(imageBack.size.width/2) topCapHeight:floorf(imageBack.size.height/2)];
        [self.btn_nextStep setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self.btn_nextStep setBackgroundImage:imageBack forState:UIControlStateNormal];
        [self addSubview:self.btn_nextStep];
    }
    return self;
}

#pragma - mark textfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    //得到输入框的内容
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //限制输入框中只能11位
    if (self.tf_phone == textField)
    {
        //SEAN(FIXED):判断符与左右条件间加一个空格（a == b、a > b）
        //SEAN(FIXED):统一else if右边花括号格式（建议统一为右边括号不换行，类比第一个if判断）
        if ([toBeString length] == 11) {
            //            self.btn_nextStep.enabled = YES;
            
            self.btn_send.enabled = YES;
            [self.btn_send setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];//边框颜色
        }else if([toBeString length] < 11){
            //            self.btn_nextStep.enabled = NO;
            
            self.btn_send.enabled = NO;
            [self.btn_send setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//边框颜色
            
        }else if([toBeString length] > 11){
            
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_nextStep setFrame:CGRectMake(8,self.frame.size.height - 12 - 45,self.frame.size.width - 16,45)];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_nextStep setFrame:CGRectMake(8,170,self.frame.size.width - 16,45)];
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //限制输入框中只能11位
    if (self.tf_phone == textField)
    {
        self.btn_send.enabled = NO;
        [self.btn_send.layer setBorderColor:[UIColor lightGrayColor].CGColor];//边框颜色
        
    }else if(self.tf_verificationCode == textField)
    {
        self.btn_nextStep.enabled = NO;
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
