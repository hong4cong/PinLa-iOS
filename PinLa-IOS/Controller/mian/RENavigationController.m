//
//  RENavigationController.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/27.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "RENavigationController.h"
#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "LoginViewController.h"
#import "LiftButton.h"
#import "UserStorage.h"

@interface RENavigationController ()<UIGestureRecognizerDelegate>

@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;
@property(nonatomic,strong)UIPanGestureRecognizer* panGesture;

@end

@implementation RENavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    
    self.panGesture.delegate = self;
    
}

- (void)showMenu
{
    if (![UserStorage isLogin]) {
        LoginViewController* controller = [[LoginViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

- (void)addMenuPanGesture
{
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)removeMenuPanGesture
{
    [self.view removeGestureRecognizer:self.panGesture];
}


#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    NSLog(@"panGestureRecognized");
    if (!YES) {
        return;
    }
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController panGestureRecognized:sender];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
