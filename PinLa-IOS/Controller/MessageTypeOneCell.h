//
//  MessageTypeOneCell.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/29.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonView.h"
#import "MessageEntity.h"
@interface MessageTypeOneCell : UITableViewCell
@property (nonatomic,strong) HexagonView *iv_avatar;
@property (nonatomic,strong) UILabel     *lb_title;
@property (nonatomic,strong) UILabel     *lb_time;
@property (nonatomic,strong) UIButton    *btn_detailAction;
@property (nonatomic,strong) UIButton    *btn_delete;

- (void)contentMessageWithMessageEntity:(MessageEntity *)messageEntity;
@end
