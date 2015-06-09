//
//  RegisterFirstView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyPhoneNumberView : UIView<UITextFieldDelegate>

@property(nonatomic,strong) UITextField                         *tf_phone;//手机号
@property(nonatomic,strong) UITextField                         *tf_verificationCode;//验证码
@property(nonatomic,strong) UIButton                            *btn_send;
@property(nonatomic,strong) UIButton                            *btn_nextStep;
@end
