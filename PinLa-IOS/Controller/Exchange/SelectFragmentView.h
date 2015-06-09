//  选择碎片页面
//  SelectTradeView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LargeHModalPanel.h"
#import "SelectFragmentCell.h"
#import "CreateExchangeView.h"

@interface SelectFragmentView : LargeHModalPanel


@property (nonatomic, strong) UITableView   *tb_packageList;

@property (nonatomic, weak) CreateExchangeView        *v_delegate;

@property (nonatomic, strong) NSMutableArray            *select_arr;
@property (nonatomic, strong) NSMutableArray            *arr_propList;
@property (nonatomic, strong) NSMutableArray            *arr_pieceList;


@end
