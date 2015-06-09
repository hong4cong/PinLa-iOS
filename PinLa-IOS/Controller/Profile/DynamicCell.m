//
//  DynamicCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "DynamicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            //状态点
            _iv_status = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 32, 32)];
            _iv_status.image = [UIImage imageNamed:@"img_common_bigCircle"];
            UIImageView *iv_cover = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 22, 22)];
            iv_cover.image = [UIImage imageNamed:@"img_common_middleCircle"];
            [_iv_status addSubview:iv_cover];
            
        }else{
            //状态点
            _iv_status = [[UIImageView alloc] initWithFrame:CGRectMake(19, 0, 18, 18)];
            _iv_status.image = [UIImage imageNamed:@"img_common_smallCircle"];
        }
        [self addSubview:_iv_status];
        
        
        //描述
        _lb_description = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMidY(_iv_status.frame)-14/2, 140, 14)];
        _lb_description.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        _lb_description.textColor = [UIColor whiteColor];
        [self addSubview:_lb_description];
        
        //时间
        _lb_time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_description.frame), CGRectGetMaxY(_lb_description.frame)-12, CGRectGetWidth(self.frame)-8-CGRectGetMaxX(_lb_description.frame), 12)];
        _lb_time.font = [UIFont systemFontOfSize:FONT_SIZE-3];
        _lb_time.textColor = [UIColor whiteColor];
        _lb_time.textAlignment = NSTextAlignmentRight;
        [self addSubview:_lb_time];
        
    }
    return self;
}

- (void)contentWithDynamicEntity:(DynamicEntity *)dynamicEntity{
    for (int i=100000; i<100099;i++) {
        if ([self viewWithTag:i]) {
            [[self viewWithTag:i] removeFromSuperview];
        }else{
            break;
        }
    }
    _lb_description.text = dynamicEntity.dynamic_detail;
    _lb_time.text =  dynamicEntity.dynamic_time;
    NSUInteger imageCount = dynamicEntity.dynamic_pic_list.count;
    for (int i=0; i<imageCount; i++) {
        DynamicPicEntity *dynamicPicEntity = [dynamicEntity.dynamic_pic_list objectAtIndex:i];
        int col = i%7;
        int row = i/7;
        UIImageView *iv_piece = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lb_description.frame)+col*(32+3), CGRectGetMaxY(_lb_description.frame)+10+row*(39+5), 32, 39)];
        [AppUtils contentImageView:iv_piece withURLString:dynamicPicEntity.dynamic_pic_link andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
        iv_piece.tag = 100000+i;
        [self addSubview:iv_piece];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_iv_status.frame), CGRectGetMaxY(_iv_status.frame)+10, 1, 100+(dynamicEntity.dynamic_pic_list.count-1)/7*(39+5)-CGRectGetMaxY(_iv_status.frame)-10 -10)];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
