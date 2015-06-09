//
//  ExchangeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ExchangeView.h"

@implementation ExchangeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建交换
        _iv_createExchange = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(frame)-16, 44)];
        _iv_createExchange.image = [UIImage imageNamed:@"img_change_addBg"];
        [self addSubview:_iv_createExchange];
        
        UIImageView *iv_add = [[UIImageView alloc] initWithFrame:CGRectMake(110-8, 12, 20, 20)];
        iv_add.image = [UIImage imageNamed:@"img_change_add"];
        [_iv_createExchange addSubview:iv_add];
        
        UILabel *lb_add = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv_add.frame)+2, 12, 150, 20)];
        lb_add.text = @"创建交换";
        lb_add.font = [UIFont systemFontOfSize:FONT_SIZE+5];
        lb_add.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        [_iv_createExchange addSubview:lb_add];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createExchangeAction:)];
        tap.numberOfTapsRequired = 1;
        _iv_createExchange.userInteractionEnabled = YES;
        [_iv_createExchange addGestureRecognizer:tap];
        
        _tb_tradeList = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iv_createExchange.frame)+5, CGRectGetWidth(frame), CGRectGetHeight(frame)-CGRectGetMaxY(_iv_createExchange.frame)-5) style:UITableViewStylePlain];
        _tb_tradeList.backgroundColor = [UIColor clearColor];
        _tb_tradeList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
        _tb_tradeList.tableFooterView = [UIView new];
        [self addSubview:_tb_tradeList];
        
        
    }
    return self;
}

- (void)backToMenuAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(backToMenuAction:)]) {
        [self.delegate backToMenuAction:sender];
    }
}

- (void)createExchangeAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(createExchangeAction:)]) {
        [self.delegate createExchangeAction:tap];
    }
}

- (void)updateExchangeState:(ExchangeCellType)type{
    switch (type) {
        case ExchangeCellType_init:
        {
            _iv_createExchange.frame = CGRectMake(8, 0, CGRectGetWidth(self.frame)-16, 44);
            _iv_createExchange.hidden = NO;
            
            _tb_tradeList.frame = CGRectMake(0, CGRectGetMaxY(_iv_createExchange.frame)+5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(_iv_createExchange.frame)-5);
        }
            break;
        case ExchangeCellType_join:
        {
            _iv_createExchange.hidden = YES;
            
            _tb_tradeList.frame = CGRectMake(0, 5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-5);
        }
            break;
    }
}

@end
