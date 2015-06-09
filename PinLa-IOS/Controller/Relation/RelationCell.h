//
//  RelationCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface RelationCell : UITableViewCell

@property (nonatomic, strong) HexagonView   *hv_avatar;
@property (nonatomic, strong) UILabel       *lb_nickname;
@property (nonatomic, strong) UIImageView   *iv_status;

- (void)contentWithRelationEntity:(UserEntity *)userEntity;

@end
