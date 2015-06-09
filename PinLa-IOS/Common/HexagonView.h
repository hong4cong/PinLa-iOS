//
//  HeaderView.h
//  IQIrregularView Demo
//
//  Created by 洪聪 on 15/4/9.
//  Copyright (c) 2015年 Canopus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HexagonView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image;

- (instancetype)initWithFrame:(CGRect)frame;

-(CAShapeLayer*)layer;

@end
