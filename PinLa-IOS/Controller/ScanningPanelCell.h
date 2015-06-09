//
//  ScanningPanelCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonView.h"

@class PieceEntity;

@interface ScanningPanelCell : UITableViewCell
@property (nonatomic,strong) UIImageView    *iv_avatar;
@property (nonatomic,strong) UILabel        *lb_name;
@property (nonatomic,strong) UILabel        *lb_detail;
@property (nonatomic,strong) UIButton    *iv_icon;

- (void)contentDataWithEntity:(PieceEntity*)entity;

@end
