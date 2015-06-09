//
//  MyInfoView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/10.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "MyInfoView.h"
#import "UserStorage.h"

@implementation MyInfoView


//@property (nonatomic, strong) UIScrollView      *scv_bg;
//@property (nonatomic, strong) UIImageView       *iv_avatar;
//@property (nonatomic, strong) UILabel           *lb_nickname;
//@property (nonatomic, strong) UILabel           *lb_UID;
//@property (nonatomic, strong) UILabel           *lb_description;
//@property (nonatomic, strong) UISwitch          *switch_location;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //可滑动
        _scv_bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scv_bg.contentSize = _scv_bg.frame.size;
        [self addSubview:_scv_bg];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 3)];
        line.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        [_scv_bg addSubview:line];
        
        //UID
        UILabel *title_UID = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), 76, 46)];
        title_UID.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        title_UID.textColor = [UIColor whiteColor];
        title_UID.textAlignment = NSTextAlignmentRight;
        title_UID.text = @"拼号";
        [_scv_bg addSubview:title_UID];
        
        _lb_UID = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title_UID.frame)+14, CGRectGetMaxY(line.frame), CGRectGetWidth(frame)-CGRectGetWidth(title_UID.frame)-10, 46)];
        _lb_UID.font = [UIFont systemFontOfSize:FONT_SIZE+3];
        _lb_UID.textColor = [UIColor whiteColor];
        [_scv_bg addSubview:_lb_UID];
        
        [AppUtils addLineOnView:_scv_bg WithFrame:CGRectMake(CGRectGetMinX(_lb_UID.frame), CGRectGetMaxY(title_UID.frame), CGRectGetWidth(frame)-CGRectGetMinX(_lb_UID.frame), 1)];
        
        
        //个性签名
        UILabel *title_description = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title_UID.frame)+17, 76, 18)];
        title_description.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        title_description.text = @"简介";
        title_description.textAlignment = NSTextAlignmentRight;
        title_description.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        [_scv_bg addSubview:title_description];
        
        _tv_description = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title_description.frame)+14, CGRectGetMaxY(_lb_UID.frame)+7, CGRectGetWidth(frame)-CGRectGetWidth(title_description.frame)-13, 100)];
        _tv_description.backgroundColor = [UIColor clearColor];
        _tv_description.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        _tv_description.font = [UIFont systemFontOfSize:FONT_SIZE+3];
        _tv_description.placeholder = @"请输入简介";
        [_scv_bg addSubview:_tv_description];
        
        [AppUtils addLineOnView:_scv_bg WithFrame:CGRectMake(90, CGRectGetMaxY(_tv_description.frame)+17, CGRectGetWidth(frame), 1)];
        
        //消息推送
        UILabel *title_push = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tv_description.frame)+17*2, 76, 18)];
        title_push.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        title_push.text = @"消息推送";
        title_push.textAlignment = NSTextAlignmentRight;
        title_push.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
//        [_scv_bg addSubview:title_push];
        
        _sw_messagePush = [[UISwitch alloc] initWithFrame:CGRectMake(242, CGRectGetMaxY(_tv_description.frame)+17+14, 76, 18)];
        _sw_messagePush.on = YES;
        _sw_messagePush.tintColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
//        [_scv_bg addSubview:_sw_messagePush];
        
    }
    return self;
}

-(void)loadData:(UserEntity *)userEntity
{
    _tv_description.text = [UserStorage userSign];
    _lb_UID.text = [UserStorage userId];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
