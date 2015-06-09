//
//  MessageViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/18.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTypeOneCell.h"
#import "MessageTypeTwoCell.h"
#import "MessageEntity.h"
#import "NSString+Size.h"
#import "MessageEntity.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import "LTBounceSheet.h"
#import "PaticipantTradeEntity.h"
#import "CommitTradeView.h"


@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,CommitTradeViewDelegate>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray *arr_selected;
@property(nonatomic,strong)NSMutableArray *arr_messages;
@property (nonatomic, assign) int             int_deleteIndex;
@property (nonatomic, strong) LTBounceSheet     *sheet;

@property (nonatomic, strong) CommitTradeView   *v_detailView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"消息";
    self.arr_selected = [NSMutableArray array];
    self.arr_messages = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    [self.view addSubview:_tableView];
    
    [self loadData];
    
    //初始化actionsheet
    [self setupActionSheet];
    self.sheet.hidden = YES;
}

- (void)actionSheetHidden:(UITapGestureRecognizer *)tap{
    [self.sheet hide];
}
- (void)setupActionSheet{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:1000 bgColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetHeight(self.sheet.frame)-144, 306, 44)];
    lb_title.backgroundColor = [UIColor clearColor];
    lb_title.text = @"确认删除改信息？";
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
            MessageEntity *messageEntity = [self.arr_messages objectAtIndex:self.int_deleteIndex];
            [AccountHandler deleteMessageWithUserId:[UserStorage userId] messageId:messageEntity.message_id prepare:^{
                [SVProgressHUD showWithStatus:@"正在删除消息"];
            } success:^(id obj) {
                [SVProgressHUD dismiss];
                [self.arr_messages removeObjectAtIndex:self.int_deleteIndex];
                [self.tableView reloadData];
            } failed:^(NSInteger statusCode, id json) {
                if (json) {
                    [SVProgressHUD showErrorWithStatus:(NSString *)json];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除消息失败"];
                }
            }];

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


- (void)loadData{
    
    [AccountHandler getMessageWithUserId:[UserStorage userId] prepare:^{
//        [SVProgressHUD showWithStatus:@"正在获取信息"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [self.arr_messages addObjectsFromArray:(NSArray *)obj];
        [self.tableView reloadData];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
        }
    }];
}

#pragma -mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageEntity *messageEntity = [self.arr_messages objectAtIndex:indexPath.row];
    if ([messageEntity.type isEqualToString:@"2"]) {
        return 70;
    }else{
        NSString *str = messageEntity.messageDetail;
        CGFloat height = [str fittingLabelHeightWithWidth:self.view.frame.size.width - MARGIN_LEFT * 2 andFontSize:[UIFont systemFontOfSize:FONT_SIZE - 1]];
        if ([self.arr_selected containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
            return 70 + 15 + height;
        }else{
            return 70;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageEntity *messageEntity = [self.arr_messages objectAtIndex:indexPath.row];
    if ([messageEntity.type isEqualToString:@"2"]) {
        static NSString *CellIdentifier = @"MessageTypeOneCell";
        MessageTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MessageTypeOneCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        [cell.btn_delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_delete.tag = indexPath.row;
        [cell.btn_detailAction addTarget:self action:@selector(showTradeDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.editing = NO;
        [cell contentMessageWithMessageEntity:messageEntity];
        return cell;
    }else{
        static NSString *CellIdentifier = @"MessageTypeTwoCell";
        MessageTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MessageTypeTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn_delete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_delete.tag = indexPath.row;
        [cell.btn_detailAction addTarget:self action:@selector(detailAvtion:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_detailAction.tag = indexPath.row;
        if ([self.arr_selected containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
            [cell addSubview:cell.lb_detail];
            [cell.btn_detailAction setTitle:@"收起详情" forState:UIControlStateNormal];
        }else{
            [cell.lb_detail removeFromSuperview];
            [cell.btn_detailAction setTitle:@"展开详情" forState:UIControlStateNormal];
        }
        [cell contentMessageWithMessageEntity:messageEntity];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showTradeDetailAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MessageEntity *entity = [self.arr_messages objectAtIndex:btn.tag];
    self.navigationController.navigationBarHidden = YES;
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self.view addSubview:bg];
    _v_detailView = [[CommitTradeView alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68)];
    _v_detailView.btn_comfirm.hidden = YES;
    _v_detailView.delegate = self;
    entity.trade_list.sell_trade.user_icon = entity.pic;
    entity.trade_list.sell_trade.trade_detail = entity.sell_msg;
    [_v_detailView loadDataWithPaticipantTradeEntity:entity.trade_list];
    [bg addSubview:_v_detailView];
    [_v_detailView showFromPoint:[self.view center]];
}

- (void)detailAvtion:(id)sender{
    UIButton *btn_sender = (UIButton *)sender;
    if ([self.arr_selected containsObject:[NSString stringWithFormat:@"%d",(int)btn_sender.tag]]) {
        [self.arr_selected removeObject:[NSString stringWithFormat:@"%d",(int)btn_sender.tag]];
    }else{
        [self.arr_selected addObject:[NSString stringWithFormat:@"%d",(int)btn_sender.tag]];
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn_sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)modelView:(UIView *)modelView goBackAction:(id)sender{
    self.navigationController.navigationBarHidden = NO;
}


- (void)deleteAction:(id)sender{
    UIButton *btn_sender = (UIButton *)sender;
    self.int_deleteIndex = (int)btn_sender.tag;
    self.sheet.hidden = NO;
    [self.sheet toggle];
}


@end
