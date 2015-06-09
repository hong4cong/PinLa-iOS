//
//  CreateExchangeView.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CreateExchangeView.h"
#import "SelectedFragmentCell.h"
#import "PropertyEntity.h"
#import "PieceEntity.h"
#import "SelectFragmentView.h"
#import "TradeHandler.h"
#import "UserStorage.h"

@interface CreateExchangeView()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) SelectFragmentView        *v_selectFragment;

@end

@implementation CreateExchangeView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles{
    self = [super initWithFrame:frame title:title buttonTitles:buttonTitles];
    if (self) {
        self.arr_selectedPieceList = [NSMutableArray array];
        self.arr_selectedPropList = [NSMutableArray array];
        self.select_arr = [NSMutableArray array];
        
        self.scv_bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 49, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-49-57)];
        self.scv_bg.contentSize = self.scv_bg.frame.size;
        [self.contentView addSubview:self.scv_bg];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(60,49);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _cv_myFragments = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-240)/2, 10, 240, 49) collectionViewLayout:flowLayout];
        _cv_myFragments.delegate = self;
        _cv_myFragments.dataSource = self;
        [_cv_myFragments setBackgroundColor:[UIColor clearColor]];
        [_cv_myFragments registerClass:[SelectedFragmentCell class] forCellWithReuseIdentifier:@"SelectedFragmentCell"];
        
        [self.scv_bg addSubview:_cv_myFragments];

        self.lb_description = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.cv_myFragments.frame)+10, 200, 16)];
        self.lb_description.text = @"说明（12/30）";
        self.lb_description.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        self.lb_description.textColor = [UIColor whiteColor];
        [self.scv_bg addSubview:self.lb_description];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lb_description.frame)+14, CGRectGetWidth(self.frame), 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
        [self.scv_bg addSubview:self.line];
        
        self.tv_description = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.lb_description.frame)+14, CGRectGetWidth(self.frame)-24, 70)];
        self.tv_description.delegate = self;
        self.tv_description.backgroundColor = [UIColor clearColor];
        self.tv_description.font = [UIFont systemFontOfSize:FONT_SIZE+1];
        self.tv_description.textColor = [UIColor whiteColor];
        self.tv_description.placeholder = @"不能为空";
        self.tv_description.text = @"快来看看有没有你想要的吧";
        self.tv_description.returnKeyType = UIReturnKeyDone;
        [self.scv_bg addSubview:self.tv_description];
        
//        [self.btn_bottomLeft addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btn_bottomRight addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


//- (void)leftButtonAction:(id)send{
//
//}
//
//- (void)rightButtonAction:(id)send{
//    [self hide];
//}

- (void)resizeView{
    self.cv_myFragments.frame = CGRectMake((CGRectGetWidth(self.frame)-240)/2, 10, 240, ((self.arr_selectedPieceList.count+self.arr_selectedPropList.count)/4+1)*60);
    self.lb_description.frame = CGRectMake(15, CGRectGetMaxY(self.cv_myFragments.frame)+10, 200, 16);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.lb_description.frame)+14, CGRectGetWidth(self.frame), 1);
    self.tv_description.frame = CGRectMake(12, CGRectGetMaxY(self.lb_description.frame)+14, CGRectGetWidth(self.frame)-24, 70);
    self.scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.tv_description.frame));
}


#pragma -mark UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arr_selectedPieceList.count+self.arr_selectedPropList.count<3) {
        return 4;
    }else{
        return self.arr_selectedPropList.count+self.arr_selectedPieceList.count+1;
    }
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
    if (self.arr_selectedPropList.count+self.arr_selectedPieceList.count<3) {
        if (indexPath.row >= self.arr_selectedPropList.count+self.arr_selectedPieceList.count) {
            cell.iv_fragment.image = [UIImage imageNamed:@"img_exchange_addFragment"];
        }else if (indexPath.row < self.arr_selectedPieceList.count){
            PieceEntity *pieceEntity = [self.arr_selectedPieceList objectAtIndex:indexPath.row];
            [cell contentCellWithPieceEntity:pieceEntity];
        }else{
            PropertyEntity *propEntitiy = [self.arr_selectedPropList objectAtIndex:indexPath.row-self.arr_selectedPieceList.count];
            [cell contentCellWithPropertyEntity:propEntitiy];
            
        }
    }else{
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self addSubview:bg];
    
    self.v_selectFragment = [[SelectFragmentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) title:@"选择碎片或道具" buttonTitles:@[@"确认选择",@"取消"]];
    self.v_selectFragment.v_delegate = self;
    [self.v_selectFragment.select_arr removeAllObjects];
    [self.v_selectFragment.select_arr addObjectsFromArray:self.select_arr];
    [bg addSubview:_v_selectFragment];
    [_v_selectFragment showFromPoint:[self center]];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma -mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (CGRectGetMaxY(self.tv_description.frame)>self.scv_bg.frame.size.height-100) {
            [UIView animateWithDuration:0.5f animations:^{
                
                self.scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.tv_description.frame)+150);
                self.scv_bg.contentOffset = CGPointMake(0, self.scv_bg.contentOffset.y+150);
            }];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5f animations:^{
        self.scv_bg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.tv_description.frame));
    }];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.tv_description resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }

//    if (number > 29 || ![text isEqualToString:@""]) {
//        return NO;
//    }
//    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    bool isChinese;//判断当前输入法是否是中文
    if ([[[[UITextInputMode activeInputModes] firstObject] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(textView == self.tv_description) {
        // 30位
        NSString *str = [[self.tv_description text] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self.tv_description markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.tv_description positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                NSLog(@"汉字");
                if ( str.length>=31) {
                    NSString *strNew = [NSString stringWithString:str];
                    [self.tv_description setText:[strNew substringToIndex:30]];
                }
            }
            else
            {
                NSLog(@"输入的英文还没有转化为汉字的状态");
                
            }
        }else{
            if ([str length]>=31) {
                NSString *strNew = [NSString stringWithString:str];
                [self.tv_description setText:[strNew substringToIndex:30]];
            }
        }
    }
    self.lb_description.text = [NSString stringWithFormat:@"说明（%d/30）",[self.tv_description.text length]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
