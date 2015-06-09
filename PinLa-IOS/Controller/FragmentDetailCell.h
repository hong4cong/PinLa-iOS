//
//  FragmentDetailCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonView.h"
#import "ImageLableView.h"
#import "BackpackEntity.h"

@class PieceNumberingEntity;

@interface FragmentDetailCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iv_avatar;
@property (nonatomic,strong) UILabel     *lb_name;
@property (nonatomic,strong) UILabel     *lb_detail;
@property (nonatomic,strong) ImageLableView *iv_allNumber;
@property (nonatomic,strong) ImageLableView *iv_loackedNumber;

- (void)contentBackpackWithBackpackEntity:(BackpackEntity *)backpackEntity;

- (void)contentDataWithPieceEntity:(NSArray *)arr_data;

- (void)contentWithPieceNumberingEntity:(PieceNumberingEntity*)entity row:(NSInteger)row;

@end
