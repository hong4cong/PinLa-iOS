//
//  UITextView+ResignKeyboard.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/15.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "UITextView+ResignKeyboard.h"

@implementation UITextView (ResignKeyboard)

- (void)setNormalInputAccessory
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    [topView setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [topView setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone  target:self action:@selector(hideKeyboard)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"img_keyboard_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    doneButton.tintColor = [UIColor colorWithHexString:@"#2BFEBB"];
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButton,doneButton,spaceButton,nil];
    [topView setItems:buttonsArray];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self setInputAccessoryView:topView];
}

- (void)setNormalInputAccessoryTarget:(id)target action:(SEL)action
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone  target:target action:action];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"img_keyboard_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    doneButton.tintColor = [UIColor colorWithHexString:@"#2BFEBB"];
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButton,doneButton,spaceButton,nil];
    [topView setItems:buttonsArray];
    [topView setBackgroundColor:[UIColor blackColor]];
    [self setInputAccessoryView:topView];
}

- (void)hideKeyboard{
    [self resignFirstResponder];
}

@end
