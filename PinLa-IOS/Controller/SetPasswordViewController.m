//
//  ForgetPasswordViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/13.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "CompleteViewController.h"
#import "AccountHandler.h"
@interface SetPasswordViewController ()

@property (nonatomic,strong)SetPasswordView  *v;
@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    
    if (self.type == FORGETPASSWORDNUMBER) {
        self.title = @"修改密码";
    }else{
        self.title = @"设置密码";
    }
    
    self.v = [[SetPasswordView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.v.btn_submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.v];
}

- (void)submitAction:(id)sender{
    
    if(![self.v.tf_newPassword.text isEqualToString:self.v.tf_confirmPassword.text]){
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    if(!(self.v.tf_confirmPassword.text.length >= 8 && self.v.tf_confirmPassword.text.length <= 16)){
        [SVProgressHUD showErrorWithStatus:@"请输入8-16位密码"];
        return;
    }
    
    if (self.type == REGISTERNUMBER) {
        [AccountHandler verifyRegisterInformationWithAccount:self.account password:self.v.tf_confirmPassword.text verify_code:self.verify_Code prepare:^{
            [SVProgressHUD showWithStatus:@"正在提交"];
        } success:^(id obj) {
            [SVProgressHUD dismiss];
            CompleteViewController *vc_complete = [[CompleteViewController alloc]init];
            vc_complete.type = self.type;
            vc_complete.account = self.account;
            vc_complete.password = self.v.tf_confirmPassword.text;
            if (obj) {
                vc_complete.userID = (NSString*)obj;
            }
            [self.navigationController pushViewController:vc_complete animated:YES];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        }];
    }else{
        [AccountHandler modifyUserId:self.userId password:self.v.tf_confirmPassword.text  prepare:^{
            [SVProgressHUD showWithStatus:@"正在提交"];
        } success:^(id obj) {
            [SVProgressHUD dismiss];
            CompleteViewController *vc_complete = [[CompleteViewController alloc]init];
            vc_complete.account = self.account;
            vc_complete.password = self.v.tf_confirmPassword.text;
            vc_complete.type = self.type;
            [self.navigationController pushViewController:vc_complete animated:YES];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        }];
    }
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
