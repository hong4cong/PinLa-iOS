//
//  UserProfileViewController.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseViewController.h"

@interface UserProfileViewController : BaseViewController

@property (nonatomic, strong) UIImageView       *iv_bgImage;
@property (nonatomic, strong) UIButton          *btn_back;
@property (nonatomic, strong) UIButton          *btn_saveEdit;
@property (nonatomic, strong) UIButton          *btn_changeBgImage;

@property (nonatomic, strong) UIImageView       *iv_avatar;
@property (nonatomic, strong) UITextField       *tf_nickname;


@end
