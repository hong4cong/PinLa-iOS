//
//  BackpackViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BackpackViewController.h"
#import "BackpackCell.h"
#import "IndicatorView.h"
#import "REMenu.h"
#import "TitleBgView.h"
#import "BackpackDetailView.h"
#import "AppDelegate.h"
#import "FragmentDetailView.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import "BackpackEntity.h"
#import "PieceEntity.h"
#import "PropertyEntity.h"
#import "CardEntity.h"
#import "CardCell.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "CardCell.h"
#import "LTBounceSheet.h"
#import "PieceHandler.h"
#import "WebViewController.h"

@interface BackpackViewController ()<UITableViewDataSource,UITableViewDelegate,HModalPanelDelegate>{
    bool displayingPrimary;
}

@property (nonatomic,strong) UITableView        *tb_backpack;
@property (nonatomic,strong) NSMutableArray     *arr_backpack;
@property (nonatomic,strong) REMenu             *menu;
@property (nonatomic,strong) BackpackDetailView *detailView;
@property (nonatomic,strong) FragmentDetailView *fragmentDetail;
@property (nonatomic,strong) UIBarButtonItem    *btn_right;
@property (nonatomic,assign) BackpackType        type;
@property (nonatomic,strong) TitleBgView        *titleBgView;
@property (nonatomic,strong) NSMutableDictionary *pieceGroupDic;
@property (nonatomic,strong) NSMutableDictionary *propGroupDic;
@property (nonatomic,strong) NSMutableArray      *arr_propData;
@property (nonatomic,strong) NSMutableArray      *cardList;
@property (nonatomic,strong) NSMutableArray *pieceGroupKeyArr;
@property (nonatomic,strong) NSMutableArray *propGroupKeyArr;

@property (nonatomic, strong) LTBounceSheet  *sheet;
@property (nonatomic, strong) UIButton       *btn_minus;
@property (nonatomic, strong) UIButton       *btn_plus;
@property (nonatomic, strong) UIButton       *btn_quickminus;
@property (nonatomic, strong) UIButton       *btn_quickplus;
@property (nonatomic, strong) UILabel        *lb_selectednum;
@property (nonatomic, assign) int            selectedNum;
@property (nonatomic, assign) int            maxSelectNum;
@property (nonatomic, assign) BOOL           hasLock;
@property (nonatomic, strong) NSIndexPath    *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *arr_selectedPropId;
@property (nonatomic, strong) UIView         *bgModalPanelView;
@property (nonatomic, strong) BackpackEntity* backpack;

@end

@implementation BackpackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.cardList = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBackpack) name:NOTI_BACKPACK_RELOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syntheticSuccess:) name:NOTI_SYNTHETIC_SUCCESS object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
    [super viewWillAppear:animated];
}

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}

- (void)initRightBarView
{
    self.btn_right = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.btn_right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_MAIN]} forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:self.btn_right animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_menu.isOpen){
        [_menu removeView];
    }
}

- (void)leftBarAction:(id)sender
{
    
}

- (void)rightBarAction:(id)sender{
//    UIBarButtonItem *btn_right = (UIBarButtonItem *)sender;
//    [btn_right setTitle:@"20/20"];
}

