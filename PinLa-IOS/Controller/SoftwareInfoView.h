//
//  SoftwareInfoView.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/5/17.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftwareInfoView : UIView

@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UILabel       *lb_content;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content;

@end
