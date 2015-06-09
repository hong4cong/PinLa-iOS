//
//  FragmentDetailCell.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "FragmentDetailCell.h"
#import "PieceEntity.h"
#import <UIImageView+WebCache.h>
#import "PieceNumberingEntity.h"
#import "PieceItemEntity.h"

@implementation FragmentDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iv_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 5, 50, 50)];
        self.iv_avatar.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iv_avatar];
        
        self.lb_name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, 12, 150, 20)];
        [self.lb_name setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
        [self.lb_name setText:@"杜蕾斯系列"];
        [self.lb_name setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lb_name];
        
        self.lb_detail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, CGRectGetMaxY(self.lb_name.frame), 150, 20)];
        [self.lb_detail setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        [self.lb_detail setFont:[UIFont systemFontOfSize:FONT_SIZE - 1]];
        [self.lb_detail setText:@"碎片 5"];
        [self addSubview:self.lb_detail];
        
        self.iv_allNumber = [[ImageLableView alloc]initWithFrame:CGRectMake(self.frame.size.width - 12 - 40 - 40, 10, 40, 18)];
        [self.iv_allNumber.iv_icon setImage:[UIImage imageNamed:@"img_unlocked_number"]];
        [self addSubview:self.iv_allNumber];
        
        self.iv_loackedNumber = [[ImageLableView alloc]initWithFrame:CGRectMake(self.frame.size.width - 12 - 40 - 40, 32, 40, 18)];
        [self.iv_loackedNumber.iv_icon setImage:[UIImage imageNamed:@"img_locked_number"]];
        [self addSubview:self.iv_loackedNumber];
        
    }
    return self;
}

- (void)contentBackpackWithBackpackEntity:(BackpackEntity *)backpackEntity{
    [self.iv_loackedNumber setLableText:@""];
    [self.iv_loackedNumber setFrame:CGRectMake(self.frame.size.width - 12 - 40 - self.iv_loackedNumber.frame.size.width, 11, self.iv_loackedNumber.frame.size.width, 18)];
    [self.iv_allNumber setLableText:@""];
    [self.iv_allNumber setFrame:CGRectMake(self.frame.size.width - 12 - 40 - self.iv_allNumber.frame.size.width, 31, self.iv_allNumber.frame.size.width, 18)];
}

- (void)contentDataWithPieceEntity:(NSArray *)arr_data{
    PieceEntity* entity = [arr_data firstObject];
    self.lb_name.text = entity.piece_title;
    self.lb_detail.text = [NSString stringWithFormat:@"碎片%@",entity.piece_branch];
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    NSInteger lock_num = 0;
    for (int i = 0; i < arr_data.count; i++) {
        PieceEntity* entity = [arr_data objectAtIndex:i];
        if(entity.piece_lock){
            lock_num += 1;
        }
    }
    if (lock_num) {
        self.iv_loackedNumber.hidden = NO;
        [self.iv_loackedNumber setLableText:[NSString stringWithFormat:@"%ld",(long)lock_num]];
    }else{
        self.iv_loackedNumber.hidden = YES;
    }
    
    [self.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(long)arr_data.count]];
}

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity row:(NSInteger)row
{
    self.lb_name.text = entity.piece_title;
    
    PieceItemEntity* itemEntity = [entity.piece_list objectAtIndex:row];
    
    self.lb_detail.text = [NSString stringWithFormat:@"碎片%@",itemEntity.piece_branch];
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    
    if (itemEntity.lock_id) {
        self.iv_loackedNumber.hidden = NO;
        [self.iv_loackedNumber setLableText:[NSString stringWithFormat:@"%ld",(long)itemEntity.lock_id.count]];
    }else{
        self.iv_loackedNumber.hidden = YES;
    }
    [self.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(long)(itemEntity.lock_id.count + itemEntity.normal_id.count)]];
}

@end