- (void)onCreate{
    self.title = @"背包";
    displayingPrimary = YES;
    self.arr_backpack = [NSMutableArray array];
    self.pieceGroupDic = [NSMutableDictionary dictionary];
    self.propGroupDic = [NSMutableDictionary dictionary];
    
    self.pieceGroupKeyArr = [NSMutableArray array];
    self.propGroupKeyArr = [NSMutableArray array];
    
    self.titleBgView = [[TitleBgView alloc]initWithFrame:CGRectZero title:@"碎片"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleInvoked:)];
    _titleBgView.userInteractionEnabled = YES;
    [_titleBgView addGestureRecognizer:gesture];
    self.navigationItem.titleView = _titleBgView;
    [self initRightBarView];
    
    self.tb_backpack = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.tb_backpack setDelegate:self];
    [self.tb_backpack setDataSource:self];
    _tb_backpack.backgroundColor = [UIColor blackColor];
    _tb_backpack.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    self.tb_backpack.tableFooterView = [UIView new];
    [self.view addSubview:self.tb_backpack];
    
    self.detailView = [[BackpackDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.detailView.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.detailView.margin = UIEdgeInsetsMake(84, 20, 20, 20);
    self.detailView.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    self.fragmentDetail = [[FragmentDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.fragmentDetail.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.fragmentDetail.margin = UIEdgeInsetsMake(84, 20, 20, 20);
    self.fragmentDetail.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.fragmentDetail setHidden:YES];
    [self.view addSubview:self.fragmentDetail];
    
    [self requestBackpack];
    
    self.arr_propData = [NSMutableArray array];
    //初始化actionsheet
    self.selectedNum = 1;
    self.arr_selectedPropId = [NSMutableArray array];
    [self setupActionSheet];
    
}


- (void)syntheticSuccess:(NSNotification *)noti{
    self.titleBgView.lb_noti.hidden = NO;
}

- (void)actionSheetHidden:(UITapGestureRecognizer *)tap{
    [self.sheet hide];
}

- (void)setupActionSheet{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:1000 bgColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    UIView *selectFragmentView = [self viewForSelectFragmentWithFrame:CGRectMake(7, 1000-163, 306, 74)];
    [self.sheet addView:selectFragmentView];
    
    UIButton * confirm = [self produceButtonWithTitle:@"确定"];
    [confirm setBackgroundImage:[UIImage imageNamed:@"img_sheet_top"] forState:UIControlStateNormal];
    confirm.tag = 10001;
    confirm.frame=CGRectMake(7, 1000-89, 306, 44);
    [self.sheet addView:confirm];
    
    UIButton * cancel = [self produceButtonWithTitle:@"取消"];
    [cancel setBackgroundImage:[UIImage imageNamed:@"img_sheet_bottom"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    cancel.tag = 10002;
    cancel.frame=CGRectMake(7, 1000-44, 306, 44);
    [self.sheet addView:cancel];
    
    self.sheet.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
}

- (UIView *)viewForSelectFragmentWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 21)];
    title.text = @"确认删除数量";
    title.font = [UIFont systemFontOfSize:FONT_SIZE+6];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
    [view addSubview:title];
    
    self.lb_selectednum = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-56)/2, CGRectGetMaxY(title.frame)+12, 56, 29)];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_selectednum"]];
    [self.lb_selectednum setBackgroundColor:color];
    self.lb_selectednum.textAlignment = NSTextAlignmentCenter;
    self.lb_selectednum.font = [UIFont systemFontOfSize:FONT_SIZE-1];
    self.lb_selectednum.textColor = [UIColor whiteColor];
    self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
    [view addSubview:self.lb_selectednum];
    
    self.btn_minus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_minus.frame = CGRectMake(CGRectGetMinX(self.lb_selectednum.frame)-17-13, CGRectGetMaxY(title.frame)+12+6, 13, 17);
    [self.btn_minus setBackgroundImage:[UIImage imageNamed:@"img_minus"] forState:UIControlStateNormal];
    [self.btn_minus addTarget:self action:@selector(minusSelectednumAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_minus];
    
    self.btn_quickminus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_quickminus.frame = CGRectMake(CGRectGetMinX(self.lb_selectednum.frame)-17-13-17-13, CGRectGetMaxY(title.frame)+12+6, 13, 17);
    [self.btn_quickminus setBackgroundImage:[UIImage imageNamed:@"img_quickminus"] forState:UIControlStateNormal];
    [self.btn_quickminus addTarget:self action:@selector(quickminusSelectednumAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_quickminus];
    
    self.btn_plus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_plus.frame = CGRectMake(CGRectGetMaxX(self.lb_selectednum.frame)+17, CGRectGetMaxY(title.frame)+12+6, 13, 17);
    [self.btn_plus setBackgroundImage:[UIImage imageNamed:@"img_plus"] forState:UIControlStateNormal];
    [self.btn_plus addTarget:self action:@selector(plusSelectednumAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_plus];
    
    self.btn_quickplus = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_quickplus.frame = CGRectMake(CGRectGetMaxX(self.lb_selectednum.frame)+17+13+17, CGRectGetMaxY(title.frame)+12+6, 13, 17);
    [self.btn_quickplus setBackgroundImage:[UIImage imageNamed:@"img_quickplus"] forState:UIControlStateNormal];
    [self.btn_quickplus addTarget:self action:@selector(quickplusSelectednumAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_quickplus];
    
    return view;
    
}

- (void)minusSelectednumAction:(id)sender{
    if (self.selectedNum == 1) {
        return;
    }else{
        self.selectedNum --;
    }
    self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
}

- (void)quickminusSelectednumAction:(id)sender{
    self.selectedNum = 1;
    self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
}

- (void)plusSelectednumAction:(id)sender{
    if (self.selectedNum == self.maxSelectNum) {
        return;
    }else{
        self.selectedNum ++;
    }
    self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
}

- (void)quickplusSelectednumAction:(id)sender{
    self.selectedNum = self.maxSelectNum;
    self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionSheetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)actionSheetButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
        {
            NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.selectedNum)];
            //选取删除数量的pieceId
            NSArray *array = [self.arr_selectedPropId objectsAtIndexes:indexs];
            [PieceHandler destroyPropWithPropId:array userId:[UserStorage userId] prepare:^{
                [SVProgressHUD show];
                
            } success:^(id obj) {
                //删除源数据中被选取的piece
                NSString* key = [_propGroupKeyArr objectAtIndex:self.selectedIndexPath.row];
                [_propGroupDic removeObjectForKey:key];
                if (self.selectedNum<self.maxSelectNum || (self.selectedNum == self.maxSelectNum && self.hasLock)) {
                    BackpackCell *cell = (BackpackCell *)[self.tb_backpack cellForRowAtIndexPath:self.selectedIndexPath];
                    [cell.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(long)(self.maxSelectNum-self.selectedNum)]];
                }else{
                    NSString* key = [_propGroupKeyArr objectAtIndex:self.selectedIndexPath.row];
                    [_propGroupDic removeObjectForKey:key];
                    [self.tb_backpack deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                //重置数据
                self.selectedNum = 1;
                self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
                //通知碎片列表刷新
                [self requestBackpack];
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            } failed:^(NSInteger statusCode, id json) {
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }];
        }
            break;
            
        case 10002:
            break;
            
        default:
            return;
    }
    [self actionSheetHidden:nil];
}

