//
//  ExchangeCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "TradeCell.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"

@interface TradeCell ()

@property (nonatomic, assign)ExchangeCellType type;

@end

@implementation TradeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lb_description = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 100, 36)];
        _lb_description.numberOfLines = 0;
        [_lb_description sizeToFit];
        _lb_description.textColor = [UIColor whiteColor];
        _lb_description.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self addSubview:_lb_description];
        
        _btn_trash = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_trash.frame = CGRectMake(CGRectGetWidth(self.frame)-8-40, 15, 40, 40);
        [_btn_trash setBackgroundImage:[UIImage imageNamed:@"img_change_trash"] forState:UIControlStateNormal];
        [_btn_trash addTarget:self action:@selector(moveCellToTrashAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_trash];
    }
    return self;
}

- (void)contentCellWithExchangeEntity:(TradeEntity *)tradeEntity noti:(BOOL)isNoti{
    NSUInteger count = tradeEntity.trade_piece_list.count + tradeEntity.trade_prop_list.count;
    NSInteger tag = 100000;
    
    for (int j = 100000; j<100005; j++) {
        UIView *v = [self viewWithTag:j];
        if (v) {
            [v removeFromSuperview];
        }else{
            break;
        }
    }
    
    if (count<=4) {
        for (int i = 0; i<tradeEntity.trade_piece_list.count; i++) {
            PieceEntity *pieceEntity = [tradeEntity.trade_piece_list objectAtIndex:i];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(32+3), 20, 32, 38)];
            iv.tag = tag++;
            [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
            [self addSubview:iv];
        }
        for (int i = 0; i<tradeEntity.trade_prop_list.count; i++) {
            PropertyEntity *propertyEntity = [tradeEntity.trade_prop_list objectAtIndex:i];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i+tradeEntity.trade_piece_list.count)*(32+3), 20, 32, 38)];
            iv.tag = tag++;
            [AppUtils contentImageView:iv withURLString:propertyEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
            [self addSubview:iv];
        }
        _lb_description.frame = CGRectMake(15+count*(32+3)+7, 18, CGRectGetWidth(self.frame)-30-8-25-15-count*(32+3)-7, 36);
    }else{
        if (tradeEntity.trade_piece_list.count>=3) {
            for (int i = 0; i<3; i++) {
                PieceEntity *pieceEntity = [tradeEntity.trade_piece_list objectAtIndex:i];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(32+3), 20, 32, 38)];
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
                [self addSubview:iv];
            }
        }else{
            for (int i = 0; i<tradeEntity.trade_piece_list.count; i++) {
                PieceEntity *pieceEntity = [tradeEntity.trade_piece_list objectAtIndex:i];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(32+3), 20, 32, 38)];
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
                [self addSubview:iv];
            }
            for (int i = 0; i<3-tradeEntity.trade_piece_list.count; i++) {
                PropertyEntity *propertyEntity = [tradeEntity.trade_prop_list objectAtIndex:i];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i+tradeEntity.trade_piece_list.count)*(32+3), 20, 32, 38)];
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:propertyEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"test_hex"]];
                [self addSubview:iv];
            }
        }
        UIImageView *iv_moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(15+3*(32+3)+7, 31, 24, 8)];
        iv_moreImage.image = [UIImage imageNamed:@"img_change_moreImage"];
        iv_moreImage.tag = tag++;
        [self addSubview:iv_moreImage];
        _lb_description.frame = CGRectMake(CGRectGetMaxX(iv_moreImage.frame)+10, 18, CGRectGetWidth(self.frame)-30-8-25-CGRectGetMaxX(iv_moreImage.frame)-10,36);
    }
    
    _lb_description.text = tradeEntity.trade_detail;
    if (tradeEntity.trade_num.count>0 && isNoti) {
        UILabel *lb_noti = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lb_description.frame)+5, 10, 16, 16)];
        lb_noti.backgroundColor = [UIColor redColor];
        lb_noti.layer.cornerRadius = lb_noti.frame.size.height/2;
        lb_noti.layer.masksToBounds = YES;
        lb_noti.textAlignment = NSTextAlignmentCenter;
        lb_noti.textColor = [UIColor whiteColor];
        lb_noti.font = [UIFont systemFontOfSize:FONT_SIZE-2];
        lb_noti.text = [NSString stringWithFormat:@"%lu",(unsigned long)tradeEntity.trade_num.count];
        [self addSubview:lb_noti];
    }
}

- (void)moveCellToTrashAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(moveCellToTrashAction:)]) {
        [self.delegate moveCellToTrashAction:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
