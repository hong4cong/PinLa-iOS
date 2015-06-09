//
//  BackpackCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonView.h"
#import "ImageLableView.h"
#import "BackpackEntity.h"
@interface BackpackCell : UITableViewCell

@property (nonatomic,strong) UIImageView    *iv_avatar;
@property (nonatomic,strong) UILabel        *lb_name;
@property (nonatomic,strong) ImageLableView *iv_allNumber;
@property (nonatomic,strong) ImageLableView *iv_loackedNumber;
@property (nonatomic,strong) UIImageView    *iv_icon;

- (void)contentDataWithPieceEntity:(NSMutableArray *)arr_entity;

- (void)contentDataWithPropertyEntity:(NSMutableArray *)arr_entity;

@end
