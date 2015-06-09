//
//  FragmentDetailView.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "FragmentDetailView.h"
#import "FragmentDetailCell.h"
#import "LTBounceSheet.h"
#import "PieceEntity.h"
#import "PieceHandler.h"
#import "UserStorage.h"
#import "PieceNumberingEntity.h"

@interface FragmentDetailView()

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
@property (nonatomic, strong) NSMutableArray *arr_selectedPieceId;

@end
@implementation FragmentDetailView


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
    CGRect contentViewFrame = [self frame];
    self.arr_details = [NSMutableArray array];
    
    UILabel  *lb_title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, 50)];
    [lb_title setText:@"背包内相关碎片"];
    [lb_title setTextColor:[UIColor colorWithHexString:COLOR_TEXT_LIGHTGRAY]];
    [lb_title setFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
    [self.contentView addSubview:lb_title];
    
    [AppUtils addLineOnView:self.contentView WithFrame:CGRectMake(0, 50, CGRectGetMaxX(contentViewFrame),1)];
    
    UIButton *btn_back = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentViewFrame) - 42, 10, 40, 40)];
    [btn_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn_back];
    
    self.tb_detailList = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetMaxX(contentViewFrame),CGRectGetHeight(contentViewFrame) - 120 - 5)];
    [self.tb_detailList setBackgroundColor:[UIColor clearColor]];
    self.tb_detailList.delegate = self;
    self.tb_detailList.dataSource = self;
    self.tb_detailList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    self.tb_detailList.allowsSelection = NO;
    self.tb_detailList.tableFooterView = [UIView new];
    [self.contentView addSubview:self.tb_detailList];
    
    self.btn_turn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentViewFrame)/2 - 30, CGRectGetHeight(contentViewFrame) - 60 - 5, 60, 60)];
    [self.btn_turn setBackgroundImage:[UIImage imageNamed:@"iconfontPolygon"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btn_turn];
    
    //初始化actionsheet
    self.selectedNum = 1;
    self.arr_selectedPieceId = [NSMutableArray array];
    [self setupActionSheet];
    
//    //给屏幕加手势用于隐藏Actionsheet
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSheetHidden:)];
//    viewTap.cancelsTouchesInView = NO;
//    [self addGestureRecognizer:viewTap];
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
    [self addSubview:self.sheet];
    self.sheet.hidden = YES;
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
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
            NSArray *array = [self.arr_selectedPieceId objectsAtIndexes:indexs];
            [PieceHandler destroyPieceWithPieceId:array userId:[UserStorage userId] prepare:^{
                [SVProgressHUD show];
             
            } success:^(id obj) {
                //删除源数据中被选取的piece
                NSMutableArray* arr = [self.arr_details objectAtIndex:self.selectedIndexPath.row];
                [arr removeObjectsAtIndexes:indexs];
                if (self.selectedNum<self.maxSelectNum || (self.selectedNum == self.maxSelectNum && self.hasLock)) {
                    FragmentDetailCell *cell = (FragmentDetailCell *)[self.tb_detailList cellForRowAtIndexPath:self.selectedIndexPath];
                    [cell.iv_allNumber setLableText:[NSString stringWithFormat:@"%ld",(long)arr.count]];
                }else{
                    [self.arr_details removeObjectAtIndex:self.selectedIndexPath.row];
                    [self.tb_detailList deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                //重置数据
                self.selectedNum = 1;
                self.lb_selectednum.text = [NSString stringWithFormat:@"%d",self.selectedNum];
                //通知碎片列表刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BACKPACK_RELOAD object:nil];
                
                if(!self.arr_details.count){
                    [self hide];
                }
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.pieceNumberingEntity) {
        return self.pieceNumberingEntity.piece_list.count;
    }else{
        return self.arr_details.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"datailsCell";
    FragmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[FragmentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.pieceNumberingEntity) {
        [cell contentWithPieceNumberingEntity:self.pieceNumberingEntity row:indexPath.row];
    }else{
        NSArray* arr = [self.arr_details objectAtIndex:indexPath.row];
        [cell contentDataWithPieceEntity:arr];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.pieceNumberingEntity){
        return NO;
    }
    
    NSArray* arr = [self.arr_details objectAtIndex:indexPath.row];
    NSInteger lock_num = 0;
    self.hasLock = NO;
    for (int i = 0; i < arr.count; i++) {
        PieceEntity* entity = [arr objectAtIndex:i];
        if(entity.piece_lock){
            lock_num += 1;
        }
        
    }
    if (lock_num != 0) {
        self.hasLock = YES;
    }
    self.maxSelectNum = (int)arr.count - (int)lock_num;
    
    if (self.maxSelectNum > 0) {
        [self.arr_selectedPieceId removeAllObjects];
        for (PieceEntity *entity in arr){
            if (!entity.piece_lock) {
                [self.arr_selectedPieceId addObject:entity.piece_id];
            }
        }
        self.selectedIndexPath = indexPath;
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        self.sheet.hidden = NO;
        [self.sheet toggle];
        self.tb_detailList.editing = NO;
    }
}

- (void)setDetails:(NSMutableArray *)arr{
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSMutableArray * arr1 = obj1;
        NSMutableArray * arr2 = obj2;
        if (arr1.count && arr2.count) {
            PieceEntity *entity1 = [arr1 objectAtIndex:0];
            PieceEntity *entity2 = [arr2 objectAtIndex:0];
            if ([entity1.piece_branch intValue] > [entity2.piece_branch intValue]) {
                return NSOrderedDescending;
            } else if([entity1.piece_branch intValue] == [entity2.piece_branch intValue]){
                return NSOrderedSame;
            }else if([entity1.piece_branch intValue] < [entity2.piece_branch intValue]){
                return NSOrderedAscending;
            }
        }
        return NSOrderedSame;
    }];
    self.arr_details = arr;
    [self.tb_detailList reloadData];
}

- (void)goBack:(id)sender{
    
    [self hide];
}

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity
{
    self.pieceNumberingEntity = entity;
    [self.tb_detailList reloadData];
}

@end
