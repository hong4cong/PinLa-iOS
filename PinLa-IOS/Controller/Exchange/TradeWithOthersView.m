//
//  TradeWithOthersView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "TradeWithOthersView.h"
#import "SelectedFragmentCell.h"
#import "SelectFragmentView.h"
#import "UserStorage.h"
#import "TradeHandler.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"
#import "PieceNumberingEntity.h"
#import "PieceHandler.h"
#import "PieceDetailModalPanelView.h"
#import "PropertyDetailModalPanelView.h"

@interface TradeWithOthersView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) TradeEntity        *aboveTradeEntity;
@property (nonatomic, strong) SelectFragmentView        *v_selectFragment;
@property (nonatomic, strong) PieceDetailModalPanelView *bgModalPanelView;

@end

@implementation TradeWithOthersView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles{
    self = [super initWithFrame:frame title:title buttonTitles:buttonTitles];
    if (self) {
        
        self.arr_selectedPieceList = [NSMutableArray array];
        self.arr_selectedPropList = [NSMutableArray array];
        self.select_arr = [NSMutableArray array];

        CGRect contentViewFrame = self.bounds;
        
//        self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame) - 42, 0, 40, 40)];
//        [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.btn_back];
//        

        self.iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake(20, 14, 50, 50) image:[UIImage imageNamed:@"img_common_defaultAvatar"]];
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
        
        _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cv_aboveFragments.frame)+35, CGRectGetWidth(contentViewFrame), 1)];
        _line1.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.scv_bg addSubview:_line1];
        
        _iv_trade = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentViewFrame)-50)/2, CGRectGetMaxY(_line1.frame)-20, 50, 39)];
        _iv_trade.image = [UIImage imageNamed:@"img_exchange_exchange"];
        [self.scv_bg addSubview:_iv_trade];
        
        UICollectionViewFlowLayout *flowLayout2=[[UICollectionViewFlowLayout alloc] init];
        flowLayout2.itemSize=CGSizeMake(60,49);
        flowLayout2.minimumInteritemSpacing = 0;
        flowLayout2.minimumLineSpacing = 10;
        [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.cv_myFragments = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentViewFrame)-240)/2, CGRectGetMaxY(_line1.frame)+35, 240, 59) collectionViewLayout:flowLayout2];
        self.cv_myFragments.contentSize = self.cv_myFragments.frame.size;
        self.cv_myFragments.delegate = self;
        self.cv_myFragments.dataSource = self;
        self.cv_myFragments.bounces = NO;
        [self.cv_myFragments setBackgroundColor:[UIColor clearColor]];
        [self.cv_myFragments registerClass:[SelectedFragmentCell class] forCellWithReuseIdentifier:@"SelectedFragmentCell"];
        [self.scv_bg addSubview:self.cv_myFragments];
    }
    return self;
}

- (void)leftButtonAction:(id)send{
    NSMutableArray *arr_pieceId = [NSMutableArray array];
    NSMutableArray *arr_propId = [NSMutableArray array];
    for (PieceEntity *pieceEntity in self.arr_selectedPieceList) {
        if (pieceEntity.piece_id) {
            [arr_pieceId addObject:[NSDictionary dictionaryWithObjectsAndKeys:pieceEntity.piece_id,@"piece_id", nil]];
        }
    }
    for (PropertyEntity *propEntity in self.arr_selectedPropList) {
        if (propEntity.prop_id) {
            [arr_propId addObject:[NSDictionary dictionaryWithObjectsAndKeys:propEntity.prop_id,@"prop_id", nil]];
        }
    }
    
    [TradeHandler tradeBuyWithUserId:[UserStorage userId] tradeId:self.aboveTradeEntity.trade_id pieceList:arr_pieceId propList:arr_propId msg:@"" prepare:^{
        [SVProgressHUD show];
    } success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"参与交易成功"];
        [self hide];
    } failed:^(NSInteger statusCode, id json) {
        [SVProgressHUD showErrorWithStatus:@"参与交易失败"];
    }];

}

