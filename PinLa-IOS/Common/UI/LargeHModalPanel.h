//
//  LargeHModalPanel.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/22.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HModalPanel.h"

typedef NS_ENUM(NSUInteger, LargeHMPButtonType) {
    LargeHMPButtonTypeLeft,
    LargeHMPButtonTypeRight
};

@protocol LargeHModalPanelDelegate <NSObject>

- (void)modelView:(UIView *)modelView clickBottomButtonAction:(LargeHMPButtonType)buttonType;
- (void)modelView:(UIView *)modelView goBackAction:(id)sender;

@end

@interface LargeHModalPanel : HModalPanel

@property (nonatomic, weak)   id<LargeHModalPanelDelegate> delegate;

@property (nonatomic, strong) UILabel       *lb_title;
@property (nonatomic, strong) UIView        *line;
@property (nonatomic, strong) UIButton      *btn_back;
@property (nonatomic, strong) UIButton      *btn_bottomLeft;
@property (nonatomic, strong) UIButton      *btn_bottomRight;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles;

@end
