//  动态Cell
//  DynamicCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicEntity.h"

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) UIImageView       *iv_status;//动态状态
@property (nonatomic, strong) UILabel           *lb_description;//动态描述
@property (nonatomic, strong) UILabel           *lb_time;//动态时间
//@property (nonatomic, strong)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;

- (void)contentWithDynamicEntity:(DynamicEntity *)dynamicEntity;

@end
