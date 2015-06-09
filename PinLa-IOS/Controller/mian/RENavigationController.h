//
//  RENavigationController.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/27.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RENavigationDelegate <NSObject>

- (void)addMenuPanGesture;
- (void)removeMenuPanGesture;
- (void)popToViewController:(id)viewController;

@end

@interface RENavigationController : UINavigationController<RENavigationDelegate>

- (void)showMenu;

- (void)addMenuPanGesture;

- (void)removeMenuPanGesture;

@end
