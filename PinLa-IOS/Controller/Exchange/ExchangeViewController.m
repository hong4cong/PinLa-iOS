//
//  ExchangeViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeView.h"
#import "TradeCell.h"
#import "RelationCell.h"
#import "CommitTradeCell.h"
#import "IndicatorView.h"
#import "REMenu.h"
#import "TitleBgView.h"
#import "CreateExchangeView.h"
#import "PaticipantTradeView.h"
#import "CommitTradeListView.h"
#import "CommitTradeView.h"
#import "TradeHandler.h"
#import "UserStorage.h"
#import "SelectedFragmentCell.h"
#import "AccountHandler.h"
#import "PaticipantTradeEntity.h"
#import "LTBounceSheet.h"
#import <UIImageView+WebCache.h>

@interface ExchangeViewController ()<UITableViewDataSource,UITableViewDelegate,ExchangeViewDelegate,ExchangeCellDelegate,UINavigationControllerDelegate,PaticipantTradeCellDelegate,LargeHModalPanelDelegate,CommitTradeListViewDelegate,CommitTradeViewDelegate>

@property (nonatomic, strong) ExchangeView              *v;
@property (nonatomic, strong) PaticipantTradeView    *v_paticipant;
@property (nonatomic        ) NSInteger                 *menuTag;

@property (nonatomic, strong) TitleBgView               *titleBgView;
@property (nonatomic, strong) REMenu                    *menu;
@property (nonatomic, strong) CreateExchangeView        *v_createExchange;
@property (nonatomic, strong) CommitTradeListView       *v_commitTradeList;
@property (nonatomic, strong) CommitTradeView           *v_cancelTradeView;

@property (nonatomic, strong) NSMutableArray            *arr_tradeList;
@property (nonatomic, strong) NSMutableArray            *arr_paticipantTradeList;
@property (nonatomic, strong) LTBounceSheet             *sheet;
@property (nonatomic, assign) int                       int_deleteIndex;

@property (nonatomic)         NSInteger         deleteCellTag;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNSNotification];
    self.arr_tradeList = [NSMutableArray array];
    self.arr_paticipantTradeList = [NSMutableArray array];
    
    _v = [[ExchangeView alloc] initWithFrame:CGRectMake(0, 64 + 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    _v.delegate = self;
    _v.tb_tradeList.delegate = self;
    _v.tb_tradeList.dataSource = self;
    _v.tb_tradeList.tableFooterView = [UIView new];
    [self.view addSubview:_v];
    
    _v_paticipant = [[PaticipantTradeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
                     ];
    _v_paticipant.tb_paticipantList.delegate = self;
    _v_paticipant.tb_paticipantList.dataSource = self;
    _v_paticipant.tb_paticipantList.tableFooterView = [UIView new];

    
    _titleBgView = [[TitleBgView alloc]initWithFrame:CGRectMake(0, 0, 200, 20) title:@"发起的交换"];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleInvoked:)];
    _titleBgView.lb_title.userInteractionEnabled = YES;
    [_titleBgView.lb_title addGestureRecognizer:gesture];
    _titleBgView.lb_title.text = @"发起的交换";
    self.navigationItem.titleView = _titleBgView;
    
    //初始化actionsheet
    [self setupActionSheet];
    self.sheet.hidden = YES;
//    //给屏幕加手势用于隐藏Actionsheet
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSheetHidden:)];
//    viewTap.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:viewTap];
}

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;

    [super viewWillAppear:animated];
    [self requestTradeData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_menu.isOpen){
        [_menu removeView];
    }
}

- (void)addNSNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestTradeData)
                                                 name:NOTI_TRADE_CONFIRM_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestPaticipantTradeData)
                                                 name:NOTI_TRADE_CANCEL_SUCCESS
                                               object:nil];
}

- (void)removeNSNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_TRADE_CONFIRM_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_TRADE_CANCEL_SUCCESS object:nil];
}

