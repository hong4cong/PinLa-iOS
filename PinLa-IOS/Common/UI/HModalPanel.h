//
//  HModalPanel.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/20.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HModalPanel;

@protocol HModalPanelDelegate
@optional
- (void)willCloseModalPanel:(HModalPanel *)modalPanel;
- (void)didCloseModalPanel:(HModalPanel *)modalPanel;
@end

@interface HModalPanel : UIView
{
    CGPoint			startEndPoint;
}

@property(nonatomic,assign) NSObject<HModalPanelDelegate>	*delegate;
@property(nonatomic,assign)UIEdgeInsets margin;
@property(nonatomic,assign)UIEdgeInsets padding;
@property(nonatomic,strong)UIView       *contentView;

- (CGRect)contentViewFrame;
- (CGRect)roundedRectFrame;

- (void)updateFrames;

- (void)show;
- (void)showFromPoint:(CGPoint)point;
- (void)hide;

@end
