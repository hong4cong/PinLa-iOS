//
//  LGIntroductionViewController.h
//  ladygo
//
//  Created by square on 15/1/21.
//  Copyright (c) 2015年 ju.taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWIntroductionViewControllerDelegate <NSObject>

- (void)setRootView;
- (void)goToLoginView;
- (void)goToRegisterView;

@end

@interface ZWIntroductionViewController : UIViewController
@property (nonatomic, strong) UIButton   *btn_register;
@property (nonatomic, strong) UIButton   *btn_login;
@property (nonatomic, strong) UIButton   *btn_experience;


@property (nonatomic, strong) UIScrollView *pagingScrollView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, assign) id<ZWIntroductionViewControllerDelegate>delegate;

//@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 @[@"image1", @"image2"]
 */
@property (nonatomic, strong) NSArray *backgroundImageNames;

/**
 @[@"coverImage1", @"coverImage2"]
 */
@property (nonatomic, strong) NSArray *coverImageNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

@end