- (void)actionSheetHidden:(UITapGestureRecognizer *)tap{
    [self.sheet hide];
}
- (void)setupActionSheet{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:1000 bgColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetHeight(self.sheet.frame)-144, 306, 44)];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.text = @"确认取消该交换？";
    lb_title.textColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.font = [UIFont systemFontOfSize:FONT_SIZE+5];
    [self.sheet addView:lb_title];
    
    UIButton * option2 = [self produceButtonWithTitle:@"是"];
    [option2 setBackgroundImage:[UIImage imageNamed:@"img_sheet_top"] forState:UIControlStateNormal];
    option2.tag = 10001;
    option2.frame=CGRectMake(7, CGRectGetHeight(self.sheet.frame)-99, 306, 44);
    [self.sheet addView:option2];
    
    UIButton * cancel = [self produceButtonWithTitle:@"否"];
    [cancel setBackgroundImage:[UIImage imageNamed:@"img_sheet_bottom"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    cancel.tag = 10002;
    cancel.frame=CGRectMake(7, CGRectGetHeight(self.sheet.frame)-53, 306, 44);
    [self.sheet addView:cancel];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:FONT_SIZE+5];
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
            if (self.menuTag == 0){
                TradeEntity *tradeEntity = [self.arr_tradeList objectAtIndex:self.deleteCellTag];
                [TradeHandler cancelTradeSellWithUserId:[UserStorage userId] tradeId:tradeEntity.trade_id prepare:^{
                    [SVProgressHUD show];
                } success:^(id obj) {
                    [SVProgressHUD showSuccessWithStatus:@"取消交换成功"];
                    [self requestTradeData];
                } failed:^(NSInteger statusCode, id json) {
                    [SVProgressHUD showErrorWithStatus:@"取消交换失败"];
                }];
            }else if (self.menuTag == 1){
                PaticipantTradeEntity *entity = [self.arr_paticipantTradeList objectAtIndex:self.deleteCellTag];
                [TradeHandler cancelTradeBuyWithUserId:[UserStorage userId] tradeChildId:entity.trade_child_id prepare:^{
                    [SVProgressHUD show];
                } success:^(id obj) {
                    [SVProgressHUD showSuccessWithStatus:@"取消交换成功"];
                    [self requestPaticipantTradeData];
                } failed:^(NSInteger statusCode, id json) {
                    [SVProgressHUD showErrorWithStatus:@"取消交换失败"];
                }];

            }
        }
            break;
            
        case 10002:
        {
        }
            break;
            
        default:
            return;
    }
    [self actionSheetHidden:nil];
    self.sheet.hidden = YES;
}

- (void)requestPaticipantTradeData{
    [TradeHandler getMyTradeInfoBuyWithUserId:[UserStorage userId] prepare:^{
        [SVProgressHUD show];
    } success:^(NSArray *arr_paticipantTrade) {
        [SVProgressHUD dismiss];
        [self.arr_paticipantTradeList removeAllObjects];
        [self.arr_paticipantTradeList addObjectsFromArray:arr_paticipantTrade];
        [self.v_paticipant.tb_paticipantList reloadData];
//        [SVProgressHUD showSuccessWithStatus:@"获取参与交换列表成功"];
    } failed:^(NSInteger statusCode, id json) {
        [SVProgressHUD showErrorWithStatus:@"获取参与交换列表失败"];
    }];
}

- (void)requestTradeData{
    [TradeHandler getMyTradeInfoSellWithUserId:[UserStorage userId] prepare:^{
        [SVProgressHUD show];
    } success:^(NSArray *arr_trade) {
        [SVProgressHUD dismiss];
        [self.arr_tradeList removeAllObjects];
        [self.arr_tradeList addObjectsFromArray:arr_trade];
        [self.v.tb_tradeList reloadData];
//        [SVProgressHUD showInfoWithStatus:@"获取交换列表成功"];
    } failed:^(NSInteger statusCode, id json) {
        [SVProgressHUD showErrorWithStatus:@"获取交换列表失败"];
    }];
}


