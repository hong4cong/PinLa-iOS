//
//  CommitExchangeCell.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CommitTradeCell.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"
#import <UIImageView+WebCache.h>

@implementation CommitTradeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake(22, 12, 40, 40)];
        self.iv_avatar.image = [UIImage imageNamed:@"img_common_defaultAvatar"];
        [self addSubview:self.iv_avatar];
        
        self.btn_commit = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_commit.frame = CGRectMake(CGRectGetWidth(self.frame)-13-42-8, 12, 42, 42);
        [self.btn_commit setImage:[UIImage imageNamed:@"img_unselected"] forState:UIControlStateNormal];
        [self.btn_commit addTarget:self action:@selector(commitExchangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn_commit];
        
        
    }
    return self;
}

- (void)contentCellWithCommitTradeEntity:(TradeEntity *)tradeEntity{
    NSInteger tag = 100000;
    
    for (int j = 100000; j<100005; j++) {
        UIView *v = [self viewWithTag:j];
        if (v) {
            [v removeFromSuperview];
        }else{
            break;
        }
    }

    [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:tradeEntity.user_icon] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];

    if (tradeEntity.trade_piece_list.count+tradeEntity.trade_prop_list.count<=4) {
        int i = 0;
        for (PieceEntity *pieceEntity in tradeEntity.trade_piece_list) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+i*35, CGRectGetMinY(self.iv_avatar.frame)+3, 32, 32)];
            [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
            i++;
            iv.tag = tag++;
            iv.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:iv];
        }
        for (PropertyEntity *propEntity in tradeEntity.trade_prop_list) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+i*35, CGRectGetMinY(self.iv_avatar.frame)+3, 32, 32)];
            [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
            i++;
            iv.tag = tag++;
            iv.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:iv];
        }
    }else{
        if (tradeEntity.trade_piece_list.count<=3) {
            for (int i=0;i<tradeEntity.trade_piece_list.count;i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+i*35, CGRectGetMinY(self.iv_avatar.frame)+3, 32, 32)];
                PieceEntity *pieceEntity = [tradeEntity.trade_piece_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                
                iv.tag = tag++;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:iv];
            }
            for (int i=0;i<3-tradeEntity.trade_piece_list.count;i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+i*35, CGRectGetMinY(self.iv_avatar.frame)+3, 32, 32)];
                PropertyEntity *propEntity = [tradeEntity.trade_prop_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:propEntity.prop_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                iv.tag = tag++;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:iv];
            }
        }else{
            for (int i=0;i<3;i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+i*35, CGRectGetMinY(self.iv_avatar.frame)+3, 32, 32)];
                PieceEntity *pieceEntity = [tradeEntity.trade_piece_list objectAtIndex:i];
                [AppUtils contentImageView:iv withURLString:pieceEntity.piece_icon andPlaceHolder:[UIImage imageNamed:@"img_prop_def"]];
                iv.tag = tag++;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:iv];
            }
        }
        UIImageView *iv_moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+18+3*(32+3)+7, 31, 24, 8)];
        iv_moreImage.tag = tag++;
        iv_moreImage.image = [UIImage imageNamed:@"img_change_moreImage"];
        [self addSubview:iv_moreImage];
    }
}

- (void)commitExchangeAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(commitExchangeAction:)]) {
        [self.delegate commitExchangeAction:sender];
    }
}


@end
