//
//  FeedbackViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "FeedbackViewController.h"
#import "GCPlaceholderTextView.h"
#import "AccountHandler.h"
#import "UITextView+ResignKeyboard.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (nonatomic,strong)GCPlaceholderTextView   *tv_feed;
@property (nonatomic,strong)UIButton     *btn_submit;

@end

@implementation FeedbackViewController

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)onCreate{
    self.title = @"反馈";
    
    UILabel *lb_demo = [[UILabel alloc]init];
    [self.view addSubview:lb_demo];
    
    self.tv_feed = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(13, 64 + 18, self.view.frame.size.width - 26, 134)];
    [self.tv_feed setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [self.tv_feed setBackgroundColor:[UIColor clearColor]];
    [self.tv_feed setPlaceholder:@"请输入您需要反馈的信息"];
    [self.tv_feed setTextColor:[UIColor colorWithHexString:COLOR_TEXT_GRAY]];
    [self.tv_feed.layer setBorderWidth:LINE_HEIGHT];
    [self.tv_feed.layer setCornerRadius:3];
    self.tv_feed.delegate = self;
    [self.tv_feed setNormalInputAccessory];
    self.tv_feed.delegate = self;
    [self.tv_feed.layer setBorderColor:[[UIColor colorWithHexString:COLOR_LINE_GRAY] CGColor]];
    [self.view addSubview:self.tv_feed];
    
    UIButton *btn_submit = [[UIButton alloc]initWithFrame:CGRectMake(8,self.view.frame.size.height - 12 - 45,self.view.frame.size.width - 16,45)];
    [btn_submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_submit.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE + 4]];
    [btn_submit setTitle:@"提交反馈" forState:UIControlStateNormal];
    UIImage *imageBack = [UIImage imageNamed:@"button_background"];
    imageBack = [imageBack stretchableImageWithLeftCapWidth:floorf(imageBack.size.width/2) topCapHeight:floorf(imageBack.size.height/2)];
    [self.btn_submit setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    [self.btn_submit setBackgroundImage:imageBack forState:UIControlStateNormal];
    [self.view addSubview:self.btn_submit];
}

- (void)submitAction:(id)sender{
    
    if (self.tv_feed.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入反馈信息"];
        return;
    }
    
    [AccountHandler feedbackWithMessage:self.tv_feed.text prepare:^{
        [SVProgressHUD showWithStatus:@"正在提交反馈"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"提交反馈失败"];
        }
    }];
    
}

<<<<<<< HEAD
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.tv_feed resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    //    if (number > 29 || ![text isEqualToString:@""]) {
    //        return NO;
    //    }
    //
    return YES;
=======
- (void)textViewDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_submit setFrame:CGRectMake(8,self.view.frame.size.height - 12 - 45,self.view.frame.size.width - 16,45)];
    }];
}

- (void)textViewDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.15 animations:^{
        [self.btn_submit setFrame:CGRectMake(8,234,self.view.frame.size.width - 16,45)];
    }];
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
>>>>>>> 431c391d98e9991b514c8cbe680a2837a5c2a058
}

@end
