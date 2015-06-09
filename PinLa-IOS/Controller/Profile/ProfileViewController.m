//
//  ProfileViewController.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "DynamicCell.h"
#import "PropertyCell.h"
#import "UserProfileViewController.h"
#import "AccountHandler.h"
#import "UserEntity.h"
#import "UserStorage.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "TradeHandler.h"
#import "TradeCell.h"
#import "CommitTradeListView.h"
#import "TradeWithOthersView.h"
#import <CoreLocation/CoreLocation.h>
#import <UIImageView+WebCache.h>

typedef NS_ENUM(NSUInteger, TbShowInfoType) {
    TbShowInfoTypeDynamic = 0,
    TbShowInfoTypeProperty,
    TbShowInfoTypeUserSign,
};


@interface ProfileViewController ()<ProfileViewDelegate,UITableViewDataSource,UITableViewDelegate,CommitTradeListViewDelegate,LargeHModalPanelDelegate>

@property (nonatomic, strong) ProfileView       *v;
@property (nonatomic,       ) TbShowInfoType    tbShowInfoType;
@property (nonatomic, strong) NSMutableArray    *arr_InfoList;
@property (nonatomic, strong) NSMutableArray    *arr_tradeList;
@property (nonatomic, strong) CommitTradeListView       *commitTradeList;
@property (nonatomic, strong) TradeWithOthersView       *v_AddTradeView;
@property (nonatomic, strong) UILabel                   *lb_memo;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
//    self.isNoShowLine = YES;
    [self addNSNotification];
    [super viewDidLoad];
    self.arr_tradeList = [NSMutableArray array];
}

-(void)onCreate
{
    _v = [[ProfileView alloc] initWithFrame:self.view.frame andProfileType:self.profileType];
    _v.delegate = self;
    _v.tb_list.delegate = self;
    _v.tb_list.dataSource = self;
    _v.tb_list.tableFooterView = [UIView new];
    [self.view addSubview:_v];
    
    self.lb_memo = [[UILabel alloc]initWithFrame:CGRectMake(0, _v.tb_list.frame.origin.y, self.view.frame.size.width, _v.tb_list.frame.size.height)];
    [self.lb_memo setTextAlignment:NSTextAlignmentCenter];
    [self.lb_memo setTextColor:[UIColor whiteColor]];
    
    _v.tb_list.allowsSelection = NO;
    _tbShowInfoType = _v.sg_dynamic.selectedSegmentIndex;
    _arr_InfoList = [NSMutableArray array];
    [self requstDynamic];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if(_entity){
        [_v contentWithEntity:_entity];
    }else{
        [_v contentWithUserStorage];
    }
    if (_profileType == ProfileTypeSelf) {
        if ([UserStorage bgImage]) {
            _v.iv_bgImage.image = [UserStorage bgImage];
        }else{
            _v.iv_bgImage.image = [UIImage imageNamed:@"img_profile_bg2"];
        }
    }

    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_tbShowInfoType) {
        case TbShowInfoTypeDynamic:
        {
            return self.arr_InfoList.count;
        }
            break;
        case TbShowInfoTypeProperty:
        {
            return self.arr_tradeList.count;
        }
            break;
        case TbShowInfoTypeUserSign:
        {
        }
            break;
        default:
            break;
            
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_tbShowInfoType) {
        case TbShowInfoTypeDynamic:
        {
            DynamicEntity *dynamicEntity = [self.arr_InfoList objectAtIndex:indexPath.row];
            return 100+(dynamicEntity.dynamic_pic_list.count-1)/7*(39+5);
        }
            break;
        case TbShowInfoTypeProperty:
        {
            return 70;
        }
            break;
        default:
            return 10;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_tbShowInfoType) {
        case TbShowInfoTypeDynamic:
        {
            DynamicCell *cell = nil;
            //第一个Cell状态点特殊
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialDynamicCell"];
                if (cell == nil) {
                    cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SpecialDynamicCell" indexPath:indexPath];
                }
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
                if(cell == nil)
                {
                    cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DynamicCell" indexPath:indexPath];
                }
            }
            
            DynamicEntity *dynamicEntity = [self.arr_InfoList objectAtIndex:indexPath.row];
            [cell contentWithDynamicEntity:dynamicEntity];
            
            return cell;
        }
            break;
        case TbShowInfoTypeProperty:
        {
            TradeCell *cell = nil;
            static NSString *CellIdentifier = @"PropertyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[TradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.btn_trash.hidden = YES;
            }
            TradeEntity *tradeEntity = [self.arr_tradeList objectAtIndex:indexPath.row];
            [cell contentCellWithExchangeEntity:tradeEntity noti:NO];
            
            return cell;
        }
            break;
        default:
            break;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (_tbShowInfoType) {
        case TbShowInfoTypeDynamic:
        {
        }
            break;
        case TbShowInfoTypeProperty:
        {
            TradeEntity *tradeEntity =[self.arr_tradeList objectAtIndex:indexPath.row];
            if (self.profileType == ProfileTypeSelf) {
                [TradeHandler getTradeDetailWithUserId:[UserStorage userId] tradeId:tradeEntity.trade_id prepare:^{
                    [SVProgressHUD show];
                } success:^(NSArray *arr_tradeBuyList) {
                    [SVProgressHUD dismiss];
                    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
                    [self.view addSubview:bg];
                    _commitTradeList = [[CommitTradeListView alloc]initWithFrame:CGRectMake(8, 20, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68)];
                    _commitTradeList.delegate = self;
                    [bg addSubview:_commitTradeList];
                    [_commitTradeList loadDataWithMyTradeEntity:tradeEntity buyList:arr_tradeBuyList];
                    [_commitTradeList showFromPoint:[self.view center]];
                    //                [SVProgressHUD showInfoWithStatus:@"获取交易详情成功"];
                } failed:^(NSInteger statusCode, id json) {
                    [SVProgressHUD showErrorWithStatus:@"获取交易详情失败"];
                }];
            }else if (self.profileType == ProfileTypeOthers){
                [TradeHandler getTradeDetailWithUserId:[UserStorage userId] tradeId:tradeEntity.trade_id prepare:^{
                    [SVProgressHUD show];
                } success:^(NSArray *arr_tradeBuyList) {
                    [SVProgressHUD dismiss];
                    UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
                    [self.view addSubview:bg];
                    _v_AddTradeView = [[TradeWithOthersView alloc] initWithFrame:CGRectMake(8, 20, CGRectGetWidth(bg.frame)-8*2, CGRectGetHeight(bg.frame)-68) title:@"" buttonTitles:@[@"确认提交",@"取消选择"]];
                    _v_AddTradeView.lb_title.hidden = YES;
                    _v_AddTradeView.line.hidden = YES;
                    _v_AddTradeView.delegate = self;
                    [bg addSubview:_v_AddTradeView];
                    [_v_AddTradeView.iv_avatar sd_setImageWithURL:[NSURL URLWithString:_entity.user_icon] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
                    [_v_AddTradeView loadDataWithAboveTradeEntity:tradeEntity];
                    [_commitTradeList showFromPoint:[self.view center]];
                    //                [SVProgressHUD showInfoWithStatus:@"获取交易详情成功"];
                } failed:^(NSInteger statusCode, id json) {
                    [SVProgressHUD showErrorWithStatus:@"获取交易详情失败"];
                }];

            }
        }
            break;
        default:
            break;
    }
}

