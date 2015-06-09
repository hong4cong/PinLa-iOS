//
//  AddressBookCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonView.h"
#import "UserEntity.h"
@interface AddressBookCell : UITableViewCell
@property (nonatomic, strong) HexagonView   *hv_avatar;
@property (nonatomic, strong) UILabel       *lb_nickname;
@property (nonatomic, strong) UIImageView   *iv_status;
- (void)contentAddressBookWithUserEntity:(UserEntity *)userEntity;
@end
