//
//  BackpackDetailView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "HexagonView.h"
#import "HModalPanel.h"
#import "GCPlaceholderTextView.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"
#import "BackpackViewController.h"
#import "PieceNumberingEntity.h"

@class PieceHexagonView;

@interface BackpackDetailView : HModalPanel

@property (nonatomic,strong) PieceHexagonView           *iv_avatar;
@property (nonatomic,strong) UILabel               *lb_title;
@property (nonatomic,strong) GCPlaceholderTextView *tv_detail;
@property (nonatomic,strong) UIButton              *iv_synthetic;
@property (nonatomic,strong) UIButton              *btn_share;
@property (nonatomic,strong) UIButton              *btn_back;
@property (nonatomic,strong) UIButton              *btn_turn;
@property (nonatomic,strong) UIButton              *useBtn;

@property (nonatomic,strong) PieceEntity           *piece;
@property (nonatomic,strong) PropertyEntity        *property;

@property(nonatomic,assign)BackpackViewController *viewController;

- (void)contentPieceWithEntity:(PieceEntity*)entity isCanSynthesis:(BOOL)isCanSynthesis;
- (void)contentPropertyWithEntity:(PropertyEntity*)entity;
- (void)contentPropertyWithEntity:(PropertyEntity*)entity isShowUseBtn:(BOOL)isShowUseBtn;

- (void)requestPic;

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity;

- (void)setPieceBranchList:(NSArray *)piecesBranchList;

@end
