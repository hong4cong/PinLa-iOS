//
//  MessageTypeTwoCell.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/29.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "MessageTypeTwoCell.h"
#import "NSString+Size.h"
#import <UIImageView+WebCache.h>
@implementation MessageTypeTwoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.iv_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 15, 40, 40)];
        [self addSubview:self.iv_avatar];
        
        self.lb_title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 11, 15, 120, 20)];
        [self.lb_title setFont:[UIFont systemFontOfSize:FONT_SIZE - 1]];
        [self.lb_title setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_title setText:@"大嘴2号已经确认了与你的交换"];
        [self addSubview:self.lb_title];
        
        self.lb_time = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 11, 35, self.frame.size.width - CGRectGetMaxX(self.iv_avatar.frame) - 11 - 38 - 70 - 14, 20)];
        [self.lb_time setFont:[UIFont systemFontOfSize:FONT_SIZE - 2]];
        [self.lb_time setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_time setText:@"2015.4.12 12:12"];
        [self addSubview:self.lb_time];
        
        self.btn_detailAction = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lb_time.frame), 20, 70, 20)];
        [self.btn_detailAction setTitle:@"展开详情" forState:UIControlStateNormal];
        [self.btn_detailAction.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE - 1]];
        [self.btn_detailAction setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self addSubview:self.btn_detailAction];
        
        self.btn_delete = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 18 - 24, 23, 24, 24)];
        [self.btn_delete setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:self.btn_delete];
        
        self.lb_detail = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN_LEFT, 70, self.frame.size.width - 2 * MARGIN_LEFT, 20)];
        [self.lb_detail setFont:[UIFont systemFontOfSize:FONT_SIZE - 1]];
        [self.lb_detail setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_detail setNumberOfLines:0];
        
    }
    return self;
}
- (void)contentMessageWithMessageEntity:(MessageEntity *)messageEntity{
    [self.lb_detail setText:messageEntity.messageDetail];
    CGFloat hight = [self.lb_detail.text fittingLabelHeightWithWidth: self.frame.size.width - 2 * MARGIN_LEFT andFontSize:[UIFont systemFontOfSize:FONT_SIZE - 1]];
    [self.lb_detail setFrame:CGRectMake(MARGIN_LEFT, 70, self.frame.size.width - 2 * MARGIN_LEFT, hight)];
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:messageEntity.pic] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    [self.lb_title setText:messageEntity.title];
    [self.lb_time setText:messageEntity.datetime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
