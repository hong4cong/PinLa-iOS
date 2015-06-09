//
//  AddRelationViewController.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AddRelationViewController.h"
#import "AddRelationView.h"
#import "AddressBookViewController.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>

@interface AddRelationViewController ()<AddRelationViewDelegate>

@property (nonatomic, strong) AddRelationView *v;
@property (nonatomic, strong) UserEntity *userEntity;

@end

@implementation AddRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)onCreate{
    self.title = @"加关注";
    

    _v = [[AddRelationView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 64)];
    _v.delegate = self;
    _v.v_user.lb_nickname.text = @"小毛驴";
    _v.v_user.iv_status.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addRelationAction)];
    [_v.v_user.iv_status addGestureRecognizer:singleTap1];
    [self.view addSubview:_v];
}

#pragma -mark AddRelationViewDelegate

- (void)addRelationFromContactAction:(id)sender{
    AddressBookViewController *vc_addressBook = [[AddressBookViewController alloc]init];
    [self.navigationController pushViewController:vc_addressBook animated:YES];
}

- (void)addRelationFromWchatAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"该功能暂未实现,敬请期待" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
//    NSString* path = [[NSBundle mainBundle]pathForResource:@"ShareSDK" ofType:@"jpg"];
//    id<ISSContent> publishContent = [ShareSDK content:@"Hello,Code4App.com!" defaultContent:nil image:[ShareSDK imageWithPath:path] title:@"This is title" url:@"http://mob.com" description:@"This is description" mediaType:SSPublishContentMediaTypeNews];
//    //2.分享
//    [ShareSDK showShareViewWithType:ShareTypeWeixiSession container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        //如果分享成功
//        if (state == SSResponseStateSuccess) {
//            NSLog(@"分享成功");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        //如果分享失败
//        if (state == SSResponseStateFail) {
//            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        if (state == SSResponseStateCancel){
//            NSLog(@"分享取消");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code4App" message:@"进入了分享取消状态" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//    }];
}

- (void)searchAction:(id)sender{
 
    [self.v addSubview:self.v.v_background];
    [self.v addSubview:self.v.bg_color];
    if (_v.tf_UID.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入UID"];
        return;
    }
    [AccountHandler getUserInfoWithUserId:[UserStorage userId] otherUserId:_v.tf_UID.text prepare:^{
        [SVProgressHUD showWithStatus:@"正在获取用户信息"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [_v.v_background addSubview:_v.v_user];
        [_v.lb_memo removeFromSuperview];
        self.userEntity = (UserEntity *)obj;
        [_v.v_user contentWithRelationEntity:(UserEntity *)obj];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
        }
        [_v.v_user removeFromSuperview];
        [_v.v_background addSubview:_v.lb_memo];
        [_v.lb_memo setText:@"查无此用户,请检查您输入的UID是否有误"];
        [_v.lb_memo setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }];
}

- (void)addRelationAction{
    
    [AccountHandler followerUserId:[UserStorage userId] otherUserIdList:@[self.userEntity.user_id] prepare:^{
        [SVProgressHUD showWithStatus:@"正在添加关注"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"添加关注失败"];
        }
    }];
}

- (void)setContentWithUserEntity:(UserEntity *)userEntity{
    [self.v addSubview:self.v.v_background];
    [self.v addSubview:self.v.bg_color];
    [_v.v_background addSubview:_v.v_user];
    [_v.lb_memo removeFromSuperview];
    self.userEntity = userEntity;
    [_v.v_user contentWithRelationEntity:userEntity];
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
