//
//  BaseViewController.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/13.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL isShowRightBtn;
@property(nonatomic,assign)BOOL isNaviBarClearColor;
@property(nonatomic,assign)BOOL isNoShowLine;

- (void)initLeftBarView;
- (void)onCreate;
- (void)leftBarAction:(id)sender;
@end
