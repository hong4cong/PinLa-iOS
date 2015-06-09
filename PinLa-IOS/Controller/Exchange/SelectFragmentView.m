//
//  SelectTradeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SelectFragmentView.h"
#import "UserStorage.h"
#import "AccountHandler.h"
#import "BackpackEntity.h"

@interface SelectFragmentView()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation SelectFragmentView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles{
    self = [super initWithFrame:frame title:title buttonTitles:buttonTitles];
    if (self) {
        self.select_arr = [NSMutableArray array];
        
        self.arr_pieceList = [NSMutableArray array];
        self.arr_propList = [NSMutableArray array];
        
        CGRect contentViewFrame = self.bounds;
        self.tb_packageList = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(contentViewFrame), 370) style:UITableViewStylePlain];
        self.tb_packageList.backgroundColor = [UIColor clearColor];
        self.tb_packageList.delegate = self;
        self.tb_packageList.dataSource = self;
        self.tb_packageList.allowsSelection = NO;
        self.tb_packageList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
        self.tb_packageList.tableFooterView = [UIView new];
        [self addSubview:self.tb_packageList];
        
        [self.btn_bottomLeft addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_bottomRight addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self requestBackpackData];
    }
    return self;
}

- (void)leftButtonAction:(id)send{
    [self.v_delegate.arr_selectedPieceList removeAllObjects];
    [self.v_delegate.arr_selectedPropList removeAllObjects];
    [self.v_delegate.select_arr removeAllObjects];
    
    [self.v_delegate.select_arr addObjectsFromArray:self.select_arr];
    
    for(NSNumber *num in self.select_arr){
        NSInteger row = [num integerValue];
        if (row < self.arr_pieceList.count) {
            [self.v_delegate.arr_selectedPieceList addObject:[self.arr_pieceList objectAtIndex:row]];
        }else{
            [self.v_delegate.arr_selectedPropList addObject:[self.arr_propList objectAtIndex:row-self.arr_pieceList.count]];
        }
    }
    
    [self.v_delegate.cv_myFragments reloadData];
    [self.v_delegate resizeView];
    [self hide];
}

- (void)rightButtonAction:(id)send{
    [self hide];
}

- (void)requestBackpackData{
    [AccountHandler getBackpackWithUserId:[UserStorage userId] prepare:^{
        
    } success:^(BackpackEntity* entity) {
        [self.arr_pieceList removeAllObjects];
        for (PieceEntity *pieceEntity in entity.piece_list) {
            if (pieceEntity.piece_lock == 0) {
                [self.arr_pieceList addObject:pieceEntity];
            }
        }
        
        [self.arr_propList removeAllObjects];
        for (PropertyEntity *propEntity in entity.prop_list) {
            if (propEntity.prop_lock == 0) {
                [self.arr_propList addObject:propEntity];
            }
        }
        
        [self.tb_packageList reloadData];
        
    } failed:^(NSInteger statusCode, id json) {
        
    }];
    
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

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_propList.count+self.arr_pieceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"SelectFragmentCell";
    SelectFragmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[SelectFragmentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell.btn_select addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.btn_select.tag = indexPath.row;
    if ([self.select_arr containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.btn_select.selected = YES;
    }else{
        cell.btn_select.selected = NO;
    }
    
    if (indexPath.row < self.arr_pieceList.count) {
        PieceEntity *entity = [self.arr_pieceList objectAtIndex:indexPath.row];
        [cell contentCellWithPieceEntity:entity];
    }else{
        PropertyEntity *entity = [self.arr_propList objectAtIndex:indexPath.row-self.arr_pieceList.count];
        [cell contentCellWithPropertyEntity:entity];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < self.arr_pieceList.count) {
        
    }else{
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