#pragma  -mark LargeHModalPanelDelegate

//点击modelView中的下方两个按钮的动作
- (void)modelView:(UIView *)modelView clickBottomButtonAction:(LargeHMPButtonType)buttonType{
    if (modelView == _v_AddTradeView) {
        if (buttonType == LargeHMPButtonTypeLeft) {
            [_v_AddTradeView leftButtonAction:nil];
            [self requstDynamic];
//            self.navigationController.navigationBarHidden = NO;
        }else{
            [_v_AddTradeView hide];
//            self.navigationController.navigationBarHidden = NO;
        }
    }
}

- (void)modelView:(UIView *)modelView goBackAction:(id)sender{
//    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - ProfileViewDelegate
- (void)backToForwardViewAction:(UIButton *)sender{
    
    if(self.profileType == ProfileTypeOthers){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self leftBarAction:sender];
}

- (void)changeBackgroudImageAction:(UIButton *)sender{
    
}

- (void)shareProfileAction:(UIButton *)sender{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"ShareSDK" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:@"Hello,Code4App.com!" defaultContent:nil image:[ShareSDK imageWithPath:path] title:@"This is title" url:@"http://mob.com" description:@"This is description" mediaType:SSPublishContentMediaTypeImage];
    //2.调用分享菜单分享
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            NSLog(@"分享成功");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        //如果分享失败
        if (state == SSResponseStateFail) {
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        //        if (state == SSResponseStateCancel){
        //            NSLog(@"分享取消");
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享取消" message:@"进入了分享取消状态" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            [alert show];
        //        }
    }];
    
}

- (void)modifyMyProfileAction:(UIButton *)sender{
    UserProfileViewController* vc = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)followAction:(UIButton *)sender
{
    
    if (!sender.selected) {
        [AccountHandler followerUserId:[UserStorage userId] otherUserIdList:@[_entity.user_id] prepare:^{
        } success:^(id obj) {
            [SVProgressHUD dismiss];
            sender.selected = !sender.selected;
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"添加关注失败"];
            }
        }];
    }else{
        [AccountHandler unfollowerUserId:[UserStorage userId] otherUserIdList:@[_entity.user_id] prepare:^{
        } success:^(id obj) {
            [SVProgressHUD dismiss];
            sender.selected = !sender.selected;
            [SVProgressHUD showSuccessWithStatus:@"已取消关注"];
        } failed:^(NSInteger statusCode, id json) {
            if (json) {
                [SVProgressHUD showErrorWithStatus:(NSString *)json];
            }else{
                [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
            }
        }];
    }
    
}

