//
//  HAlertView.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/28.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HAlertBtnType) {
    HAlertBtnConfirm,
    HAlertBtnCancel
};

@class HAlertView;

@protocol HAlertViewDelegate <NSObject>

-(void)alertView:(HAlertView *)alertView buttonType:(HAlertBtnType)btnType;

@end

@interface HAlertView : UIView

@property(nonatomic,assign)id<HAlertViewDelegate> delegate;

@property(nonatomic,strong)UIButton*            confirmBtn;
@property(nonatomic,strong)UIButton*            cancelBtn;

@property(nonatomic,assign)CGFloat              titleFontSize;
@property(nonatomic,assign)CGFloat              msgFontSize;
@property(nonatomic,assign)NSString*            msgColor;

@property(nonatomic)       NSTextAlignment    msgTextAlignment;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<HAlertViewDelegate>*/)delegate cancelBtnTitle:(NSString *)cancelBtnTitle confirmBtnTitle:(NSString *)confirmBtnTitle;
- (void)show;
- (void)dismiss;

@end
