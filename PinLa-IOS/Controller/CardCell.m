//
//  CardCell.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/6.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CardCell.h"
#import "CardEntity.h"
#import <UIImageView+WebCache.h>

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.lb_title = [[UILabel alloc]initWithFrame:CGRectMake(15+12, 17, 200, 20)];
        [self.lb_title setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
        [self.lb_title setText:@"星巴克恋上玛奇朵兑换券"];
        [self.lb_title setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lb_title];
        
        self.lb_dec = [[UILabel alloc]initWithFrame:CGRectMake(15+12, CGRectGetMaxY(self.lb_title.frame), 200, 45)];
        [self.lb_dec setFont:[UIFont systemFontOfSize:FONT_SIZE - 3]];
        [self.lb_dec setText:@"凭此券在指定门市免费享受一杯手工玛奇朵饮料"];
        [self.lb_dec setTextColor:[UIColor whiteColor]];
        self.lb_dec.numberOfLines = 3;
        [self addSubview:self.lb_dec];
        
        self.iv_icon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 25 - 55, 20, 55, 55)];
        self.iv_icon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iv_icon];
        
        self.lb_cardNum = [[UILabel alloc]initWithFrame:CGRectMake(12, 110, CGRectGetWidth(self.frame) - 24, 40)];
        [self.lb_cardNum setFont:[UIFont systemFontOfSize:21]];
        [self.lb_cardNum setText:@"XXXX - XXXX - XXXX - XXXX"];
        [self.lb_cardNum setTextColor:[UIColor blackColor]];
        self.lb_cardNum.textAlignment = NSTextAlignmentCenter;
        self.lb_cardNum.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self addSubview:self.lb_cardNum];
        
        self.lb_time = [[UILabel alloc]initWithFrame:CGRectMake(15+12, CGRectGetMinY(self.lb_cardNum.frame) - 30, 200, 30)];
        [self.lb_time setFont:[UIFont systemFontOfSize:FONT_SIZE - 3]];
        [self.lb_time setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lb_time];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.lb_cardNum.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.lb_cardNum.bounds;
        maskLayer.path = maskPath.CGPath;
        self.lb_cardNum.layer.mask = maskLayer;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)contentWithCardEntity:(CardEntity*)cardEntity
{
    self.lb_title.text = cardEntity.card_title;
    self.lb_dec.text = cardEntity.card_detail;
    self.lb_cardNum.text = [self formatCardNo:cardEntity.card_no];
    [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:cardEntity.card_icon] placeholderImage:nil];
    
    if(cardEntity.card_validity && ![cardEntity.card_validity isEqualToString:@""]){
        self.lb_time.text = [NSString stringWithFormat:@"有效期：%@",cardEntity.card_validity];
    }else{
        self.lb_time.text = @"";
    }
}

- (NSString *)formatCardNo:(NSString *)str
{
    if(str.length == 16){
        str = [NSString stringWithFormat:@"%@ - %@ - %@ - %@",[str substringWithRange:NSMakeRange(0, 4)],[str substringWithRange:NSMakeRange(4, 4)],[str substringWithRange:NSMakeRange(8, 4)],[str substringWithRange:NSMakeRange(12, 4)]];
    }
    return str;
}

@end
