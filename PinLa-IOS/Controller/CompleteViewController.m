//
//  CompleteViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/27.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "CompleteViewController.h"
#import "CompleteView.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import "MainViewController.h"
typedef NS_ENUM(NSInteger, TYPE) {
    REGISTER,
    FORGETPASSWORD
};

@interface CompleteViewController ()

@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    
    CompleteView *v_complete = [[CompleteView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width , self.view.frame.size.height - 64)];
    [self.view addSubview:v_complete];
    [v_complete.btn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.type == FORGETPASSWORD) {
        self.title = @"完成";
        [v_complete.lb_title setText:@"请牢记你的新密码"];
        [v_complete.lb_UID removeFromSuperview];
    }else{
        self.title = @"注册完成";
        [v_complete.lb_title setText:@"注册完成"];
        [v_complete.lb_UID setText:@"您的UID为:2327348"];
    }
}

- (void)loginAction:(id)sender{
    
    [AccountHandler LoginWithAccount:self.account password:self.password prepare:^{
        [SVProgressHUD showWithStatus:@"正在登陆"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        if ([UserStorage isSwitch]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            MainViewController *vc_main = [[MainViewController alloc]init];
            [self.navigationController pushViewController:vc_main animated:YES];
        }
        
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
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
}
*/

@end
