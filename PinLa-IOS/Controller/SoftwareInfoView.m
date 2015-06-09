//
//  SoftwareInfoView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SoftwareInfoView.h"

@implementation SoftwareInfoView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        self.lb_title = [[UILabel alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(frame)-16)/2, 80, 16)];
        self.lb_title.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        self.lb_title.textColor = [UIColor whiteColor];
        self.lb_title.text = title;
        [self addSubview:self.lb_title];
        
        self.lb_content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.lb_title.frame), (CGRectGetHeight(frame)-16)/2, CGRectGetWidth(self.frame)-CGRectGetMaxY(self.lb_title.frame)-15, 16)];
        self.lb_content.textAlignment = NSTextAlignmentRight;
        self.lb_content.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        self.lb_content.textColor = [UIColor whiteColor];
        self.lb_content.text = content;
        [self addSubview:self.lb_content];

        [AppUtils addLineOnView:self WithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
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
