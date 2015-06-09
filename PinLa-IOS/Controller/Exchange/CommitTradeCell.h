//
//  CommitExchangeCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeEntity.h"

@protocol CommitTradeCellDelegate <NSObject>

- (void)commitExchangeAction:(id)sender;

@end

@interface CommitTradeCell : UITableViewCell

@property (nonatomic, assign) id<CommitTradeCellDelegate> delegate;

@property (nonatomic, strong) HexagonView       *iv_avatar;
@property (nonatomic, strong) UIButton          *btn_commit;

- (void)contentCellWithCommitTradeEntity:(TradeEntity *)tradeEntity;

@end
