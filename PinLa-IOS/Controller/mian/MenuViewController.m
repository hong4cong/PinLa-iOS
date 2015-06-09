//
//  MenuViewController.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/27.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "MenuViewController.h"
#import "RENavigationController.h"
#import "HexagonView.h"
#import "MenuCell.h"
#import "ProfileViewController.h"
#import "AttentionListController.h"
#import "PurchaseListController.h"
#import "BackpackViewController.h"
#import "ExchangeViewController.h"
#import "ProfileViewController.h"
#import "FeedbackViewController.h"
#import "UserStorage.h"
#import <UIImageView+WebCache.h>
#import "AccountHandler.h"
#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "UserStorage.h"
#import "SoftwareInformationViewController.h"

@interface MenuViewController ()<UIAlertViewDelegate>

typedef void (^CompletionHandler)(void);

@property(nonatomic,strong)UILabel *lb_nickname;
@property(nonatomic,strong)UIButton *btn_profile;
@property(nonatomic,strong)UIButton *btn_quit;
@property(nonatomic,strong)HexagonView *avatarImageView;

@property (nonatomic,strong) NSArray       *arr_titlesAndImages;
@property (nonatomic,assign)REFrostedViewController* myFrostedViewController;

@property (nonatomic,assign)BOOL isShowBackageRedPoint;

@property(nonatomic,strong)UILabel* lb_UID;

@property(nonatomic,assign)NSInteger selectRow;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNSNotification];
    self.navigationController.navigationBarHidden = NO;
    self.myFrostedViewController = self.frostedViewController;
    
    self.arr_titlesAndImages = @[
                                 @[@"地图",@"img_menu_location_green",@"img_menu_location"],
                                 @[@"背包",@"img_menu_package_green",@"img_menu_package"],
                                 @[@"交换",@"img_menu_exchange_green",@"img_menu_exchange"],
                                 @[@"关注",@"img_menu_attention_green",@"img_menu_attention"],
//                                 @[@"升级",@"img_menu_upgrade_green",@"img_menu_upgrade"],
                                 @[@"反馈",@"img_menu_feedback_green",@"img_menu_feedback"]
                                 ];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor colorWithHexString:COLOR_LINE_GRAY];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180)];
        _avatarImageView = [[HexagonView alloc] initWithFrame:CGRectMake(81, 20+36, 66, 66) image:[UIImage imageNamed:@"img_common_defaultAvatar"]];
        
//        _avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        _avatarImageView.clipsToBounds = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarInvoked:)];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:gesture];
        [view addSubview:_avatarImageView];
        
        self.btn_profile = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_profile.frame = CGRectMake(CGRectGetMinX(_avatarImageView.frame)-26-36, 63+10, 36, 36);
        [self.btn_profile setBackgroundImage:[UIImage imageNamed:@"img_menu_setting"] forState:UIControlStateNormal];
        [self.btn_profile addTarget:self action:@selector(showMyProfile:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.btn_profile];
        
        self.btn_quit = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_quit.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+26, 63+10, 36, 36);
        [self.btn_quit setBackgroundImage:[UIImage imageNamed:@"img_menu_quit"] forState:UIControlStateNormal];
        [self.btn_quit addTarget:self action:@selector(quitAppAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.btn_quit];

        self.lb_nickname = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_avatarImageView.frame)+12, 230, 19)];
        
        self.lb_nickname.text = [UserStorage userNickName];
        self.lb_nickname.textColor = [UIColor colorWithHexString:COLOR_TEXT_LARGER];
        self.lb_nickname.textAlignment = NSTextAlignmentCenter;
        self.lb_nickname.font = [UIFont systemFontOfSize:FONT_SIZE+5];
        [view addSubview:self.lb_nickname];
        
        _lb_UID = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lb_nickname.frame)+3, 230, 20)];
        _lb_UID.font = [UIFont systemFontOfSize:FONT_SIZE+2];
        _lb_UID.textAlignment = NSTextAlignmentCenter;
        _lb_UID.textColor = [UIColor whiteColor];
        _lb_UID.text = [UserStorage userId];
//        [view addSubview:_lb_UID];
        
//        UIView* bottomLine = [UIView new];
//        bottomLine.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
//        bottomLine.frame = CGRectMake(70, CGRectGetHeight(view.frame)-LINE_HEIGHT, CGRectGetWidth(self.view.frame)-70, LINE_HEIGHT);
//        [view addSubview:bottomLine];
        
        view;
    });
    
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
        
        UIButton *btn_tip = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_tip.frame = CGRectMake(27, 70, 30, 30);
        [btn_tip setBackgroundImage:[UIImage imageNamed:@"img_menu_tip"] forState:UIControlStateNormal];
        [btn_tip addTarget:self action:@selector(showTipAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_tip];

        view;
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserStorage userIcon]] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    
    self.lb_nickname.text = [UserStorage userNickName];
    [self.tableView reloadData];
}

