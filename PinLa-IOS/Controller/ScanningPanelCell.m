//
//  ScanningPanelCell.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ScanningPanelCell.h"
#import "PieceEntity.h"
#import <UIImageView+WebCache.h>

@implementation ScanningPanelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    // Initialization code
    self.iv_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 42, 42) ];
    self.iv_avatar.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iv_avatar];
    
    self.lb_name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, 17, 180, 20)];
    [self.lb_name setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [self.lb_name setText:@"杜蕾斯系列"];
    [self.lb_name setTextColor:[UIColor whiteColor]];
    [self addSubview:self.lb_name];
    
    self.lb_detail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame) + 10, CGRectGetMaxY(self.lb_name.frame) + 4, 100, 20)];
    [self.lb_detail setFont:[UIFont systemFontOfSize:FONT_SIZE - 2]];
    [self.lb_detail setTextColor:[UIColor colorWithHexString:COLOR_TEXT_GRAY]];
    [self.lb_detail setText:@"碎片2"];
    [self addSubview:self.lb_detail];
    
    self.iv_icon = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40 - 5 - 42, (self.frame.size.height - 30), 42, 42)];
    [self.iv_icon setImage:[UIImage imageNamed:@"img_unselected"] forState:UIControlStateNormal];
    [self.iv_icon setImage:[UIImage imageNamed:@"img_selected"] forState:UIControlStateHighlighted];
    [self.iv_icon setImage:[UIImage imageNamed:@"img_selected"] forState:UIControlStateSelected];
        
//    [self.iv_icon addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.iv_icon];
    
    }
    
    return self;
}

- (void)btnAction:(id)sender
{
    self.iv_icon.selected = !self.iv_icon.selected;
}

- (void)contentDataWithEntity:(PieceEntity*)entity
{
    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:entity.piece_icon] placeholderImage:[UIImage imageNamed:@"img_prop_def"]];
    self.lb_name.text = entity.piece_title;
    self.lb_detail.text = [NSString stringWithFormat:@"碎片%@",entity.piece_branch];
    
}
@end
