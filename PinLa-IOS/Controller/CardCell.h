//
//  CardCell.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/6.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardEntity;

@interface CardCell : UITableViewCell

@property (nonatomic,strong) UIImageView    *iv_icon;
@property (nonatomic,strong) UILabel        *lb_title;
@property (nonatomic,strong) UILabel        *lb_dec;
@property (nonatomic,strong) UILabel        *lb_cardNum;

@property (nonatomic,strong) UILabel        *lb_time;

- (void)contentWithCardEntity:(CardEntity*)cardEntity;

@end
