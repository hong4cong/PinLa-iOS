//
//  PaticipantExchangeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PaticipantTradeView.h"

@implementation PaticipantTradeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tb_paticipantList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStylePlain];
        self.tb_paticipantList.backgroundColor = [UIColor clearColor];
//        self.tb_paticipantList.allowsSelection = NO;
        self.tb_paticipantList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
        self.tb_paticipantList.tableFooterView = [UIView new];
        [self addSubview:self.tb_paticipantList];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