- (void)setRightTitle
{
    [self.btn_right setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)_backpack.use_bag,(long)_backpack.bag_num]];
}

- (void)requestBackpack
{
    [AccountHandler getBackpackWithUserId:[UserStorage userId] prepare:^{
        [SVProgressHUD show];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [_pieceGroupDic removeAllObjects];
        [_propGroupDic removeAllObjects];
        
        [_pieceGroupKeyArr removeAllObjects];
        [_propGroupKeyArr removeAllObjects];
        _backpack = (BackpackEntity*)obj;
//        backpack
        [self performSelector:@selector(setRightTitle) withObject:nil afterDelay:0.3];
        
        if (_backpack.bag_num > _backpack.use_bag) {
                [self.btn_right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_MAIN]} forState:UIControlStateNormal];
        }else{
                [self.btn_right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF001F"]} forState:UIControlStateNormal];
            
        }
        
        for (int i = 0; i < _backpack.piece_list.count ; i++) {
            PieceEntity* piece = [_backpack.piece_list objectAtIndex:i];
            if (![_pieceGroupDic objectForKey:piece.prop_father_id]) {
                [_pieceGroupKeyArr addObject:piece.prop_father_id];
                [_pieceGroupDic setObject:[NSMutableArray arrayWithObject:piece] forKey:piece.prop_father_id];
            }else{
                NSMutableArray* arr = [_pieceGroupDic objectForKey:piece.prop_father_id];
                [arr addObject:piece];
            }
        }
        NSMutableArray* _pieceGroupKeyArrSort = [NSMutableArray arrayWithArray:_pieceGroupKeyArr];
        for(NSInteger i = (_pieceGroupKeyArr.count - 1) ; i < _pieceGroupKeyArr.count; i--){
            NSString* key = [_pieceGroupKeyArr objectAtIndex:i];
            NSMutableArray* data = [_pieceGroupDic objectForKey:key];
            if ([AppUtils isCanSynthesis:data]) {
                [_pieceGroupKeyArrSort removeObject:key];
                [_pieceGroupKeyArrSort insertObject:key atIndex:0];
                
            }
        }
        
        [_pieceGroupKeyArr removeAllObjects];
        [_pieceGroupKeyArr addObjectsFromArray:_pieceGroupKeyArrSort];
        
        for (int i = 0; i < _backpack.prop_list.count ; i++) {
            PropertyEntity* property = [_backpack.prop_list objectAtIndex:i];
            if (![_propGroupDic objectForKey:property.prop_father_id]) {
                [_propGroupKeyArr addObject:property.prop_father_id];
                [_propGroupDic setObject:[NSMutableArray arrayWithObject:property] forKey:property.prop_father_id];
            }else{
                NSMutableArray* arr = [_propGroupDic objectForKey:property.prop_father_id];
                [arr addObject:property];
            }
        }
        
        if (!_pieceGroupKeyArr.count) {
            self.tb_backpack.tableFooterView = [AppUtils tableViewsFooterViewWithMessage:@"暂无碎片，快去扫描获取吧！"];
        }
        [self.tb_backpack reloadData];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString*)json];
        }
    }];
}

