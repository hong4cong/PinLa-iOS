//
//  BaseViewController.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/13.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    if (!_isNaviBarClearColor) {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    }else{
//        [self.navigationController.navigationBar lt_reset];
//    }
    [self initLeftBarView];
    if (_isShowRightBtn) {
        [self initRightBarView];
    }
    [self onCreate];
}

- (void)initLeftBarView
{
    UIImage *image = [UIImage imageNamed:@"img_back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)initRightBarView
{
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    [btn_right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:COLOR_BUTTON_MAIN]} forState:UIControlStateNormal];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.rightBarButtonItem = btn_right;
}

- (void)leftBarAction:(id)sender{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarAction:(id)sender{
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onCreate
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    if (![[self.navigationController viewControllers] containsObject: self])
    {
        // the view has been removed from the navigation stack, back is probably the cause
        // this will be slow with a large stack however.
        [SVProgressHUD dismiss];
    }
}

- (void)setIsNoShowLine:(BOOL)isShowLine
{
//    [self.navigationController.navigationBar setIsShowLine:isShowLine];
    _isNoShowLine = isShowLine;
}

@end
