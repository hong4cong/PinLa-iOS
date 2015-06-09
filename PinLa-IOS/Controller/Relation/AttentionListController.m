//
//  AttentionListController.m
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AttentionListController.h"
#import "RelationCell.h"
#import "AddRelationViewController.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import "UserEntity.h"
#import "ProfileViewController.h"

@interface AttentionListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView    *tb_relationList;
@property (nonatomic, strong) NSMutableArray *arr_relationList;
@property (nonatomic, assign) int             int_deleteIndex;

@end

@implementation AttentionListController

- (void)initLeftBarView
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_menu"] style:UIBarButtonItemStyleDone target:(RENavigationController *)self.navigationController action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem = btn_back;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;

    self.arr_relationList = [[NSMutableArray alloc]init];
    [self loadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    self.title = @"关注";
    
    UIImage *image = [UIImage imageNamed:@"img_add_relation"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addRelationAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    _tb_relationList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    _tb_relationList.delegate = self;
    _tb_relationList.dataSource = self;
    _tb_relationList.backgroundColor = [UIColor clearColor];
    [_tb_relationList setSeparatorInset:UIEdgeInsetsMake(80 + MARGIN_LEFT,80 + MARGIN_LEFT, 0, 0)];
    _tb_relationList.tableFooterView = [UIView new];
    _tb_relationList.separatorColor = [UIColor colorWithHexString:COLOR_LINE_1];
    [self.view addSubview:_tb_relationList];
}

- (void)loadData{
    [AccountHandler getFollowerUserId:[UserStorage userId] prepare:^{
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [self.arr_relationList addObjectsFromArray:(NSArray *)obj];
        [self.tb_relationList reloadData];
//        [SVProgressHUD showSuccessWithStatus:@"获取关注列表成功"];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showErrorWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取关注列表失败"];
        }
    }];
}

- (void)addRelationAction:(id)sender{
    AddRelationViewController *vc = [[AddRelationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_relationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RelationCell";
    RelationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[RelationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    UserEntity *userEntity = [self.arr_relationList objectAtIndex:indexPath.row];
    [cell contentWithRelationEntity:userEntity];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UserEntity *entity = [self.arr_relationList objectAtIndex:indexPath.row];
    entity.followers = true;
    ProfileViewController *vc_profile = [[ProfileViewController alloc]init];
    vc_profile.entity = entity;
    vc_profile.profileType = ProfileTypeOthers;
    [self presentViewController:vc_profile animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.int_deleteIndex = (int)indexPath.row;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确认取消关注该好友？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UserEntity *userEntity = [self.arr_relationList objectAtIndex:self.int_deleteIndex];
    
    if (buttonIndex == 1) {
       [AccountHandler unfollowerUserId:[UserStorage userId] otherUserIdList:[NSArray arrayWithObjects:userEntity.user_id, nil] prepare:^{
       } success:^(id obj) {
           [SVProgressHUD showSuccessWithStatus:@"已取消关注"];
           [self.arr_relationList removeObjectAtIndex:self.int_deleteIndex];
           [self.tb_relationList reloadData];
       } failed:^(NSInteger statusCode, id json) {
           if (json) {
               [SVProgressHUD showErrorWithStatus:(NSString *)json];
           }else{
               [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
           }
       }];
    }
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
