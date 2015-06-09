//  内购项目Cell
//  PurchaseCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseEntity.h"

@interface PurchaseCell : UITableViewCell

@property (nonatomic, strong) HexagonView       *hv_commodity;//商品图片
@property (nonatomic, strong) UILabel           *lb_title;
@property (nonatomic, strong) UILabel           *lb_description;
@property (nonatomic, strong) UIButton          *btn_price;


- (void)contentWithPurchaseEntity:(PurchaseEntity *)purchaseEntity;

@end
