//
//  SelectFragmentCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/6.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SelectFragmentCell.h"

@implementation SelectFragmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iv_fragment = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 39, 45)];
        [self addSubview:_iv_fragment];
        
        _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iv_fragment.frame)+10, 20, 180, 14)];
        _lb_title.textColor = [UIColor whiteColor];
        _lb_title.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        [self addSubview:_lb_title];
        
        _lb_detail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iv_fragment.frame)+10, CGRectGetMaxY(_lb_title.frame)+10, 180, 12)];
        _lb_detail.textColor = [UIColor grayColor];
        _lb_detail.font = [UIFont systemFontOfSize:FONT_SIZE-3];
        [self addSubview:_lb_detail];
        
        self.btn_select = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_select.frame = CGRectMake(CGRectGetWidth(self.frame)-13-42-8, 12, 42, 42);
        [self.btn_select setImage:[UIImage imageNamed:@"img_unselected"] forState:UIControlStateNormal];
        [self.btn_select setImage:[UIImage imageNamed:@"img_selected"] forState:UIControlStateHighlighted];
        [self.btn_select setImage:[UIImage imageNamed:@"img_selected"] forState:UIControlStateSelected];
        [self addSubview:self.btn_select];
    }
    return self;
}



- (void)contentCellWithPropertyEntity:(PropertyEntity *)propertyEntity{
    [AppUtils contentImageView:_iv_fragment withURLString:propertyEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
    _lb_title.text = propertyEntity.prop_title;
    _lb_detail.text = [NSString stringWithFormat:@"%@",propertyEntity.prop_detail];
}

- (void)contentCellWithPieceEntity:(PieceEntity *)pieceEntity{
    [AppUtils contentImageView:_iv_fragment withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
    _lb_title.text = pieceEntity.piece_title;
    _lb_detail.text = [NSString stringWithFormat:@"碎片%@",pieceEntity.piece_branch];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
