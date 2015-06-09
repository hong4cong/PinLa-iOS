//
//  BackpackCell.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BackpackCell.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"
#import <UIImageView+WebCache.h>

@implementation BackpackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.iv_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 10, 50, 50)];
        self.iv_avatar.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iv_avatar];
        
        self.lb_name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, 17, 200, 20)];
        [self.lb_name setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
        [self.lb_name setText:@""];
        [self.lb_name setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lb_name];
        
        self.iv_allNumber = [[ImageLableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, CGRectGetMaxY(self.lb_name.frame) + 4, 40, 20)];
        [self.iv_allNumber.iv_icon setImage:[UIImage imageNamed:@"img_unlocked_number"]];
        [self addSubview:self.iv_allNumber];
        
        self.iv_loackedNumber = [[ImageLableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_allNumber.frame) + 4, CGRectGetMaxY(self.lb_name.frame) + 4, 40, 20)];
        [self.iv_loackedNumber.iv_icon setImage:[UIImage imageNamed:@"img_locked_number"]];
        [self addSubview:self.iv_loackedNumber];
        
        self.iv_icon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 25 - 12, (self.frame.size.height - 25), 24, 30)];
        self.iv_icon.image = [UIImage imageNamed:@"img_synthesis_props"];
        self.iv_icon.hidden = YES;
        [self addSubview:self.iv_icon];
        
    }
    return self;
}

- (void)contentBackpackWithBackpackEntity:(BackpackEntity *)backpackEntity{
    [self.iv_loackedNumber setLableText:@""];
    [self.iv_allNumber setLableText:@""];
    [self.iv_allNumber setFrame:CGRectMake(CGRectGetMaxX(self.iv_loackedNumber.frame)+5, self.iv_allNumber.frame.origin.y, self.iv_allNumber.frame.size.width, self.iv_allNumber.frame.size.height)];
}

- (void)contentDataWithPieceEntity:(NSMutableArray *)arr_entity
{
    if ([AppUtils isCanSynthesis:arr_entity]) {
        self.iv_icon.hidden = NO;
        self.iv_icon.image = [UIImage imageNamed:@"img_synthesis_props"];
    }else{
        self.iv_icon.hidden = YES;
    }
    
    PieceEntity* entity = [arr_entity objectAtIndex:0];
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    self.lb_name.text = entity.piece_title;
    
    NSInteger lock_num = 0;
    for (int i = 0; i < arr_entity.count; i++) {
        PieceEntity* entity = [arr_entity objectAtIndex:i];
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
    
    
    [self.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(long)arr_entity.count]];
}

- (void)contentDataWithPropertyEntity:(NSMutableArray *)arr_entity
{
    PropertyEntity* entity = [arr_entity objectAtIndex:0];
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.prop_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    self.lb_name.text = entity.prop_title;
    
    int lock_num = 0;
    for (int i = 0; i < arr_entity.count; i++) {
        PropertyEntity* entity = [arr_entity objectAtIndex:i];
        if(entity.prop_lock){
            lock_num += 1;
        }
    }
    
    if (lock_num) {
        self.iv_loackedNumber.hidden = NO;
        [self.iv_loackedNumber setLableText:[NSString stringWithFormat:@"%ld",(long)lock_num]];
    }else{
        self.iv_loackedNumber.hidden = YES;
    }
    
    [self.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(arr_entity.count - lock_num)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