#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _v.tb_tradeList) {
        return 70;
    }else if(tableView == _v_paticipant.tb_paticipantList){
        return 67;
    }else{
        return 67;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _v.tb_tradeList) {
        return self.arr_tradeList.count;
    }else if(tableView == _v_paticipant.tb_paticipantList){
        return self.arr_paticipantTradeList.count;
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _v.tb_tradeList) {
        static NSString *CellIdentifier = @"ExchangeCell";
        TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[TradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.delegate = self;
        cell.btn_trash.tag = indexPath.row;
        TradeEntity *tradeEntity = [self.arr_tradeList objectAtIndex:indexPath.row];
        [cell contentCellWithExchangeEntity:tradeEntity noti:YES];
        return cell;
    }else if(tableView == _v_paticipant.tb_paticipantList){
        static NSString *CellIdentifier = @"PaticipantExchangeCell";
        PaticipantTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[PaticipantTradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.delegate = self;
        cell.btn_delete.tag = indexPath.row;
        PaticipantTradeEntity *paticipantTradeEntity = [self.arr_paticipantTradeList objectAtIndex:indexPath.row];
        [cell contentCellWithPaticipantExchangeEntity:paticipantTradeEntity];
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == _v.tb_tradeList) {//点击发起交换的列表
        TradeEntity *tradeEntity =[self.arr_tradeList objectAtIndex:indexPath.row];
        [TradeHandler getTradeDetailWithUserId:[UserStorage userId] tradeId:tradeEntity.trade_id prepare:^{
//            [SVProgressHUD show];
        } success:^(NSArray *arr_tradeBuyList) {
            [SVProgressHUD dismiss];
            self.navigationController.navigationBarHidden = YES;
            
            UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
            bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
            [self.view addSubview:bg];
            _v_commitTradeList = [[CommitTradeListView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68)];
            _v_commitTradeList.delegate = self;
            [bg addSubview:_v_commitTradeList];
            [_v_commitTradeList loadDataWithMyTradeEntity:tradeEntity buyList:arr_tradeBuyList];
            [_v_commitTradeList showFromPoint:[self.view center]];
//            [SVProgressHUD showInfoWithStatus:@"获取交易详情成功"];
        } failed:^(NSInteger statusCode, id json) {
            [SVProgressHUD showErrorWithStatus:@"获取交易详情失败"];
        }];
    }else if (tableView == _v_paticipant.tb_paticipantList){
        self.navigationController.navigationBarHidden = YES;
        UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [self.view addSubview:bg];
        _v_cancelTradeView = [[CommitTradeView alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68)];
        _v_cancelTradeView.tradeViewType = TradeViewTypeCancel;
        _v_cancelTradeView.delegate = self;
        PaticipantTradeEntity *paticipantTradeEntity = [self.arr_paticipantTradeList objectAtIndex:indexPath.row];
        [_v_cancelTradeView loadDataWithPaticipantTradeEntity:paticipantTradeEntity];
        [_v_cancelTradeView.btn_comfirm setTitle:@"取消交易" forState:UIControlStateNormal];
        [bg addSubview:_v_cancelTradeView];
        [_v_cancelTradeView showFromPoint:[self.view center]];
    }
}

#pragma -mark ExchangeViewDelegate

- (void)backToMenuAction:(id)sender{
    [self leftBarAction:sender];
}

//创建交换
- (void)createExchangeAction:(id)sender{
    
    self.navigationController.navigationBarHidden = YES;
    
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self.view addSubview:bg];
    _v_createExchange = [[CreateExchangeView alloc]initWithFrame:CGRectMake(8, 0, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68) title:@"创建交换" buttonTitles:@[@"确认提交",@"取消选择"]];
    _v_createExchange.delegate = self;
    [bg addSubview:_v_createExchange];
    [_v_createExchange showFromPoint:[self.view center]];

}

