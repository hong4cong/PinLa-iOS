//
//  CommitExchangeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CommitTradeListView.h"
#import "SelectedFragmentCell.h"
#import "CommitTradeCell.h"
#import "TradeEntity.h"
#import "CommitTradeView.h"
#import "UserStorage.h"
#import "PieceHandler.h"
#import "PieceNumberingEntity.h"
#import "PieceDetailModalPanelView.h"
#import "PropertyDetailModalPanelView.h"

@interface CommitTradeListView()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CommitTradeViewDelegate,CommitTradeCellDelegate>

@property (nonatomic, strong) CommitTradeView       *v_commitTrade;
@property (nonatomic, strong) TradeEntity           *tradeEntity;
@property (nonatomic, strong) NSMutableArray        *arr_buyList;


@end

@implementation CommitTradeListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentViewFrame = self.bounds;
        
        self.arr_buyList = [NSMutableArray array];
        
        self.btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentViewFrame) - 42, 0, 40, 40)];
        [self.btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_back];
        
        self.iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake(20, 14, 50, 50) image:[UIImage imageNamed:@"img_common_defaultAvatar"]];
        [self.contentView addSubview: self.iv_avatar];
        
        self.lb_description = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iv_avatar.frame)+13, 14, CGRectGetWidth(self.frame)-45-CGRectGetMaxX(self.iv_avatar.frame)-13, 60)];
        self.lb_description.textColor = [UIColor whiteColor];
        self.lb_description.font = [UIFont systemFontOfSize:FONT_SIZE-1];
        self.lb_description.numberOfLines = 0;
        self.lb_description.text = @"";
        [self.contentView addSubview:self.lb_description];
        
        [AppUtils addLineOnView:self.contentView WithFrame:CGRectMake(0, CGRectGetMaxY(self.iv_avatar.frame)+14, CGRectGetWidth(self.frame), 1)];
        
        self.scv_bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iv_avatar.frame)+14+5, CGRectGetWidth(contentViewFrame), CGRectGetHeight(contentViewFrame)-CGRectGetMaxY(_iv_avatar.frame)-14-5)];
        self.scv_bg.contentSize = self.scv_bg.frame.size;
        [self.contentView addSubview:self.scv_bg];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(49,60);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _cv_myFragments = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-240)/2, 10, 240, 60) collectionViewLayout:flowLayout];
        _cv_myFragments.delegate = self;
        _cv_myFragments.dataSource = self;
        _cv_myFragments.bounces = NO;
        _cv_myFragments.backgroundColor = [UIColor clearColor];
        _cv_myFragments.contentSize = _cv_myFragments.frame.size;
        [_cv_myFragments registerClass:[SelectedFragmentCell class] forCellWithReuseIdentifier:@"SelectedFragmentCell"];
        [self.scv_bg addSubview:_cv_myFragments];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cv_myFragments.frame)+5, CGRectGetWidth(contentViewFrame), 1)];
        _line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.scv_bg addSubview:_line];
        
        
        self.tb_commitList = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_line.frame), CGRectGetWidth(self.frame), CGRectGetHeight(_scv_bg.frame)-CGRectGetMaxY(_line.frame)) style:UITableViewStylePlain];
        self.tb_commitList.delegate = self;
        self.tb_commitList.dataSource = self;
        self.tb_commitList.allowsSelection = NO;
        self.tb_commitList.bounces = NO;
        self.tb_commitList.backgroundColor = [UIColor clearColor];
        self.tb_commitList.separatorInset = UIEdgeInsetsZero;
        self.tb_commitList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
        self.tb_commitList.tableFooterView = [UIView new];
        [self.scv_bg addSubview:self.tb_commitList];
        
    }
    return self;
}

- (void)loadDataWithMyTradeEntity:(TradeEntity *)tradeEntity buyList:(NSArray *)buyList{
    self.tradeEntity = tradeEntity;
    [self.arr_buyList addObjectsFromArray:buyList];
    [self.cv_myFragments reloadData];
    [self.tb_commitList reloadData];
    
    self.lb_description.text = self.tradeEntity.trade_detail;
    
    [AppUtils contentImageView:self.iv_avatar withURLString:[UserStorage userIcon] andPlaceHolder:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    
    self.cv_myFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, 10, 240, ((tradeEntity.trade_piece_list.count+tradeEntity.trade_prop_list.count-1)/4+1)*60);
    _line.frame = CGRectMake(0, CGRectGetMaxY(_cv_myFragments.frame)+5, CGRectGetWidth(self.frame), 1);
    _tb_commitList.frame = CGRectMake(0, CGRectGetMaxY(_line.frame), CGRectGetWidth(self.frame), buyList.count*67);
    _scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(_tb_commitList.frame));
}

- (void)modelView:(UIView *)modelView goBackAction:(id)sender{
    [self goBack:sender];
}

- (void)goBack:(id)sender{
    if ([self.delegate respondsToSelector:@selector(modelView:goBackAction:)]) {
        [self.delegate modelView:self goBackAction:sender];
    }
    [self hide];
}

#pragma -mark CommitTradeCellDelegate
- (void)commitExchangeAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    TradeEntity *buyEntity = [self.arr_buyList objectAtIndex:button.tag];
    //TODO(SEAN):带入数据
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self addSubview:bg];
    _v_commitTrade = [[CommitTradeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bg.frame), CGRectGetHeight(bg.frame))];
    _v_commitTrade.tradeViewType = TradeViewTypeConfirm;
    [_v_commitTrade.btn_comfirm setTitle:@"确认交易" forState:UIControlStateNormal];
    _v_commitTrade.delegate = self;
    [bg addSubview:_v_commitTrade];
    [_v_commitTrade loadDataWithAboveTradeEntity:self.tradeEntity underTradeEntity:buyEntity];
    [_v_commitTrade showFromPoint:[self center]];
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_buyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CommitTradeCell";
    CommitTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CommitTradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.btn_commit.tag = indexPath.row;
    TradeEntity *tradeEntity = [self.arr_buyList objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell contentCellWithCommitTradeEntity:tradeEntity];
    return cell;
}


#pragma -mark UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tradeEntity.trade_prop_list.count+self.tradeEntity.trade_piece_list.count;
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
    if (indexPath.row < self.tradeEntity.trade_piece_list.count){
        PieceEntity *pieceEntity = [self.tradeEntity.trade_piece_list objectAtIndex:indexPath.row];
        [cell contentCellWithPieceEntity:pieceEntity];
    }else{
        PropertyEntity *propEntitiy = [self.tradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.tradeEntity.trade_piece_list.count];
        [cell contentCellWithPropertyEntity:propEntitiy];
    }
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.tradeEntity.trade_piece_list.count){
        PieceEntity *pieceEntity = [self.tradeEntity.trade_piece_list objectAtIndex:indexPath.row];
        
        [self requestPieceDetail:pieceEntity.prop_father_id piece_branch:pieceEntity.piece_branch];
    }else{
        PropertyEntity *propEntitiy = [self.tradeEntity.trade_prop_list objectAtIndex:indexPath.row-self.tradeEntity.trade_piece_list.count];
        
        [self showPropertyPanel:propEntitiy];
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