- (void)requstDynamic{
    if(_entity){
        [AccountHandler getUserInfoWithUserId:[UserStorage userId] otherUserId:_entity.user_id prepare:^{
            //
        } success:^(UserEntity *userEntity) {
            _entity = userEntity;
            [_v contentWithEntity:_entity];
            [self calculateLocationDistance];
            [self.arr_InfoList removeAllObjects];
            [self.arr_InfoList addObjectsFromArray:userEntity.dynamic_list];
            if (self.arr_InfoList.count == 0) {
                [self.view addSubview:self.lb_memo];
                [self.lb_memo setText:@"该用户近期没有活动"];
            }else{
                [self.lb_memo removeFromSuperview];
            }
            [_v.tb_list reloadData];
        } failed:^(NSInteger statusCode, id json) {
            //失败处理
        }];
    }else{
        [AccountHandler getDynamicWithUserId:[UserStorage userId] prepare:^{
            //
        } success:^(NSArray *obj) {
            [self.arr_InfoList removeAllObjects];
            [self.arr_InfoList addObjectsFromArray:obj];
            if (self.arr_InfoList.count == 0) {
                [self.view addSubview:self.lb_memo];
                [self.lb_memo setText:@"该用户近期没有活动"];
            }else{
                [self.lb_memo removeFromSuperview];
            }
            [_v.tb_list reloadData];
        } failed:^(NSInteger statusCode, id json) {
            //失败处理
        }];
    }
    
    
    
}

- (void)switchSegmentedControlAction:(UISegmentedControl *)sg{
    _tbShowInfoType = sg.selectedSegmentIndex;
    switch (sg.selectedSegmentIndex) {
        case TbShowInfoTypeDynamic:
        {
            _v.tv_sign.hidden = YES;
            _v.lb_UID.hidden = YES;
            _v.tb_list.hidden = NO;
            _v.tb_list.allowsSelection = NO;
            _v.v_userInfo.hidden = YES;
            [self requstDynamic];
            
        }
            break;
        case TbShowInfoTypeProperty:
        {
            _v.tv_sign.hidden = YES;
            _v.lb_UID.hidden = YES;
            _v.tb_list.hidden = NO;
            _v.v_userInfo.hidden = YES;
            _v.tb_list.allowsSelection = YES;
            
            [self requestProperty];
        }
            break;
        case TbShowInfoTypeUserSign:
        {
            if (_entity) {
                [_v contentWithEntity:_entity];
            }else{
                [_v contentWithUserStorage];
            }
            [self.lb_memo removeFromSuperview];
            _v.lb_UID.hidden = NO;
            _v.v_userInfo.hidden = NO;
            _v.tb_list.hidden = YES;
        }
            break;
    }
}

- (void)requestProperty
{
    if (_entity) {
        [TradeHandler getOtherTradeInfoWithUserId:[UserStorage userId] otherUserId:_entity.user_id prepare:^{
            
        } success:^(NSArray *arr_trade) {
            [self.arr_tradeList removeAllObjects];
            [self.arr_tradeList addObjectsFromArray:arr_trade];
            if (self.arr_tradeList.count == 0) {
                [self.lb_memo setText:@"该用户未发起交换"];
                [self.view addSubview:self.lb_memo];
            }else{
                [self.lb_memo removeFromSuperview];
            }
            [_v.tb_list reloadData];
        } failed:^(NSInteger statusCode, id json) {
            
        }];
    }else{
        [TradeHandler getMyTradeInfoSellWithUserId:[UserStorage userId] prepare:^{
            
        } success:^(NSArray *arr_trade) {
            [self.arr_tradeList removeAllObjects];
            [self.arr_tradeList addObjectsFromArray:arr_trade];
            if (self.arr_tradeList.count == 0) {
                [self.lb_memo setText:@"该用户未发起交换"];
                [self.view addSubview:self.lb_memo];
            }else{
                [self.lb_memo removeFromSuperview];
            }
            [_v.tb_list reloadData];
        } failed:^(NSInteger statusCode, id json) {
            
        }];
    }
}

- (void)addNSNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestProperty)
                                                 name:NOTI_TRADE_CONFIRM_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestProperty)
                                                 name:NOTI_TRADE_CANCEL_SUCCESS
                                               object:nil];
}

- (void)removeNSNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_TRADE_CONFIRM_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_TRADE_CANCEL_SUCCESS object:nil];
}

- (void)calculateLocationDistance
{
    if(_entity){
        CoordinateEntity* coor = [UserStorage userCoordinate];
        if (coor.lat > 0) {
            //第一个坐标
            CLLocation *my=[[CLLocation alloc] initWithLatitude:coor.lat longitude:coor.lng];
            //第二个坐标
            CLLocation *other=[[CLLocation alloc] initWithLatitude:_entity.coordinate.lat longitude:_entity.coordinate.lng];
            // 计算距离
            CLLocationDistance meters=[other distanceFromLocation:my];
            _v.lb_location.text = [NSString stringWithFormat:@"%.2fkm",meters/1000];
        }else{
            _v.lb_location.text = @"未知";
        }
    }
}

- (void)dealloc
{
    [self removeNSNotification];
}


@end
