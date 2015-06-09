//
//  PurchaseCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PurchaseCell.h"
#import "NSString+Size.h"
@implementation PurchaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _hv_commodity = [[HexagonView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 10, 50, 50) image:[UIImage imageNamed:@"avatar"]];
        [self addSubview:_hv_commodity];
        
        _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_hv_commodity.frame)+20, 10, 200, 25)];
        _lb_title.font = [UIFont boldSystemFontOfSize:FONT_SIZE + 1];
        [_lb_title setTextColor:[UIColor whiteColor]];
        [self addSubview:_lb_title];
        
        _lb_description = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_hv_commodity.frame)+20, CGRectGetMaxY(_lb_title.frame), 200, 25)];
        [_lb_description setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
        _lb_description.font = [UIFont systemFontOfSize:FONT_SIZE- 1];
        [self addSubview:_lb_description];
        
        _btn_price = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_price.frame = CGRectMake(CGRectGetWidth(self.frame)-MARGIN_RIGHT-50, 22, 50, 26);
        _btn_price.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE - 1];
        _btn_price.layer.borderWidth = 1.0f;
        _btn_price.layer.borderColor = [[UIColor whiteColor] CGColor];
        _btn_price.layer.cornerRadius = 12.0f;
        [_btn_price setTitle:@"￥10" forState:UIControlStateNormal];
        [_btn_price setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_btn_price];
    }
    return self;
}

- (void)contentWithPurchaseEntity:(PurchaseEntity *)purchaseEntity{
    NSString *str_price = [NSString stringWithFormat:@"￥%@",@"12"];
    [_btn_price setTitle:str_price forState:UIControlStateNormal];
    float width = [str_price fittingLabelWidthWithHeight:26 andFontSize:[UIFont systemFontOfSize:FONT_SIZE - 1]];
    if (width + 10 > 50) {
        [_btn_price setFrame:CGRectMake(CGRectGetWidth(self.frame) - MARGIN_RIGHT - width - 10, 22, width+10, 26)];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
