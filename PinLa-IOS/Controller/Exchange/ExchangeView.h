//
//  ExchangeView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeCell.h"

@protocol ExchangeViewDelegate <NSObject>

- (void)backToMenuAction:(id)sender;
- (void)createExchangeAction:(id)sender;

@end

@interface ExchangeView : UIView

@property (nonatomic, weak)     id<ExchangeViewDelegate> delegate;

@property (nonatomic, strong) UIButton      *btn_backToMenu;
@property (nonatomic, strong) UIImageView   *iv_createExchange;
@property (nonatomic, strong) UITableView   *tb_tradeList;

- (void)updateExchangeState:(ExchangeCellType)type;

@end
