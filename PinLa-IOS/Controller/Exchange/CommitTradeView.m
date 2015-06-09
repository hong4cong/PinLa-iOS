//  确认交换确认页
//  CommitTradeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/7.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CommitTradeView.h"
#import "SelectedFragmentCell.h"
#import "TradeHandler.h"
#import "UserStorage.h"
#import "PieceHandler.h"
#import "PieceNumberingEntity.h"
#import "PieceDetailModalPanelView.h"
#import "PropertyDetailModalPanelView.h"
#import <UIImageView+WebCache.h>
#import "PieceDetailModalPanelView.h"
#import "PropertyDetailModalPanelView.h"
#import "PieceHandler.h"

@interface CommitTradeView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) PaticipantTradeEntity *paticipantEntity;
@property (nonatomic, strong) TradeEntity        *aboveTradeEntity;
@property (nonatomic, strong) TradeEntity       *underTradeEntity;

@end

@implementation CommitTradeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentViewFrame = self.bounds;
        
        self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame) - 42, 12, 40, 40)];
        [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_back];

        self.iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];
        [self.iv_avatar sd_setImageWithURL:[NSURL URLWithString:[UserStorage userIcon]] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
        [self.contentView addSubview: self.iv_avatar];
        
        self.lb_description = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+13, 14, CGRectGetWidth(self.frame)-45-CGRectGetMaxX(self.iv_avatar.frame)-13, 60)];
        self.lb_description.textColor = [UIColor whiteColor];
        self.lb_description.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        self.lb_description.numberOfLines = 0;
        self.lb_description.text = @"";
        [self.contentView addSubview:self.lb_description];
        
        
        self.scv_bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+10, CGRectGetWidth(contentViewFrame), CGRectGetHeight(contentViewFrame)-CGRectGetMaxY(_iv_avatar.frame)-10-57)];
        self.scv_bg.contentSize = self.scv_bg.frame.size;
        [self.contentView addSubview:self.scv_bg];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(60,49);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.cv_aboveFragments = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentViewFrame)-240)/2, 5, 240, 59) collectionViewLayout:flowLayout];
        self.cv_aboveFragments.delegate = self;
        self.cv_aboveFragments.dataSource =self;
        self.cv_aboveFragments.bounces = NO;
        self.cv_aboveFragments.backgroundColor = [UIColor clearColor];
        self.cv_aboveFragments.contentSize = self.cv_aboveFragments.frame.size;
        [self.cv_aboveFragments registerClass:[SelectedFragmentCell class] forCellWithReuseIdentifier:@"SelectedFragmentCell"];
        [self.scv_bg addSubview:self.cv_aboveFragments];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cv_aboveFragments.frame)+35, CGRectGetWidth(contentViewFrame), 1)];
        _line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.scv_bg addSubview:_line];
        
        _iv_trade = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentViewFrame)-50)/2, CGRectGetMaxY(_line.frame)-20, 50, 39)];
        _iv_trade.image = [UIImage imageNamed:@"img_exchange_exchange"];
        [self.scv_bg addSubview:_iv_trade];
        
        UICollectionViewFlowLayout *flowLayout2=[[UICollectionViewFlowLayout alloc] init];
        flowLayout2.itemSize=CGSizeMake(60,49);
        flowLayout2.minimumInteritemSpacing = 0;
        flowLayout2.minimumLineSpacing = 10;
        [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.cv_underFragments = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentViewFrame)-240)/2, CGRectGetMaxY(_line.frame)+35, 240, 59) collectionViewLayout:flowLayout2];
        self.cv_underFragments.contentSize = self.cv_underFragments.frame.size;
        self.cv_underFragments.delegate = self;
        self.cv_underFragments.dataSource = self;
        self.cv_underFragments.bounces = NO;
        [self.cv_underFragments setBackgroundColor:[UIColor clearColor]];
        [self.cv_underFragments registerClass:[SelectedFragmentCell class] forCellWithReuseIdentifier:@"SelectedFragmentCell"];
        [self.scv_bg addSubview:self.cv_underFragments];
        
        self.btn_comfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_comfirm.frame = CGRectMake(0, CGRectGetHeight(contentViewFrame)-57, CGRectGetWidth(contentViewFrame), 57);
        self.btn_comfirm.layer.borderColor = [[UIColor grayColor] CGColor];
        self.btn_comfirm.layer.borderWidth = 1.0f;
        [self.btn_comfirm setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
        [self.btn_comfirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_comfirm];
    }
    return self;
}

- (void)loadDataWithPaticipantTradeEntity:(PaticipantTradeEntity *)paticipantTradeEntity{
    [AppUtils contentImageView:self.iv_avatar withURLString:paticipantTradeEntity.sell_trade.user_icon andPlaceHolder:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    self.paticipantEntity = paticipantTradeEntity;
    [self loadDataWithAboveTradeEntity:paticipantTradeEntity.sell_trade underTradeEntity:paticipantTradeEntity.buy_trade];
    self.lb_description.text = paticipantTradeEntity.sell_trade.trade_detail;
}

- (void)loadDataWithAboveTradeEntity:(TradeEntity *)aboveTradeEntity underTradeEntity:(TradeEntity *)underTradeEntity{
    
    self.aboveTradeEntity = aboveTradeEntity;
    self.underTradeEntity = underTradeEntity;
    self.lb_description.text = aboveTradeEntity.trade_detail;

    [self.cv_aboveFragments reloadData];
    [self.cv_underFragments reloadData];
    
    self.cv_aboveFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, 5, 240, ((aboveTradeEntity.trade_piece_list.count+aboveTradeEntity.trade_prop_list.count-1)/4+1)*60);
    _line.frame = CGRectMake(0, CGRectGetMaxY(self.cv_aboveFragments.frame)+35, CGRectGetWidth(self.frame), 1);
    _iv_trade.frame = CGRectMake((CGRectGetWidth(self.frame)-50)/2, CGRectGetMaxY(_line.frame)-20, 50, 39);
    self.cv_underFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, CGRectGetMaxY(_line.frame)+35, 240, ((underTradeEntity.trade_piece_list.count+underTradeEntity.trade_prop_list.count-1)/4+1)*60);
    _scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.cv_underFragments.frame));
}

