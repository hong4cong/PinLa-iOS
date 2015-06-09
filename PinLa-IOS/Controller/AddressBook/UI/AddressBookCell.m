//
//  AddressBookCell.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AddressBookCell.h"
#import <UIImageView+WebCache.h>
@implementation AddressBookCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _hv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 10, 60, 60) image:[UIImage imageNamed:@"img_prop_def"]];
        [self addSubview:_hv_avatar];
        
        _lb_nickname = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_hv_avatar.frame)+20, 20, 200, 40)];
        _lb_nickname.font = [UIFont boldSystemFontOfSize:FONT_SIZE + 4];
        [_lb_nickname setTextColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]];
        [self addSubview:_lb_nickname];
        
        _iv_status = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-MARGIN_RIGHT-42,20, 40, 40)];
        _iv_status.image = [UIImage imageNamed:@"sendMessage"];
        [self addSubview:_iv_status];
        
    }
    return self;
}

- (void)contentAddressBookWithUserEntity:(UserEntity *)userEntity{
    [_hv_avatar sd_setImageWithURL:[NSURL URLWithString:userEntity.user_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    [_lb_nickname setText:userEntity.nick_name];
    if (userEntity.status == 0) {
        _iv_status.image = [UIImage imageNamed:@"sendMessage"];
    }else if (userEntity.status == 1){
        _iv_status.image = [UIImage imageNamed:@"attention"];
    }else{
        _iv_status.image = nil;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
