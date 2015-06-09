//
//  MessageTypeTwoCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/29.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"
@interface MessageTypeTwoCell : UITableViewCell
@property (nonatomic,strong) UIImageView *iv_avatar;
@property (nonatomic,strong) UILabel     *lb_title;
@property (nonatomic,strong) UILabel     *lb_time;
@property (nonatomic,strong) UIButton    *btn_detailAction;
@property (nonatomic,strong) UIButton    *btn_delete;
@property (nonatomic,strong) UILabel     *lb_detail;
- (void)contentMessageWithMessageEntity:(MessageEntity *)messageEntity;
@end
