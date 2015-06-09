//
//  ProfileView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/10.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ProfileView.h"
#import <UIImageView+WebCache.h>
#import "UserStorage.h"

@implementation ProfileView

-(instancetype)initWithFrame:(CGRect)frame andProfileType:(ProfileType)profileType
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv_bg = [[UIImageView alloc] initWithFrame:frame];
        iv_bg.image = [UIImage imageNamed:@"img_profile_bg"];
        [self addSubview:iv_bg];
        
        //背景图片
        _iv_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 260)];
        _iv_bgImage.image = [UIImage imageNamed:@"img_profile_bg2"];
        [self addSubview:_iv_bgImage];
        
        UIImageView *iv_cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 260)];
        iv_cover.image = [UIImage imageNamed:@"img_profile_bgcover"];
        [self addSubview:iv_cover];
        
        //回退按钮
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_back.frame = CGRectMake(12, 20+8, 30, 30);
        [_btn_back setImage:[UIImage imageNamed:@"img_common_back"] forState:UIControlStateNormal];
        [_btn_back addTarget:self action:@selector(backToForwardViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_back];
        
        //分享按钮
        _btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_share.frame = CGRectMake(CGRectGetWidth(frame)-15-30, 20+8, 30, 30);
        [_btn_share setImage:[UIImage imageNamed:@"img_profile_share"] forState:UIControlStateNormal];
        [_btn_share addTarget:self action:@selector(shareProfileAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_btn_share];
        
        //头像
        _iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 160)/2, 20, 160, 160) image:[UIImage imageNamed: @"img_common_defaultAvatar"]];
        [self addSubview:_iv_avatar];
        
        //昵称
        _lb_nickname = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_iv_avatar.frame)+8, CGRectGetWidth(frame)-MARGIN_LEFT-MARGIN_RIGHT, 28)];
        _lb_nickname.font = [UIFont systemFontOfSize:FONT_SIZE+11];
        _lb_nickname.textAlignment = NSTextAlignmentCenter;
        _lb_nickname.textColor = [UIColor whiteColor];
        [self addSubview:_lb_nickname];
        
//        _lb_UID = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_lb_nickname.frame)+3, CGRectGetWidth(frame)-MARGIN_LEFT-MARGIN_RIGHT, 20)];
//        _lb_UID.font = [UIFont systemFontOfSize:FONT_SIZE+3];
//        _lb_UID.textAlignment = NSTextAlignmentCenter;
//        _lb_UID.textColor = [UIColor whiteColor];
//        [self addSubview:_lb_UID];
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"动态",@"道具",@"简介",nil];
        _sg_dynamic = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        _sg_dynamic.frame = CGRectMake(8, CGRectGetMaxY(_lb_nickname.frame)+23  , CGRectGetWidth(frame)-8-8, 29);
        [_sg_dynamic addTarget:self action:@selector(switchSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _sg_dynamic.selectedSegmentIndex = 0;//设置默认选择项索引
        _sg_dynamic.tintColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        [_sg_dynamic setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} forState:UIControlStateNormal];
        [self addSubview:_sg_dynamic];
        
        _tb_list = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sg_dynamic.frame)+16 , CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetMaxY(_sg_dynamic.frame)-16)];
        _tb_list.backgroundColor = [UIColor clearColor];
        _tb_list.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
        _tb_list.tableFooterView = [UIView new];
        _tb_list.showsVerticalScrollIndicator = NO;
        _tb_list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tb_list];
        
