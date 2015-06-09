//
//  TradeWithOthersView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LargeHModalPanel.h"
#import "TradeEntity.h"
#import "HexagonView.h"

@interface TradeWithOthersView : LargeHModalPanel

@property (nonatomic, strong) HexagonView   *iv_avatar;
@property (nonatomic, strong) UILabel       *lb_description;

@property (nonatomic, strong) UIScrollView  *scv_bg;

@property (nonatomic, strong) UICollectionView  *cv_aboveFragments;
@property (nonatomic, strong) UIView            *line1;
@property (nonatomic, strong) UIImageView       *iv_trade;
@property (nonatomic, strong) UICollectionView  *cv_myFragments;


@property (nonatomic, strong) NSMutableArray            *select_arr;
@property (nonatomic, strong) NSMutableArray            *arr_selectedPropList;
@property (nonatomic, strong) NSMutableArray            *arr_selectedPieceList;

- (void)resizeView;
- (void)leftButtonAction:(id)send;

- (void)loadDataWithAboveTradeEntity:(TradeEntity *)aboveTradeEntity;


@end