#pragma -mark TradeCellDelegate
- (void)moveCellToTrashAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    self.deleteCellTag = button.tag;
    self.sheet.hidden = NO;
    [self.sheet show];
}


- (void)titleInvoked:(id)sender
{
    [self showMenu];
}

- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"发起的交换"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self menuItemAction:item];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"参与的交换"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self menuItemAction:item];
                                                         }];
    
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem]];
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
}

//titleView中菜单的切换动作
- (void)menuItemAction:(REMenuItem *)item
{
    switch (item.tag) {
        case ExchangeCellType_init:
        {
            _titleBgView.lb_title.text = @"发起的交换";
            self.menuTag = 0;
            [_v_paticipant removeFromSuperview];
            [self.view addSubview:_v];
            [self requestTradeData];
        }
            break;
            
        case ExchangeCellType_join:
        {
            _titleBgView.lb_title.text = @"参与的交换";
            self.menuTag = 1;
            [_v removeFromSuperview];
            [self.view addSubview:_v_paticipant];
            [self requestPaticipantTradeData];
        }
            break;
    }
    
//    [_v updateExchangeState:self.item.tag];
    [_v.tb_tradeList reloadData];
}
#pragma  -mark LargeHModalPanelDelegate
//点击modelView中的下方两个按钮的动作
- (void)modelView:(UIView *)modelView clickBottomButtonAction:(LargeHMPButtonType)buttonType{
    if (modelView == _v_createExchange) {
        if (buttonType == LargeHMPButtonTypeLeft) {
            if([_v_createExchange.tv_description.text isEqualToString:@""]||_v_createExchange.tv_description.text == nil){
                [SVProgressHUD showErrorWithStatus:@"说明不能为空"];
                return;
            }
            NSMutableArray *arr_pieceId = [NSMutableArray array];
            NSMutableArray *arr_propId = [NSMutableArray array];
            for (PieceEntity *pieceEntity in _v_createExchange.arr_selectedPieceList) {
                if (pieceEntity.piece_id) {
                    [arr_pieceId addObject:[NSDictionary dictionaryWithObjectsAndKeys:pieceEntity.piece_id,@"piece_id", nil]];
                }
            }
            for (PropertyEntity *propEntity in _v_createExchange.arr_selectedPropList) {
                if (propEntity.prop_id) {
                    [arr_propId addObject:[NSDictionary dictionaryWithObjectsAndKeys:propEntity.prop_id,@"prop_id", nil]];
                }
            }
            
            [TradeHandler tradeSellWithUserId:[UserStorage userId] pieceList:arr_pieceId propList:arr_propId msg:_v_createExchange.tv_description.text prepare:^{
                [SVProgressHUD show];
            } success:^(id obj) {
                [SVProgressHUD showSuccessWithStatus:@"创建交易成功"];
                [self requestTradeData];
                [_v_createExchange hide];
                self.navigationController.navigationBarHidden = NO;
            } failed:^(NSInteger statusCode, id json) {
                [SVProgressHUD showErrorWithStatus:@"创建交易失败"];
            }];
        }else{
            [_v_createExchange hide];
            self.navigationController.navigationBarHidden = NO;
        }
    }else if (modelView == _v_commitTradeList){
        if (buttonType == LargeHMPButtonTypeLeft) {
//            [self requestTradeData];
//            self.navigationController.navigationBarHidden = NO;
        }else if (buttonType == LargeHMPButtonTypeRight){
//            [_v_commitTradeList hide];
//            self.navigationController.navigationBarHidden = NO;
        }else{
            [self requestTradeData];
            self.navigationController.navigationBarHidden = NO;
        }
    }
}

- (void)modelView:(UIView *)modelView goBackAction:(id)sender{
    self.navigationController.navigationBarHidden = NO;
}

#pragma  -mark PaticipantExchangeCellDelegate

- (void)deletePaticipantCellAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    self.deleteCellTag = button.tag;
    self.sheet.hidden = NO;
    [self.sheet show];
}

- (void)dealloc
{
    [self removeNSNotification];
}

@end
