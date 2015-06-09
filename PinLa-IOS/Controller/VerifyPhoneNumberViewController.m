//
//  RegisterViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "VerifyPhoneNumberView.h"
#import "SetPasswordViewController.h"
#import "AppUtils.h"
#import "AccountHandler.h"
#import "LoginViewController.h"

//倒计时时间（秒）
#define MAX_TIMEREMAINING 120;

@interface VerifyPhoneNumberViewController ()

@property (nonatomic,strong ) VerifyPhoneNumberView *v;
@property (nonatomic,strong ) NSString              *verify_code;
@property (nonatomic        ) int                   timeRemaining;//剩余时间
@property (nonatomic, strong) NSTimer               *  timer;

@end

@implementation VerifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    self.title = @"验证手机";
    
    self.v = [[VerifyPhoneNumberView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.v.btn_send addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.v.btn_nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.v];
}

- (void)leftBarAction:(id)sender{
    if (self.isFirstView == YES) {
        LoginViewController *vc_login = [[LoginViewController alloc]init];
        vc_login.navigationController.navigationItem.backBarButtonItem = nil;
        [self.navigationController pushViewController:vc_login animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)nextStepAction:(id)sender{
    if (self.v.tf_phone.text.length == 0 || self.v.tf_verificationCode.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请完善信息"];
        return;
    }
    
    if (self.type == FORGETPASSWORDNUMBER) {
        [AccountHandler verifyWithPhoneNum:self.v.tf_phone.text securityCode:self.v.tf_verificationCode.text prepare:^{
            [SVProgressHUD showWithStatus:@"正在核对验证码"];
        } success:^(id obj) {
            [SVProgressHUD dismiss];
            SetPasswordViewController *vc = [[SetPasswordViewController alloc]init];
            vc.type = self.type;
            vc.account = self.v.tf_phone.text;
            vc.userId = (NSString *)obj;
            [self.navigationController pushViewController:vc animated:YES];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        }];
    }else{
        SetPasswordViewController *vc = [[SetPasswordViewController alloc]init];
        vc.type = self.type;
        vc.account = self.v.tf_phone.text;
        vc.verify_Code = self.v.tf_verificationCode.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)sendAction:(id)sender{
    
    //SEAN(FIXED):这里需要验证手机号的合法性，在AppUtils里面有工具方法checkPhoneNumber
    if (![AppUtils checkPhoneNumber:self.v.tf_phone.text]) {
        [SVProgressHUD showErrorWithStatus:@"您输入的手机号不合法"];
        return;
    }
        UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//边框颜色
    
    self.timeRemaining = MAX_TIMEREMAINING;
    NSString *string = [NSString stringWithFormat:@"%d秒",self.timeRemaining];
    [button setTitle:string forState:UIControlStateDisabled];
    [self startCountDownForReauth];
    
    [AccountHandler getAuthcodeWithPhoneNum:self.v.tf_phone.text prepare:^{
        
    } success:^(id obj) {
        self.verify_code = (NSString *)obj;
    } failed:^(NSInteger statusCode, id json) {
        if(!json){
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:(NSString*)json];
        }
        
        if (_timer) {
            [_timer invalidate];
        }
        button.enabled = YES;
        [button setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_BLUE] forState:UIControlStateNormal];//边框颜色
    }];

}

//开启定时器方法
- (void)startCountDownForReauth
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(countingDownForReauthAction:)
                                            userInfo:nil
                                             repeats:YES];
}

//定时改变按钮名称方法（注：该方法每隔间隔时间都会调用一次）
- (void)countingDownForReauthAction:(NSTimer *)timer
{
    if (self.timeRemaining > 0) {
        NSString *string = [NSString stringWithFormat:@"%d秒",self.timeRemaining--];
        [self.v.btn_send setTitle:string forState:UIControlStateDisabled];
    }else{
        [timer invalidate];
        [self performSelectorOnMainThread:@selector(updateButtonStateAction:)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

//更新验证码按钮状态
-(void)updateButtonStateAction:(id)sender
{
    //先改变状态，再设置该状态下的文字显示
    self.v.btn_send.enabled = YES;
    [self.v.btn_send setTitle:@"重试" forState:UIControlStateNormal];
    [self.v.btn_send setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_BLUE] forState:UIControlStateNormal];//边框颜色
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