- (void)confirmAction:(id)sender{
    switch (self.tradeViewType) {
        case TradeViewTypeConfirm:
        {
            [TradeHandler confirmTradeWithUserId:[UserStorage userId] tradeChildId:self.underTradeEntity.trade_child_id prepare:^{
                [SVProgressHUD show];
            } success:^(id obj) {
                [self hide];
                [self goBack:nil];
                [SVProgressHUD showSuccessWithStatus:@"确认交换成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TRADE_CONFIRM_SUCCESS object:nil];
            } failed:^(NSInteger statusCode, id json) {
                [SVProgressHUD showErrorWithStatus:@"确认交换失败"];
            }];

        }
            break;
        case TradeViewTypeCancel:
        {
            [TradeHandler cancelTradeBuyWithUserId:[UserStorage userId] tradeChildId:self.paticipantEntity.trade_child_id prepare:^{
                [SVProgressHUD show];
            } success:^(id obj) {
                [self goBack:nil];
                [SVProgressHUD showSuccessWithStatus:@"取消交换成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TRADE_CANCEL_SUCCESS object:nil];
            } failed:^(NSInteger statusCode, id json) {
                [SVProgressHUD showErrorWithStatus:@"取消交换失败"];
            }];

        }
            break;
        default:
            break;
    }

}

- (void)goBack:(id)sender{
    if ([self.delegate respondsToSelector:@selector(modelView:goBackAction:)]) {
        [self.delegate modelView:self goBackAction:sender];
    }
    [self hide];
}


#pragma -mark UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _cv_aboveFragments){
        return self.aboveTradeEntity.trade_prop_list.count+self.aboveTradeEntity.trade_piece_list.count;
    }else if (collectionView == _cv_underFragments){
        return self.underTradeEntity.trade_piece_list.count+self.underTradeEntity.trade_prop_list.count;
    }
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SelectedFragmentCell";
    SelectedFragmentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (collectionView == _cv_aboveFragments){
        if (indexPath.row < self.aboveTradeEntity.trade_piece_list.count){
            PieceEntity *pieceEntity = [self.aboveTradeEntity.trade_piece_list objectAtIndex:indexPath.row];
            [cell contentCellWithPieceEntity:pieceEntity];
        }else{
            PropertyEntity *propEntitiy = [self.aboveTradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.aboveTradeEntity.trade_piece_list.count];
            [cell contentCellWithPropertyEntity:propEntitiy];
            
        }
    }else if (collectionView == _cv_underFragments){
        if (indexPath.row < self.underTradeEntity.trade_piece_list.count){
            PieceEntity *pieceEntity = [self.underTradeEntity.trade_piece_list objectAtIndex:indexPath.row];
            [cell contentCellWithPieceEntity:pieceEntity];
        }else{
            PropertyEntity *propEntitiy = [self.underTradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.underTradeEntity.trade_piece_list.count];
            [cell contentCellWithPropertyEntity:propEntitiy];
            
        }
    }
    
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _cv_aboveFragments){
        if (indexPath.row < self.aboveTradeEntity.trade_piece_list.count){
            PieceEntity *pieceEntity = [self.aboveTradeEntity.trade_piece_list objectAtIndex:indexPath.row];
            [self requestPieceDetail:pieceEntity.prop_father_id piece_branch:pieceEntity.piece_branch];
        }else{
            PropertyEntity *propEntitiy = [self.aboveTradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.aboveTradeEntity.trade_piece_list.count];
            [self showPropertyPanel:propEntitiy];
            
        }
    }else if (collectionView == _cv_underFragments){
        if (indexPath.row < self.underTradeEntity.trade_piece_list.count){
            PieceEntity *pieceEntity = [self.underTradeEntity.trade_piece_list objectAtIndex:indexPath.row];
            [self requestPieceDetail:pieceEntity.prop_father_id piece_branch:pieceEntity.piece_branch];
        }else{
            PropertyEntity *propEntitiy = [self.underTradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.underTradeEntity.trade_piece_list.count];
            [self showPropertyPanel:propEntitiy];
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)requestPieceDetail:(NSString*)propFatherId piece_branch:(NSString*)piece_branch{
    [PieceHandler getPieceDetailWithUserId:[UserStorage userId] propFatherId:propFatherId prepare:^{
        [SVProgressHUD showWithStatus:@"正在加载"];
    } success:^(PieceNumberingEntity* obj) {
        [SVProgressHUD dismiss];
        obj.piece_branch = piece_branch;
        [self showPiecePanel:obj];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)showPiecePanel:(PieceNumberingEntity*)data
{
    PieceDetailModalPanelView *bgModalPanelView = [[PieceDetailModalPanelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.superview addSubview:bgModalPanelView];
    //    [self addSubview:_bgModalPanelView];
    
    [bgModalPanelView contentWithPieceNumberingEntity:data];
}

- (void)showPropertyPanel:(PropertyEntity *)propEntitiy
{
    PropertyDetailModalPanelView* propertyDetailModalPanelView = [[PropertyDetailModalPanelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [propertyDetailModalPanelView contentWithPropertyEntity:propEntitiy];
    [self.superview addSubview:propertyDetailModalPanelView];
}


@end
