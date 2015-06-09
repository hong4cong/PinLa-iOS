//
//  ExchangeCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/19.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeEntity.h"

typedef NS_ENUM(NSUInteger, ExchangeCellType) {
    ExchangeCellType_init,
    ExchangeCellType_join,
};

@protocol ExchangeCellDelegate <NSObject>

- (void)moveCellToTrashAction:(id)sender;

@end

@interface TradeCell : UITableViewCell

@property (nonatomic, assign)   id<ExchangeCellDelegate>  delegate;

@property (nonatomic, strong) UILabel       *lb_description;
@property (nonatomic, strong) UIButton      *btn_trash;

- (void)contentCellWithExchangeEntity:(TradeEntity *)tradeEntity noti:(BOOL)isNoti;

@end
