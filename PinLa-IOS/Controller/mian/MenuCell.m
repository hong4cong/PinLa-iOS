//
//  MenuCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        _iv_icon = [[UIImageView alloc] initWithFrame:CGRectMake(27, 13, 30, 30)];
        [self addSubview:_iv_icon];
        
        _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iv_icon.frame)+23, 15, 100, 20)];
        _lb_title.font = [UIFont systemFontOfSize:FONT_SIZE+5];
        _lb_title.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        _lb_title.highlightedTextColor = [UIColor blackColor];
        [self addSubview:_lb_title];
        
        _red_point = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 10, 10)];
        _red_point.backgroundColor = [UIColor redColor];
        _red_point.layer.borderWidth = .5;
        _red_point.layer.borderColor = [UIColor redColor].CGColor;
        _red_point.layer.cornerRadius = 5;
        _red_point.layer.masksToBounds = YES;
        [self addSubview:_red_point];
        
        [AppUtils addLineOnView:self WithFrame:CGRectMake(CGRectGetMinX(_lb_title.frame), 49, CGRectGetWidth(self.frame)-CGRectGetMinX(_lb_title.frame), 1)];
    }
    return self;
}

- (void)contentWithTitleAndImageName:(NSArray *)arr{
    [self contentWithTitleAndImageName:arr isShowRedPoint:NO];
}

- (void)contentWithTitleAndImageName:(NSArray *)arr isShowRedPoint:(BOOL)isShowRedPoint{
    if (isShowRedPoint) {
        _red_point.hidden = NO;
    }else{
        _red_point.hidden = YES;
    }
        
    _lb_title.text = [arr firstObject];
    _iv_icon.image = [UIImage imageNamed:[arr objectAtIndex:1]];
    _iv_icon.highlightedImage = [UIImage imageNamed:[arr lastObject]];
    
    
}

- (void)setSelectedItem:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        _lb_title.textColor = [UIColor blackColor];
    }else{
        self.backgroundColor = [UIColor blackColor];
        _lb_title.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
