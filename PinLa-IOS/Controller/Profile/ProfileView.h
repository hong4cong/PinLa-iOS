//  用户信息
//  ProfileView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/10.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoView.h"

typedef NS_ENUM(NSUInteger, ProfileType) {
    ProfileTypeSelf,
    ProfileTypeEdit,
    ProfileTypeOthers,
};

@protocol ProfileViewDelegate <NSObject>

- (void)backToForwardViewAction:(UIButton *)sender;
- (void)changeBackgroudImageAction:(UIButton *)sender;
- (void)shareProfileAction:(UIButton *)sender;
- (void)modifyMyProfileAction:(UIButton *)sender;

- (void)switchSegmentedControlAction:(UISegmentedControl *)sg;

- (void)followAction:(UIButton *)sender;

@end

@interface ProfileView : UIView<UITextViewDelegate>

@property (nonatomic, weak)   id<ProfileViewDelegate> delegate;

//everyType
@property (nonatomic, strong) UIImageView       *iv_bgImage;
@property (nonatomic, strong) UIButton          *btn_back;
@property (nonatomic, strong) UIButton          *btn_share;
@property (nonatomic, strong) HexagonView       *iv_avatar;
@property (nonatomic, strong) UILabel           *lb_nickname;
@property (nonatomic, strong) UILabel           *lb_UID;
//typeSelf and typeOthers
@property (nonatomic, strong) UISegmentedControl    *sg_dynamic;
@property (nonatomic, strong) UITableView       *tb_list;
@property (nonatomic, strong) UIButton          *btn_modify;

@property (nonatomic, strong) UITextView       *tv_sign;
@property (nonatomic, strong) GCPlaceholderTextView *tv_description;
@property (nonatomic, strong) UIView                *v_userInfo;

//typeEdit
@property (nonatomic, strong) UIButton          *btn_saveEdit;
@property (nonatomic, strong) UIButton          *btn_changeBgImage;
@property (nonatomic, strong) MyInfoView        *v_myInfo;

@property (nonatomic, strong) UILabel           *lb_location;
@property (nonatomic, strong) UIButton          *btn_follow;

-(instancetype)initWithFrame:(CGRect)frame andProfileType:(ProfileType)profileType;

- (void)contentWithEntity:(UserEntity*)entity;

- (void)contentWithUserStorage;

@end
