//
//  ForgetPasswordViewController.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SetPasswordView.h"
@interface SetPasswordViewController :BaseViewController
@property (nonatomic,assign)TYPENUMBER    type;
@property (nonatomic,strong)NSString      *account;
@property (nonatomic,strong)NSString      *verify_Code;
@property (nonatomic,strong)NSString      *userId;
@end
