//
//  LoginViewController.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/8.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginView.h"

@interface LoginViewController : BaseViewController
@property(nonatomic,strong) LoginView *v;
@property(nonatomic,assign)id<RENavigationDelegate> delegate;

@end