//        _tv_sign = [[UITextView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_sg_dynamic.frame)+16 , CGRectGetWidth(frame) - 24, CGRectGetHeight(frame) - CGRectGetMaxY(_sg_dynamic.frame)-16)];
//        _tv_sign.font = [UIFont systemFontOfSize:18];
//        _tv_sign.textColor = [UIColor whiteColor];
//        _tv_sign.backgroundColor = [UIColor clearColor];
//        _tv_sign.keyboardAppearance = UIKeyboardAppearanceDark;
//        _tv_sign.returnKeyType = UIReturnKeyDone;
//        _tv_sign.editable = YES;
//        _tv_sign.delegate = self;
//        _tv_sign.text = [UserStorage userSign];
//        _tv_sign.hidden = YES;
//        [self addSubview:_tv_sign];
        
        self.v_userInfo = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_sg_dynamic.frame)+16, self.frame.size.width, 300)];
        self.v_userInfo.hidden = YES;
        [self addSubview:self.v_userInfo];
        //UID
        UILabel *title_UID = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 76, 46)];
        title_UID.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        title_UID.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        title_UID.textAlignment = NSTextAlignmentRight;
        title_UID.text = @"拼号";
        [self.v_userInfo addSubview:title_UID];
        
        _lb_UID = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title_UID.frame)+17,1, CGRectGetWidth(frame)-CGRectGetWidth(title_UID.frame)-10, 46)];
        _lb_UID.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        _lb_UID.textColor = [UIColor whiteColor];
        [self.v_userInfo addSubview:_lb_UID];
        
        [AppUtils addLineOnView:self.v_userInfo WithFrame:CGRectMake(CGRectGetMinX(_lb_UID.frame), CGRectGetMaxY(title_UID.frame), CGRectGetWidth(frame)-CGRectGetMinX(_lb_UID.frame), 1)];
        
        //个性签名
        UILabel *title_description = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title_UID.frame)+17, 76, 18)];
        title_description.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        title_description.text = @"简介";
        title_description.textAlignment = NSTextAlignmentRight;
        title_description.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        [self.v_userInfo addSubview:title_description];
        
        _tv_description = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title_description.frame)+14, CGRectGetMaxY(_lb_UID.frame)+8, CGRectGetWidth(frame)-CGRectGetWidth(title_description.frame)-13, 100)];
        _tv_description.backgroundColor = [UIColor clearColor];
        _tv_description.textColor = [UIColor whiteColor];
        _tv_description.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        _tv_description.text = @"该用户还没有简介";
        _tv_description.editable = NO;
        _tv_description.selectable = NO;
        [self.v_userInfo addSubview:_tv_description];
        
        switch (profileType) {
            case ProfileTypeSelf:{
                self.btn_modify = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iv_avatar.frame)+24, CGRectGetMidY(_iv_avatar.frame)-18, 36, 36)];
                [self.btn_modify setImage:[UIImage imageNamed:@"img_profile_setting"] forState:UIControlStateNormal];
                [self.btn_modify addTarget:self action:@selector(modifyMyProfileAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.btn_modify];
            }
                break;
                
            case ProfileTypeOthers:{
                UIImageView* img_location = [[UIImageView alloc]initWithFrame:CGRectMake(28, CGRectGetMidY(_iv_avatar.frame)-18, 36, 36)];
                img_location.image = [UIImage imageNamed:@"img_user_location"];
                [self addSubview:img_location];
                
                self.lb_location = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img_location.frame), 98, 14)];
                self.lb_location.textAlignment = NSTextAlignmentCenter;
                self.lb_location.textColor = [UIColor whiteColor];
                self.lb_location.font = [UIFont systemFontOfSize:13];
                [self addSubview:_lb_location];
                
                self.btn_follow = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iv_avatar.frame)+24, CGRectGetMidY(_iv_avatar.frame)-18, 36, 36)];
                [self.btn_follow setImage:[UIImage imageNamed:@"img_user_unfollow"] forState:UIControlStateNormal];
                [self.btn_follow setImage:[UIImage imageNamed:@"img_user_follow"] forState:UIControlStateSelected];
                [self.btn_follow addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.btn_follow];
            }
                break;

            default:
                break;
        }
        
        
    }
    return self;
}

- (void)backToForwardViewAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(backToForwardViewAction:)]) {
        [self.delegate backToForwardViewAction:sender];
    }
}

- (void)shareProfileAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(shareProfileAction:)]) {
        [self.delegate shareProfileAction:sender];
    }

}

- (void)changeBackgroudImageAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(changeBackgroudImageAction:)]) {
        [self.delegate changeBackgroudImageAction:sender];
    }
}


- (void)switchSegmentedControlAction:(UISegmentedControl *)sg{
    if ([self.delegate respondsToSelector:@selector(switchSegmentedControlAction:)]) {
        [self.delegate switchSegmentedControlAction:sg];
    }
}

- (void)modifyMyProfileAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(modifyMyProfileAction:)]) {
        [self.delegate modifyMyProfileAction:sender];
    }
}

- (void)followAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(followAction:)]) {
        [self.delegate followAction:sender];
    }
}

- (void)contentWithEntity:(UserEntity*)entity
{
    [_iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.user_icon] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    
    _lb_nickname.text = entity.nick_name;
    
    if (entity.followers) {
        self.btn_follow.selected = YES;
    }else{
        self.btn_follow.selected = NO;
    }
    _lb_UID.text = [NSString stringWithFormat:@"%@",entity.user_id];
    
    if (entity.user_sign.length == 0) {
        self.tv_description.text = @"该用户还没有简介";
    }else{
        self.tv_description.text = entity.user_sign;
    }
}

- (void)contentWithUserStorage
{
    [_iv_avatar sd_setImageWithURL:[NSURL URLWithString:[UserStorage userIcon]] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    
    _lb_nickname.text = [UserStorage userNickName];
    
    _lb_UID.text = [NSString stringWithFormat:@"%@",[UserStorage userId]];
    
    if ([UserStorage userSign].length == 0) {
        self.tv_description.text = @"该用户还没有简介";
    }else{
        self.tv_description.text = [UserStorage userSign];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
