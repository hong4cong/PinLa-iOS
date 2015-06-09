//  确认交换列表页面
//  CommitExchangeView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HModalPanel.h"
#import "TradeEntity.h"
#import "HexagonView.h"

@protocol CommitTradeListViewDelegate <NSObject>

- (void)modelView:(UIView *)modelView goBackAction:(id)sender;

@end

@interface CommitTradeListView : HModalPanel

@property (nonatomic, weak) id<CommitTradeListViewDelegate> delegate;

@property (nonatomic, strong) UIButton      *btn_back;
@property (nonatomic, strong) HexagonView   *iv_avatar;
@property (nonatomic, strong) UILabel       *lb_description;

@property (nonatomic, strong) UIScrollView  *scv_bg;

@property (nonatomic, strong) UICollectionView *cv_myFragments;
@property (nonatomic, strong) UIView            *line;

@property (nonatomic, strong) UITableView      *tb_commitList;

- (void)loadDataWithMyTradeEntity:(TradeEntity *)tradeEntity buyList:(NSArray *)buyList;

@end