- (void)requestCardList
{
    [AccountHandler getCardpackWithUserId:[UserStorage userId] prepare:^{
        
    } success:^(NSArray* obj) {
        
        if (!obj.count) {
            self.tb_backpack.tableFooterView = [AppUtils tableViewsFooterViewWithMessage:@"暂无可使用的卡"];
        }
        
        [self.cardList removeAllObjects];
        [self.cardList addObjectsFromArray:obj];
        
        [self.tb_backpack reloadData];
    } failed:^(NSInteger statusCode, id json) {
        if(json){
            [SVProgressHUD  showErrorWithStatus:(NSString *)json];
        }else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 6)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = [UIColor redColor].CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    
    return layer;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == BackpackType_card) {
        return 150;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [UIView new];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_type == BackpackType_card) {
        return 16;
    }
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (_type) {
        case BackpackType_piece:
        {
            return _pieceGroupDic.count;
        }
            break;
        case BackpackType_prop:
        {
            return self.propGroupDic.count;
        }
            break;
        case BackpackType_card:
        {
            return 1;
        }
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (_type) {
        case BackpackType_piece:
        case BackpackType_prop:
        {
            return 1;
        }
            break;
        case BackpackType_card:
        {
            return self.cardList.count;
        }
            break;
    }
}

//cell内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_type) {
        case BackpackType_piece:
        {
            NSString *cellIdentifier = @"pieceContactCell";
            
            BackpackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil){
                cell = [[BackpackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            NSString* key = [_pieceGroupKeyArr objectAtIndex:indexPath.row];
            NSMutableArray* data = [_pieceGroupDic objectForKey:key];
            [cell contentDataWithPieceEntity:data];
            
            return cell;
        }
            break;
        case BackpackType_prop:
        {
            NSString *cellIdentifier = @"propContactCell";
            
            BackpackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil){
                cell = [[BackpackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            
            NSString* key = [_propGroupKeyArr objectAtIndex:indexPath.row];
            NSMutableArray* data = [_propGroupDic objectForKey:key];
            
            [cell contentDataWithPropertyEntity:data];
            
            return cell;
        }
            break;
        case BackpackType_card:
        {
            NSString *cellIdentifier = @"cardCell";
            
            CardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil){
                cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            CardEntity* data = [self.cardList objectAtIndex:indexPath.section];
            [cell contentWithCardEntity:data];
            
            return cell;
        }
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (_type) {
        case BackpackType_piece:
        {
            displayingPrimary = YES;
            self.bgModalPanelView = [[UIView alloc]initWithFrame:self.view.frame];            
            [[[[UIApplication sharedApplication] delegate] window] addSubview:_bgModalPanelView];
            
            UIView* bgModalPanel = [[UIView alloc]initWithFrame:CGRectMake(20, 44, self.view.frame.size.width - 40, self.view.frame.size.height - 83)];
            [_bgModalPanelView addSubview:bgModalPanel];
            
            _detailView = [[BackpackDetailView alloc]initWithFrame:bgModalPanel.bounds];
            _detailView.viewController = self;
            _detailView.delegate = self;
            [self.detailView.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.detailView.btn_share addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgModalPanel addSubview:self.detailView];
            [self.detailView showFromPoint:[self.view center]];
            
            _fragmentDetail = [[FragmentDetailView alloc]initWithFrame:bgModalPanel.bounds];
            _fragmentDetail.delegate = self;
            [self.fragmentDetail.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
            NSMutableDictionary * group = [[NSMutableDictionary alloc]init];
            
            NSString* key = [_pieceGroupKeyArr objectAtIndex:indexPath.row];
            NSMutableArray* data = [_pieceGroupDic objectForKey:key];
            for (int i = 0; i < data.count; i++) {
                PieceEntity* piece = [data objectAtIndex:i];
                if (![group objectForKey:piece.piece_branch]) {
                    [group setObject:[NSMutableArray arrayWithObject:piece] forKey:piece.piece_branch];
                }else{
                    NSMutableArray* arr = [group objectForKey:piece.piece_branch];
                    [arr addObject:piece];
                }
            }
            
            PieceEntity* piece = [data objectAtIndex:0];
            NSMutableArray* arr = [NSMutableArray arrayWithArray:[group allValues]];
            
            [_fragmentDetail setDetails:arr];
            [_detailView contentPieceWithEntity:piece isCanSynthesis:[AppUtils isCanSynthesis:data]];
            
            [_detailView setPieceBranchList:[group allKeys]];
            
        }
            break;
        case BackpackType_prop:
        {
            self.bgModalPanelView = [[UIView alloc]initWithFrame:self.view.frame];
            [self.view addSubview:_bgModalPanelView];
            
            UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(20, 64, self.view.frame.size.width - 40, self.view.frame.size.height - 104)];
            [_bgModalPanelView addSubview:bg];
            _detailView = [[BackpackDetailView alloc]initWithFrame:bg.bounds];
            _detailView.viewController = self;
            _detailView.delegate = self;
            [self.detailView.btn_turn addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.detailView.btn_share addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:self.detailView];
            [self.detailView showFromPoint:[self.view center]];
            
            NSString* key = [_propGroupKeyArr objectAtIndex:indexPath.row];
            NSMutableArray* data = [_propGroupDic objectForKey:key];
            PropertyEntity* property = [data objectAtIndex:0];
            
            [_detailView contentPropertyWithEntity:property];
        }
            break;
        case BackpackType_card :
        {
            CardEntity* data = [self.cardList objectAtIndex:indexPath.section];
            
            if (data.exchange.length) {
                WebViewController* vc = [[WebViewController alloc]init];
                vc.title = @"卡券";
                vc.str_url = [NSString stringWithFormat:@"%@?user_id=%@&token=%@&card_no=%@",data.exchange,[UserStorage userId],[UserStorage token],data.card_no];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == BackpackType_prop) {
        NSString* key = [_propGroupKeyArr objectAtIndex:indexPath.row];
        NSMutableArray* arr = [_propGroupDic objectForKey:key];
        NSInteger lock_num = 0;
        self.hasLock = NO;
        for (int i = 0; i < arr.count; i++) {
            PropertyEntity* entity = [arr objectAtIndex:i];
            if(entity.prop_lock){
                lock_num += 1;
            }
            
        }
        if (lock_num != 0) {
            self.hasLock = YES;
        }
        self.maxSelectNum = (int)arr.count - (int)lock_num;
        
        if (self.maxSelectNum > 0) {
            [self.arr_selectedPropId removeAllObjects];
            for (PropertyEntity *entity in arr){
                if (!entity.prop_lock) {
                    [self.arr_selectedPropId addObject:entity.prop_id];
                }
            }
            self.selectedIndexPath = indexPath;
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.sheet.hidden = NO;
        [self.sheet toggle];
        self.tb_backpack.editing = NO;
    }
}

- (void)shareAction:(id)sender{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"ShareSDK" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:@"Hello,Code4App.com!" defaultContent:nil image:[ShareSDK imageWithPath:path] title:@"This is title" url:@"http://mob.com" description:@"This is description" mediaType:SSPublishContentMediaTypeImage];
    //2.调用分享菜单分享
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            NSLog(@"分享成功");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        //如果分享失败
        if (state == SSResponseStateFail) {
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        //        if (state == SSResponseStateCancel){
        //            NSLog(@"分享取消");
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享取消" message:@"进入了分享取消状态" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            [alert show];
        //        }
    }];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)] && [cell isKindOfClass:[CardCell class]]) {
        if (tableView == self.tb_backpack) {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *selectedBgLayer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 12, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            selectedBgLayer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor whiteColor].CGColor;
            selectedBgLayer.fillColor = [UIColor lightGrayColor].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+12, bounds.size.height-lineHeight, bounds.size.width-12, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
            
            UIView *selectedBgView = [[UIView alloc] initWithFrame:bounds];
            [selectedBgView.layer insertSublayer:selectedBgLayer atIndex:0];
            cell.selectedBackgroundView = selectedBgView;
        }   
    }
}

- (void)turnAction:(id)sender{
    
    [UIView transitionFromView:(displayingPrimary ? self.detailView : self.fragmentDetail)
                        toView:(displayingPrimary ? self.fragmentDetail : self.detailView)
                      duration: 0.6
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            displayingPrimary = !displayingPrimary;
                        }
            }
     ];
}