- (void)rightButtonAction:(id)send{
    [self hide];
}

- (void)resizeView{
    self.cv_aboveFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, 5, 240, ((self.aboveTradeEntity.trade_piece_list.count+self.aboveTradeEntity.trade_prop_list.count-1)/4+1)*60);
    _line1.frame = CGRectMake(0, CGRectGetMaxY(self.cv_aboveFragments.frame)+35, CGRectGetWidth(self.frame), 1);
    _iv_trade.frame = CGRectMake((CGRectGetWidth(self.frame)-50)/2, CGRectGetMaxY(_line1.frame)-20, 50, 39);
    self.cv_myFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, CGRectGetMaxY(_line1.frame)+35, 240, ((self.arr_selectedPieceList.count+self.arr_selectedPropList.count)/4+1)*60);
    _scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.cv_myFragments.frame));
}


- (void)loadDataWithAboveTradeEntity:(TradeEntity *)aboveTradeEntity {
    
    [AppUtils contentImageView:self.iv_avatar withURLString:aboveTradeEntity.user_icon andPlaceHolder:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    self.aboveTradeEntity = aboveTradeEntity;
    self.lb_description.text = aboveTradeEntity.trade_detail;
    
    [self.cv_aboveFragments reloadData];
    [self resizeView];

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
    }else if (collectionView == _cv_myFragments){
        return self.arr_selectedPropList.count+self.arr_selectedPieceList.count+1;
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
    }else if (collectionView == _cv_myFragments){
        if (indexPath.row == self.arr_selectedPropList.count+self.arr_selectedPieceList.count) {
            cell.iv_fragment.image = [UIImage imageNamed:@"img_exchange_addFragment"];
        }else if (indexPath.row < self.arr_selectedPieceList.count){
            PieceEntity *pieceEntity = [self.arr_selectedPieceList objectAtIndex:indexPath.row];
            [cell contentCellWithPieceEntity:pieceEntity];
        }else{
            PropertyEntity *propEntitiy = [self.arr_selectedPropList objectAtIndex:indexPath.row-self.arr_selectedPieceList.count];
            [cell contentCellWithPropertyEntity:propEntitiy];
            
        }
    }
    
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.cv_myFragments) {
        UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self addSubview:bg];
        
        self.v_selectFragment = [[SelectFragmentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) title:@"选择碎片" buttonTitles:@[@"确认选择",@"取消"]];
        self.v_selectFragment.v_delegate = self;
        [self.v_selectFragment.select_arr removeAllObjects];
        [self.v_selectFragment.select_arr addObjectsFromArray:self.select_arr];
        [bg addSubview:_v_selectFragment];
        [_v_selectFragment showFromPoint:[self center]];
    }else{
        if (indexPath.row < self.aboveTradeEntity.trade_piece_list.count){
            PieceEntity *pieceEntity = [self.aboveTradeEntity.trade_piece_list objectAtIndex:indexPath.row];
            
            [self requestPieceDetail:pieceEntity.prop_father_id piece_branch:pieceEntity.piece_branch];
        }else{
            PropertyEntity *propEntitiy = [self.aboveTradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.aboveTradeEntity.trade_piece_list.count];
            
            [self showPropertyPanel:propEntitiy];
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (collectionView == self.cv_myFragments) {
//        return YES;
//    }
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
    self.bgModalPanelView = [[PieceDetailModalPanelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.superview addSubview:_bgModalPanelView];
//    [self addSubview:_bgModalPanelView];
    
    [self.bgModalPanelView contentWithPieceNumberingEntity:data];
}

- (void)showPropertyPanel:(PropertyEntity *)propEntitiy
{
    PropertyDetailModalPanelView* propertyDetailModalPanelView = [[PropertyDetailModalPanelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [propertyDetailModalPanelView contentWithPropertyEntity:propEntitiy];
    [self.superview addSubview:propertyDetailModalPanelView];
}

@end
