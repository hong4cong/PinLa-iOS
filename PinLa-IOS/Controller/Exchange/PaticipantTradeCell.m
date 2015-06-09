//
//  PaticipantExchangeCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PaticipantTradeCell.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"

@implementation PaticipantTradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_delete.frame = CGRectMake(CGRectGetWidth(self.frame)-19-31, 18, 31, 31);
//        self.btn_delete.userInteractionEnabled = YES;
        [self.btn_delete setBackgroundImage:[UIImage imageNamed:@"img_exchange_delete"] forState:UIControlStateNormal];
        [self.btn_delete setBackgroundImage:[UIImage imageNamed:@"img_exchange_delete_green"] forState:UIControlStateHighlighted];
        [self.btn_delete addTarget:self action:@selector(deletePaticipantCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn_delete];
        
    }
    return self;
}

- (void)contentCellWithPaticipantExchangeEntity:(PaticipantTradeEntity *)entity{
    NSInteger tag = 100000;
    
    for (int j = 100000; j<100010; j++) {
        UIView *v = [self viewWithTag:j];
        if (v) {
            [v removeFromSuperview];
        }else{
            break;
        }
    }
    
    NSInteger sellPieceCount = entity.sell_trade.trade_piece_list.count;
    NSInteger sellPropCount = entity.sell_trade.trade_prop_list.count;
    NSInteger buyPieceCount = entity.buy_trade.trade_piece_list.count;
    NSInteger buyPropCount = entity.buy_trade.trade_prop_list.count;
    int k=0;
    if (sellPieceCount+sellPropCount<=3) {
        for (PieceEntity *pieceEntity in entity.sell_trade.trade_piece_list) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
            k++;
            iv.tag = tag++;
            [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
            [self addSubview:iv];
        }
        for (PropertyEntity *propEntity in entity.sell_trade.trade_prop_list){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
            k++;
            iv.tag = tag++;
            [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
            [self addSubview:iv];
        }
        
        //交换符号
        UIImageView *iv_signal = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 17, 32, 32)];
        k++;
        iv_signal.tag = tag++;
        iv_signal.image = [UIImage imageNamed:@"img_exchange_signal"];
        [self addSubview:iv_signal];
        
        NSInteger leftCount = 6-sellPieceCount-sellPropCount;
        if (buyPieceCount+buyPropCount <= leftCount){
            for (PieceEntity *pieceEntity in entity.buy_trade.trade_piece_list) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
            for (PropertyEntity *propEntity in entity.buy_trade.trade_prop_list){
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
        }else{
            if (buyPieceCount <= leftCount-1) {
                for (int i=0; i<sellPieceCount; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PieceEntity *pieceEntity = [entity.buy_trade.trade_piece_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
                for (int i=0; i<leftCount-1-buyPieceCount; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PropertyEntity *propEntity = [entity.buy_trade.trade_prop_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
            }else{
                for (int i=0; i<leftCount-1; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PieceEntity *pieceEntity = [entity.buy_trade.trade_piece_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
            }
            UIImageView *iv_more = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 29, 32, 8)];
            k++;
            iv_more.tag = tag++;
            iv_more.image = [UIImage imageNamed:@"img_change_moreImage"];
            [self addSubview:iv_more];
        }
    }else{
        if (sellPieceCount < 2) {
            for (int i=0; i<sellPieceCount; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                PieceEntity *pieceEntity = [entity.sell_trade.trade_piece_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
            for (int i=0; i<2-sellPieceCount; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                PropertyEntity *propEntity = [entity.sell_trade.trade_prop_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
        }else{
            for (int i=0; i<2; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                PieceEntity *pieceEntity = [entity.sell_trade.trade_piece_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
        }
        UIImageView *iv_more = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 29, 32, 8)];
        k++;
        iv_more.tag = tag++;
        iv_more.image = [UIImage imageNamed:@"img_change_moreImage"];
        [self addSubview:iv_more];
        //交换符号
        UIImageView *iv_signal = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 17, 32, 32)];
        k++;
        iv_signal.tag = tag++;
        iv_signal.image = [UIImage imageNamed:@"img_exchange_signal"];
        [self addSubview:iv_signal];
        
        NSInteger leftCount = 3;
        if (buyPieceCount+buyPropCount <= leftCount){
            for (PieceEntity *pieceEntity in entity.buy_trade.trade_piece_list) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
            for (PropertyEntity *propEntity in entity.buy_trade.trade_prop_list){
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                k++;
                iv.tag = tag++;
                [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                [self addSubview:iv];
            }
        }else{
            if (buyPieceCount <= leftCount-1) {
                for (int i=0; i<buyPieceCount; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PieceEntity *pieceEntity = [entity.buy_trade.trade_piece_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
                for (int i=0; i<leftCount-1-buyPieceCount; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PropertyEntity *propEntity = [entity.buy_trade.trade_prop_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
            }else{
                for (int i=0; i<leftCount-1; i++) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 14, 32, 39)];
                    k++;
                    iv.tag = tag++;
                    PieceEntity *pieceEntity = [entity.buy_trade.trade_piece_list objectAtIndex:i];
                    [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                    [self addSubview:iv];
                }
            }
            UIImageView *iv_more = [[UIImageView alloc] initWithFrame:CGRectMake(15+k*35, 29, 32, 8)];
            k++;
            iv_more.tag = tag++;
            iv_more.image = [UIImage imageNamed:@"img_change_moreImage"];
            [self addSubview:iv_more];
        }

    }

}


- (void)deletePaticipantCellAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(deletePaticipantCellAction:)]) {
        [self.delegate deletePaticipantCellAction:sender];
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
