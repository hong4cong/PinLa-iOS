//
//  MenuCell.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (nonatomic, strong) UIImageView       *iv_icon;
@property (nonatomic, strong) UILabel           *lb_title;
@property (nonatomic, strong) UILabel           *red_point;

- (void)setSelectedItem:(BOOL)selected;

- (void)contentWithTitleAndImageName:(NSArray *)arr;

- (void)contentWithTitleAndImageName:(NSArray *)arr isShowRedPoint:(BOOL)isShowRedPoint;

@end
