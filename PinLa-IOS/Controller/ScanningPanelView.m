//
//  ScanningPanelView.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/18.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ScanningPanelView.h"
#import "ScanningPanelCell.h"
#import "PieceHandler.h"
#import "UserStorage.h"
#import "PieceEntity.h"
#import "BackpackDetailView.h"
#import "FragmentDetailView.h"
#import "PieceDetailModalPanelView.h"

@interface ScanningPanelView ()
{
    bool displayingPrimary;
}

@property (nonatomic,strong) NSMutableArray         *select_arr;
@property (nonatomic,strong) PieceDetailModalPanelView                 *bgModalPanelView;
@property (nonatomic,strong) BackpackDetailView     *detailView;
@property (nonatomic,strong) FragmentDetailView     *fragmentDetail;

@end

@implementation ScanningPanelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.margin = UIEdgeInsetsMake(20, 10, 80, 10);
    CGRect contentViewFrame = [self contentViewFrame];
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN_LEFT - 10, - 20, 150, 50)];
    title.text = @"选择碎片";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:title];

    UIButton *btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentViewFrame) - 20 - MARGIN_RIGHT - 30, -15 , 40, 40)];
    [btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn_back];
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(-10, CGRectGetMaxY(title.frame), contentViewFrame.size.width + 20, contentViewFrame.size.height - 40 - 40 )];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView setSeparatorInset:UIEdgeInsetsMake(0 ,50, 0, 0)];
    tableView.backgroundColor = [UIColor blackColor];
    tableView.tableFooterView = [UIView new];
    tableView.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    [self.contentView addSubview:tableView];
    
    UIButton * selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.frame = CGRectMake(-10, contentViewFrame.size.height - 35, contentViewFrame.size.width/2, 50);
    [selectAllBtn setTitle:@"全部拾取" forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor colorWithHexString:COLOR_MAIN] forState:UIControlStateHighlighted];
    selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [selectAllBtn addTarget:self action:@selector(selectAllAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectAllBtn];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(contentViewFrame.size.width/2 + 10, contentViewFrame.size.height - 35, contentViewFrame.size.width/2, 50);
    selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [selectBtn setTitle:@"拾取所选" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor colorWithHexString:COLOR_MAIN] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];

    [self.contentView addSubview:[AppUtils addLineWithFrame:CGRectMake(-15,CGRectGetMaxY(title.frame),contentViewFrame.size.width+30, LINE_HEIGHT)]];
    [self.contentView addSubview:[AppUtils addLineWithFrame:CGRectMake(-15, contentViewFrame.size.height - 40,contentViewFrame.size.width+30, LINE_HEIGHT)]];
    [self.contentView addSubview:[AppUtils addLineWithFrame:CGRectMake(contentViewFrame.size.width/2, contentViewFrame.size.height - 40, LINE_HEIGHT, 60)]];
    
    
    self.contentColor = [UIColor blackColor];
//    [self addSubview:tableView];
}

- (void)selectAllAction
{
    NSMutableArray* select_arr = [NSMutableArray array];
    for (int i = 0 ; i < _arr_data.count; i++) {
        PieceEntity *entity = [_arr_data objectAtIndex:i];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:entity.prop_father_id forKey:@"prop_father_id"];
        [dic setObject:entity.piece_branch forKey:@"piece_branch"];
        [select_arr addObject:dic];
    }
    [PieceHandler pickupPieceWithUserId:[UserStorage userId] pieceList:select_arr prepare:^{
        
    } success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"拾取成功"];
        [UserStorage saveIsShowBackageRedPoint:YES];
        [self goBack:nil];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString*)json];
        }
    }];
}

- (void)searchAction
{
    NSMutableArray* select_arr = [NSMutableArray array];
    for (int i = 0; i < self.select_arr.count; i++) {
        NSInteger index = [[_select_arr objectAtIndex:i] integerValue];
        
        PieceEntity *entity = [_arr_data objectAtIndex:index];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:entity.prop_father_id forKey:@"prop_father_id"];
        [dic setObject:entity.piece_branch forKey:@"piece_branch"];
        [select_arr addObject:dic];
    }
    
    if(!select_arr.count){
        [SVProgressHUD showErrorWithStatus:@"尚未选择碎片"];
        return;
    }
    
    [PieceHandler pickupPieceWithUserId:[UserStorage userId] pieceList:select_arr prepare:^{
        
    } success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"拾取成功"];
        
        [UserStorage saveIsShowBackageRedPoint:YES];
        [self goBack:nil];
    } failed:^(NSInteger statusCode, NSString* json) {
        [SVProgressHUD showErrorWithStatus:json];
    }];
}

- (void)setArr_data:(NSArray *)arr_data
{
    _arr_data = arr_data;
    
    self.select_arr = [NSMutableArray arrayWithCapacity:_arr_data.count];
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RelationCell";
    ScanningPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ScanningPanelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iv_icon addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.iv_icon.tag = indexPath.row;
    PieceEntity *entity = [_arr_data objectAtIndex:indexPath.row];
    
    if ([self.select_arr containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.iv_icon.selected = YES;
    }else{
        cell.iv_icon.selected = NO;
    }
    [cell contentDataWithEntity:entity];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PieceEntity *entity = [_arr_data objectAtIndex:indexPath.row];
    [self requestPieceDetail:entity.prop_father_id piece_branch:entity.piece_branch];
}

- (void)btnAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.select_arr addObject:[NSNumber numberWithInteger:btn.tag]];
    }else{
        [self.select_arr removeObject:[NSNumber numberWithInteger:btn.tag]];
    }
}

- (void)goBack:(id)sender{
    [self hide];
}

- (void)requestPieceDetail:(NSString*)propFatherId piece_branch:(NSString*)piece_branch{
    [PieceHandler getPieceDetailWithUserId:[UserStorage userId] propFatherId:propFatherId prepare:^{
        [SVProgressHUD showWithStatus:@"正在加载"];
    } success:^(PieceNumberingEntity* obj) {
        [SVProgressHUD dismiss];
        obj.piece_branch = piece_branch;
        [self showPanel:obj];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)showPanel:(PieceNumberingEntity*)data
{
    self.bgModalPanelView = [[PieceDetailModalPanelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:_bgModalPanelView];
    
    [self.bgModalPanelView contentWithPieceNumberingEntity:data];
}


@end
