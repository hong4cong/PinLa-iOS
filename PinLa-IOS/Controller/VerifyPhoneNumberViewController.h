//
//  RegisterViewController.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, TYPE) {
    REGISTER,
    FORGETPASSWORD
};

@interface VerifyPhoneNumberViewController : BaseViewController
@property(nonatomic,assign)id<RENavigationDelegate> delegate;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic)BOOL  isFirstView;
@end
