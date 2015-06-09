//  个人设置（可修改）
//  MyInfoView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/10.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "GCPlaceholderTextView.h"

@interface MyInfoView : UIView

@property (nonatomic, strong) UIScrollView      *scv_bg;
@property (nonatomic, strong) UILabel           *lb_UID;
@property (nonatomic, strong) GCPlaceholderTextView           *tv_description;
@property (nonatomic, strong) UISwitch          *sw_messagePush;

-(void)loadData:(UserEntity *)userEntity;

@end
