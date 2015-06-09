//  创建交换页
//  CreateExchangeView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LargeHModalPanel.h"
#import "GCPlaceholderTextView.h"

@interface CreateExchangeView : LargeHModalPanel

@property (nonatomic, strong) UIScrollView      *scv_bg;
@property (nonatomic, strong) UICollectionView      *cv_myFragments;
@property (nonatomic, strong) UILabel               *lb_description;
@property (nonatomic, strong) UIView                *line;
@property (nonatomic, strong) GCPlaceholderTextView *tv_description;

@property (nonatomic, strong) NSMutableArray            *select_arr;
@property (nonatomic, strong) NSMutableArray            *arr_selectedPropList;
@property (nonatomic, strong) NSMutableArray            *arr_selectedPieceList;

- (void)resizeView;
- (void)leftButtonAction:(id)send;

@end
