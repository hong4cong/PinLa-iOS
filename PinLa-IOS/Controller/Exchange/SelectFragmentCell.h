//  选择碎片Cell
//  SelectFragmentCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/6.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyEntity.h"
#import "PieceEntity.h"

@interface SelectFragmentCell : UITableViewCell

@property (nonatomic, strong) UIImageView       *iv_fragment;
@property (nonatomic, strong) UILabel           *lb_title;
@property (nonatomic, strong) UILabel           *lb_detail;
@property (nonatomic, strong) UIButton          *btn_select;

- (void)contentCellWithPropertyEntity:(PropertyEntity *)propertyEntity;

- (void)contentCellWithPieceEntity:(PieceEntity *)pieceEntity;

@end
