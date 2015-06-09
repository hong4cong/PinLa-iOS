//
//  PaticipantExchangeCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaticipantTradeEntity.h"

@protocol PaticipantTradeCellDelegate <NSObject>

- (void)deletePaticipantCellAction:(id)sender;

@end

@interface PaticipantTradeCell : UITableViewCell

@property (nonatomic, weak)     id<PaticipantTradeCellDelegate> delegate;

@property (nonatomic, strong) UIButton      *btn_delete;

- (void)contentCellWithPaticipantExchangeEntity:(PaticipantTradeEntity *)entity;

@end
