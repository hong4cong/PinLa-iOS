//  用户信息页面
//  ProfileViewController.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseViewController.h"
#import "ProfileView.h"

@interface ProfileViewController : BaseViewController

@property (nonatomic       ) ProfileType   profileType;
@property (nonatomic,strong) UserEntity* entity;
@end