- (void)titleInvoked:(id)sender
{
    [self showMenu];
}

- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"碎片"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self menuItemAction:item];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"道具"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self menuItemAction:item];
                                                         }];

    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"卡包"
                                                        subtitle:nil
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self menuItemAction:item];
                                                          }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem]];
    _menu.cornerRadius = 2;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    _menu.textColor = [UIColor whiteColor];
    _menu.font = [UIFont systemFontOfSize:18];
    _menu.backgroundColor = [UIColor colorWithHexString:@"#141414"];
    _menu.itemHeight = 45;

    [_menu showFromNavigationController:self.navigationController];
    //此时_menu才初始化完成，可以设置提示红点了
    if (!self.titleBgView.lb_noti.hidden) {
        [exploreItem setItemNoti:YES];
    }
}

- (void)menuItemAction:(REMenuItem *)item
{
    self.tb_backpack.tableFooterView = nil;
    self.type = item.tag;
    switch (_type) {
        case BackpackType_piece:
        {
            if (!_pieceGroupDic.count) {
                self.tb_backpack.tableFooterView = [AppUtils tableViewsFooterViewWithMessage:@"暂无碎片，快去扫描获取吧！"];
            }
            _titleBgView.lb_title.text = @"碎片";
            [_pieceGroupDic removeAllObjects];
            [_propGroupDic removeAllObjects];
            _tb_backpack.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self requestBackpack];
        }
            break;
        case BackpackType_prop:
        {
            
            if (!_propGroupDic.count) {
                self.tb_backpack.tableFooterView = [AppUtils tableViewsFooterViewWithMessage:@"暂无道具"];
            }
            
            self.titleBgView.lb_noti.hidden = YES;
            _titleBgView.lb_title.text = @"道具";
            _tb_backpack.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [item setItemNoti:NO];
        }
            break;
        case BackpackType_card:
        {
            _titleBgView.lb_title.text = @"卡包";
            _tb_backpack.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self requestCardList];
        }
            break;
    }
    
    [self.tb_backpack reloadData];
}

#pragma mark - HModalPanelDelegate
- (void)didCloseModalPanel:(HModalPanel *)modalPanel
{
    if (_bgModalPanelView) {
        [_bgModalPanelView removeFromSuperview];
        _bgModalPanelView = nil;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_BACKPACK_RELOAD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_SYNTHETIC_SUCCESS object:nil];
}

@end
