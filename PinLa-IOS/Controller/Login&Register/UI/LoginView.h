//
//  LoginView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView<UITextFieldDelegate>
@property(nonatomic,strong) UITextField                         *tf_phone;//手机号
@property(nonatomic,strong) UITextField                         *tf_password;//登陆密码
@property(nonatomic,strong) UIButton                            *btn_forgetPassword;//登陆按钮
@property(nonatomic,strong) UIButton                            *btn_login;//登陆按钮
@property(nonatomic,strong) UILabel                             *lb_error_msg;//错误提示
@property(nonatomic,strong) UIButton                            *btn_register;

@end
