//
//  SoftwareInformationViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SoftwareInformationViewController.h"
#import "SoftwareInfoView.h"

@interface SoftwareInformationViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView* webView;
@property (nonatomic, strong) SoftwareInfoView *v_version;
@property (nonatomic, strong) SoftwareInfoView *v_companyName;
@property (nonatomic, strong) SoftwareInfoView *v_website;

@end

@implementation SoftwareInformationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    //    [self.view addSubview:_webView];
    
    NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.v_version = [[SoftwareInfoView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 74) title:@"版本号" content:[NSString stringWithFormat:@"v%@",versionStr]];
    [self.view addSubview:self.v_version];
    
    self.v_companyName = [[SoftwareInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_version.frame), CGRectGetWidth(self.view.frame), 69) title:@"公司名" content:@"10lab"];
    [self.view addSubview:self.v_companyName];
    
    self.v_website = [[SoftwareInfoView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.v_companyName.frame),CGRectGetWidth(self.view.frame), 69) title:@"网址" content:@"10lab.in"];
    [self.view addSubview:self.v_website];
    
}

//- (void)initLeftBarView
//{
//    UIImage *image = [UIImage imageNamed:@"side_menu"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(leftBarAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//    
//}

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

-(void)dealloc
{
    [_webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)onCreate
{
    self.title = @"信息";
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
