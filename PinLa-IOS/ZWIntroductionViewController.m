//
//  LGIntroductionViewController.m
//  ladygo
//
//  Created by square on 15/1/21.
//  Copyright (c) 2015年 ju.taobao.com. All rights reserved.
//

#import "ZWIntroductionViewController.h"

@interface ZWIntroductionViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray           *backgroundViews;
@property (nonatomic, strong) NSArray           *scrollViewPages;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, assign) NSInteger         centerPageIndex;

@end

@implementation ZWIntroductionViewController

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames button:(UIButton *)button
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backgroundImageNames = bgNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackgroundViews];
    
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    self.pagingScrollView.bounces = NO;
    
    [self.view addSubview:self.pagingScrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    
    UIButton *btn_next = [[UIButton alloc]initWithFrame:CGRectMake(250, 39, 70, 20)];
    btn_next.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    [btn_next setTitle:@"跳过 >" forState:UIControlStateNormal];
    [btn_next setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [btn_next addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_next];

    self.btn_register = [[UIButton alloc]initWithFrame:CGRectMake(8,382, self.view.frame.size.width - 16, 50)];
    self.btn_register.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn_register.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    [self.btn_register setTitle:@"注册" forState:UIControlStateNormal];
    [self.btn_register addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_register setBackgroundImage:[UIImage imageNamed:@"BG Bottom"] forState:UIControlStateNormal];
    [self.view addSubview:self.btn_register];
    self.btn_register.alpha = 0;
    
    self.btn_login = [[UIButton alloc]initWithFrame:CGRectMake(8,CGRectGetMaxY(self.btn_register.frame) + 2, self.view.frame.size.width - 16, 50)];
    [self.btn_login setBackgroundImage:[UIImage imageNamed:@"BG Top"] forState:UIControlStateNormal];
    self.btn_login.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn_login.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    [self.btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [self.btn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn_login];
    self.btn_login.alpha = 0;
    
    self.btn_experience = [[UIButton alloc]initWithFrame:CGRectMake(8,382 + 26, self.view.frame.size.width - 16, 50)];
    [self.btn_experience setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    self.btn_experience.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btn_experience.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    [self.btn_experience setTitle:@"立即体验" forState:UIControlStateNormal];
    [self.btn_experience addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_experience setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn_experience];
    self.btn_experience.alpha = 0;
    
    [self reloadPages];
}

- (void)registerAction:(id)sender{
    [self.delegate goToRegisterView];
}

- (void)loginAction:(id)sender{
    [self.delegate goToLoginView];
}

- (void)addBackgroundViews
{
    CGRect frame = self.view.bounds;
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self backgroundImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        [self.view addSubview:imageView];
    }];

    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)reloadPages
{
    self.pageControl.numberOfPages = [[self coverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];
    
    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.pagingScrollView addSubview:obj];
        
        x += obj.frame.size.width;
    }];

    // fix enterButton can not presenting if ScrollView have only one page
    if (self.pageControl.numberOfPages == 1) {
        self.enterButton.alpha = 1;
        self.btn_register.alpha = 1;
        self.btn_login.alpha = 1;
        self.pageControl.alpha = 0;
        self.btn_experience.alpha = 1;

    }
    
    // fix ScrollView can not scrolling if it have only one page
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 65, self.view.bounds.size.width, 30);
}

- (CGRect)frameOfEnterButton
{
    CGSize size = self.enterButton.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.6, 40);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height, size.width, size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
    
    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
    
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    
    [self pagingScrollViewDidChangePages:scrollView];
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
//        if (![self hasNext:self.pageControl]) {
//            [self enter:nil];
//        }
//    }
//}

#pragma mark - UIScrollView & UIPageControl DataSource

- (BOOL)hasNext:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self coverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.enterButton.alpha = 0;
            self.btn_register.alpha = 0;
            self.btn_login.alpha = 0;
            self.btn_experience.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 1;
                self.btn_register.alpha = 1;
                self.btn_login.alpha = 1;
                self.pageControl.alpha = 0;
                self.btn_experience.alpha = 1;
            }];
        }
    } else {
        if (self.pageControl.alpha == 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 0;
                self.btn_register.alpha = 0;
                self.btn_login.alpha = 0;
                self.pageControl.alpha = 1;
                self.btn_experience.alpha = 0;
            }];
        }
    }
}

- (BOOL)hasEnterButtonInView:(UIView*)page
{
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && obj == self.enterButton) {
            result = YES;
        }
    }];
    return result;
}

- (UIImageView*)scrollViewPage:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize size = {[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

- (NSArray*)scrollViewPages
{
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageView *v = [self scrollViewPage:obj];
        [tmpArray addObject:v];
        
    }];
    
    _scrollViewPages = tmpArray;
    
    return _scrollViewPages;
}

- (CGSize)contentSizeOfScrollView
{
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}

#pragma mark - Action

- (void)enter:(id)object
{
    [self.delegate setRootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end