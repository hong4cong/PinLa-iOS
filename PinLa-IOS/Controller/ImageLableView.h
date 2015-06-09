//
//  LockedView.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/23.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLableView : UIView

@property (nonatomic,strong)UIImageView *iv_icon;
@property (nonatomic,strong)UILabel     *lb_number;

- (void)setLableText:(NSString *)str;

@end
