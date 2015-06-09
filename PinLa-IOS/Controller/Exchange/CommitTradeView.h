//
//  CommitTradeView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/7.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LargeHModalPanel.h"
#import "TradeEntity.h"
#import "PropertyEntity.h"
#import "PieceEntity.h"
#import "PaticipantTradeEntity.h"
#import "HexagonView.h"

typedef NS_ENUM(NSUInteger, TradeViewType) {
    TradeViewTypeConfirm,
    TradeViewTypeCancel,
};


@protocol CommitTradeViewDelegate <NSObject>

- (void)modelView:(UIView *)modelView goBackAction:(id)sender;

@end


@interface CommitTradeView : HModalPanel

@property (nonatomic, weak) id<CommitTradeViewDelegate> delegate;

@property (nonatomic        ) TradeViewType tradeViewType;

@property (nonatomic, strong) UIButton      *btn_back;
@property (nonatomic, strong) HexagonView   *iv_avatar;
@property (nonatomic, strong) UILabel       *lb_description;

@property (nonatomic, strong) UIScrollView  *scv_bg;

@property (nonatomic, strong) UICollectionView  *cv_aboveFragments;
@property (nonatomic, strong) UIView            *line;
@property (nonatomic, strong) UIImageView       *iv_trade;
@property (nonatomic, strong) UICollectionView  *cv_underFragments;

@property (nonatomic, strong) UIButton      *btn_comfirm;

- (void)loadDataWithPaticipantTradeEntity:(PaticipantTradeEntity *)paticipantTradeEntity;

- (void)loadDataWithAboveTradeEntity:(TradeEntity *)aboveTradeEntity underTradeEntity:(TradeEntity *)underTradeEntity;

@end