-(void)dealloc
{
    [self removeNSNotification];
}

- (void)addNSNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:NOTI_LOGIN_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUsageMode:)
                                                 name:NOTI_LOGOUT
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(piecePickupSuccess:)
//                                                 name:NOTI_PICKUP_PIECE_SUCCESS
//                                               object:nil];
}

- (void)removeNSNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_LOGOUT object:nil];
}

- (void)loginSuccess:(NSNotification*)noti
{
//    self.label.text = [AppUtils hidePhoneNumber:[UserStorage phoneNumber]];
}


- (void)avatarInvoked:(id)sender
{
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    [((RENavigationController*)self.myFrostedViewController.contentViewController) pushViewController:vc animated:YES];
    [self.myFrostedViewController hideMenuViewController];
}

#pragma mark - button action
- (void)quitAppAction:(id)sender
{
    
    //需要强制升级
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出登录？"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)showMyProfile:(UIButton *)sender{
    UserProfileViewController *vc = [[UserProfileViewController alloc] init];
    [((RENavigationController*)self.myFrostedViewController.contentViewController) pushViewController:vc animated:YES];
    [self.myFrostedViewController hideMenuViewController];
}

- (void)showTipAction:(UIButton *)sender{
    SoftwareInformationViewController *vc = [[SoftwareInformationViewController alloc] init];
    [((RENavigationController*)self.myFrostedViewController.contentViewController) pushViewController:vc animated:YES];
    [self.myFrostedViewController hideMenuViewController];

}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.arr_titlesAndImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_GREEN];
        cell.selectedBackgroundView = selectedBackgroundView;
    }
    
    
    if (_selectRow == indexPath.row) {
        [cell setSelectedItem:YES];
    }else{
        [cell setSelectedItem:NO];
    }
    
    if (indexPath.section == 0) {
        if([UserStorage isShowBackageRedPoint] && indexPath.row == 1){
            [cell contentWithTitleAndImageName:[self.arr_titlesAndImages objectAtIndex:indexPath.row] isShowRedPoint:YES];
        }else{
            [cell contentWithTitleAndImageName:[self.arr_titlesAndImages objectAtIndex:indexPath.row]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    _selectRow = indexPath.row;
    UIViewController * vc = nil;
    switch (indexPath.row) {
        case 0:{
            vc = [[MainViewController alloc]init];
        }
            break;
        case 1:{
            vc = [[BackpackViewController alloc]init];
            
            [UserStorage saveIsShowBackageRedPoint:NO];
        }
            break;
        case 2:{
            vc = [[ExchangeViewController alloc]init];
        }
            break;
        case 3:{
            vc = [[AttentionListController alloc] init];
        }
            break;
//        case 4:{
//            vc = [[PurchaseListController alloc] init];
//        }
            break;
        case 4:{
            vc = [[FeedbackViewController alloc] init];
        }
            break;
        default:
            break;
    }
    if (vc) {
        [((RENavigationController*)self.myFrostedViewController.contentViewController) pushViewController:vc animated:YES];
    }
    
    [self.myFrostedViewController hideMenuViewController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MainViewController* vc = [[MainViewController alloc]init];
        
        if (vc) {
            [((RENavigationController*)self.myFrostedViewController.contentViewController) pushViewController:vc animated:YES];
        }
        
        [self.myFrostedViewController hideMenuViewController];
        [AccountHandler logoutWithCoordinate:[UserStorage userCoordinate] prepare:^{
            [SVProgressHUD showWithStatus:@"正在退出登录"];
        } success:^(id obj) {
            [UserStorage saveSwithStatus:YES];
            LoginViewController *vc_login = [[LoginViewController alloc]init];
            UINavigationController *nav= [[UINavigationController alloc]initWithRootViewController:vc_login];
            [self presentViewController:nav animated:YES completion:nil];
            [UserStorage saveLoginStatus:NO];
            [UserStorage saveToken:nil];
            [UserStorage saveUserId:nil];
            [UserStorage saveUserNickName:nil];
            [UserStorage saveUserIcon:nil];
            [UserStorage savePhysicalTime:0];
            [UserStorage savePhysical:0];
            [UserStorage saveIsShowBackageRedPoint:NO];
            [UserStorage saveRadiiTime:0];
            [UserStorage saveHotspotPolyEntity:nil];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"退出登录失败"];
            }
        }];
    }
}
@end
