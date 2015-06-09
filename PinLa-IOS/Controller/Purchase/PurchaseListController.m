//
//  PurchaseListController.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PurchaseListController.h"
#import "PurchaseCell.h"
#import "StoreHandler.h"
#import "ProductEntity.h"
#import <StoreKit/StoreKit.h>

@interface PurchaseListController ()<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate>

@property (nonatomic, strong) UITableView       *tb_purchaseList;

@property (nonatomic, strong) NSMutableArray          *arr_data;

@property (nonatomic, strong) NSMutableArray          *arr_productId;

@end

@implementation PurchaseListController

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr_productId = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

-(void)onCreate{
    self.title = @"升级";
    
    _tb_purchaseList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    _tb_purchaseList.delegate = self;
    _tb_purchaseList.dataSource = self;
    _tb_purchaseList.backgroundColor = [UIColor clearColor];
    _tb_purchaseList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    _tb_purchaseList.tableFooterView = [UIView new];
    [self.view addSubview:_tb_purchaseList];
    
    [self requestGoodsList];
}


- (void)requestGoodsList
{
    [StoreHandler getGoodsListWithPrepare:^{
        
    } Success:^(NSArray * obj) {
        [self.arr_data removeAllObjects];
        [_arr_productId removeAllObjects];
        self.arr_data = [NSMutableArray arrayWithArray:obj];
        
        for (int i = 0; i < _arr_data.count; i++) {
            ProductEntity*  productEntity = [_arr_data objectAtIndex:i];
            [_arr_productId addObject:productEntity.productId];
        }
        
        [self requestProductList];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}

#pragma -mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"杂项";
            break;
        case 1:
            return @"背包";
            break;
        default:
            return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 39)];
    UILabel *lb_title = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width, 39)];
    [lb_title setFont:[UIFont boldSystemFontOfSize:FONT_SIZE + 2]];
    [lb_title setTextColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN]];
    [v_back addSubview:lb_title];
    if (section == 0) {
        [lb_title setText:@"杂项"];
    }
    if (section == 1) {
        [lb_title setText:@"背包"];
    }
    return v_back;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 31;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 31)];
    return v_back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 5;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PurchaeCell";
    
    PurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[PurchaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell contentWithPurchaseEntity:nil];
    
    if (indexPath.section == 0) {
        cell.lb_title.text = [NSString stringWithFormat:@"杂项%ld",(long)indexPath.row];
        cell.lb_description.text =[NSString stringWithFormat:@"杂项描述%ld",(long)indexPath.row];
    }else{
        cell.lb_title.text = [NSString stringWithFormat:@"背包%ld",(long)indexPath.row];
        cell.lb_description.text =[NSString stringWithFormat:@"背包描述%ld",(long)indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray* product_list = response.products;
    
    product_list.count;
}

- (void)requestProductList
{
//    SKPayment* payment = [SKPayment paymentWithProduct:product];
    
    NSSet* productIdentifiers = [NSSet setWithObject:@"in.pinla.jixiaobanjingxiao"];
    SKProductsRequest* request = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdentifiers];
    
    request.delegate = self;
    
    [request start];
}

- (void)buyProduct
{
    
}

-(void)buy:(int)type
{
    if ([SKPaymentQueue canMakePayments]) {
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//        [self RequestProductData];
    }
    else
    {
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你没允许应用程序内购买"
                                                           delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        
        [alerView show];
        
    }
}

@end
