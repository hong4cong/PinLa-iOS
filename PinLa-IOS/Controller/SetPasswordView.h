//
//  ForgetPasswordView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseStyleView.h"
typedef NS_ENUM(NSInteger, TYPENUMBER) {
    REGISTERNUMBER,
    FORGETPASSWORDNUMBER
};

@interface SetPasswordView : UIView<UITextFieldDelegate>
@property(nonatomic,strong) UITextField                         *tf_newPassword;//手机号
@property(nonatomic,strong) UITextField                         *tf_confirmPassword;//验证码
@property(nonatomic,strong) UIButton                            *btn_VisibleSwitch;
@property(nonatomic,strong) UIImageView                         *iv_show;
@property(nonatomic,strong) UIButton                            *btn_submit;
@property(nonatomic,strong) UILabel                             *lb_passwordMemo;
@property(nonatomic,strong) UIImageView                         *iv_newPasswordStatus;
@property(nonatomic,strong) UIImageView                         *iv_confirmPasswordStatus;
- (void)setFrameWithType:(TYPENUMBER)type;
@end
