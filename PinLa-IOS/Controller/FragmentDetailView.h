//
//  FragmentDetailView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "HModalPanel.h"

@class PieceNumberingEntity;

@interface FragmentDetailView : HModalPanel<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView    *tb_detailList;
@property (nonatomic,strong) NSMutableArray *arr_details;
@property (nonatomic,strong) UIButton       *btn_turn;

@property (nonatomic,strong) PieceNumberingEntity *pieceNumberingEntity;

- (void)setDetails:(NSMutableArray *)arr;

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity;

@end
