//
//  InsetsTextField.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/14.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsTextField : UITextField

- (instancetype)initWithLeftMargin:(CGFloat)leftMargin;

- (instancetype)initWithFrame:(CGRect)frame leftMargin:(CGFloat)leftMargin;

- (instancetype)initWithFrame:(CGRect)frame leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

@end
