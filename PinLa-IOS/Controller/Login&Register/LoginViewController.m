//
//  LoginViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/8.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "LoginViewController.h"
#import "VerifyPhoneNumberViewController.h"
#import "VerifyPhoneNumberViewController.h"
#import "AccountHandler.h"
#import "MainViewController.h"
#import "UserStorage.h"
#import <XGPush/XGPush.h>
#import <XGPush/XGSetting.h>


@implementation LoginViewController

- (void)viewDidLoad
{
    self.isShowRightBtn = YES;
    [super viewDidLoad];
}

-(void)onCreate
{
    self.title = @"登录";
    
    //Initial view
    self.v = [[LoginView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.v.btn_login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.v.btn_forgetPassword addTarget:self action:@selector(findPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.v];
    //注册按钮
    [self.v.btn_register addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *btn_register = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerAction:)];
    [btn_register setTintColor:[UIColor colorWithHexString:COLOR_MAIN]];
    self.navigationItem.rightBarButtonItem = btn_register;
    self.navigationItem.backBarButtonItem = nil;
    
}

- (void)initLeftBarView
{
    [self.navigationItem setHidesBackButton:YES];
}

- (void)findPasswordAction:(id)sender{
    VerifyPhoneNumberViewController *vc = [[VerifyPhoneNumberViewController alloc]init];
    vc.type = FORGETPASSWORD;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)login:(id)sender
{
    if (self.v.tf_phone.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    if (self.v.tf_password.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    [AccountHandler LoginWithAccount:self.v.tf_phone.text password:self.v.tf_password.text prepare:^{
        [SVProgressHUD showWithStatus:@"正在登陆"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        if ([UserStorage isSwitch]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            MainViewController *vc_main = [[MainViewController alloc]init];
            [self.navigationController pushViewController:vc_main animated:YES];
        }
        
        [XGPush startApp:2200109642 appKey:@"IJL97AP29R3R"];
        
        //注销之后需要再次注册前的准备
        void (^successCallback)(void) = ^(void){
            //如果变成需要注册状态
            if(![XGPush isUnRegisterStatus])
            {
                //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
                
                float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
                if(sysVer < 8){
                    [self registerPush];
                }
                else{
                    [self registerPushForIOS8];
                }
#else
                //iOS8之前注册push方法
                //注册Push服务，注册后才能收到推送
                [self registerPush];
#endif
            }
        };
        [XGPush initForReregister:successCallback];
        
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
    }];
}


- (void)registerAction:(id)sender
{
    VerifyPhoneNumberViewController *vc = [[VerifyPhoneNumberViewController alloc]init];
    vc.type = REGISTER;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 信鸽

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}
@end
