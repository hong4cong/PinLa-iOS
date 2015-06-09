//
//  ExchangeViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/12.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ExchangeViewController.h"
#import "RelationCell.h"
#import "IndicatorView.h"
#import "REMenu.h"

@interface ExchangeViewController ()

@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic,strong)REMenu          *menu;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交换";
    
    UIView* titleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 100, 44)];
    
    
    UILabel* lb_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 0, 44)];
    lb_title.text = @"发起的交换";
    lb_title.font = [UIFont boldSystemFontOfSize:20];
    [lb_title sizeToFit];
    lb_title.textAlignment = NSTextAlignmentCenter;
    [titleBgView addSubview:lb_title];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleInvoked:)];
    lb_title.userInteractionEnabled = YES;
    [lb_title addGestureRecognizer:gesture];
    
    IndicatorView* indicatorView = [[IndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb_title.frame)+5, 24, 10, 8)];
    titleBgView.frame = CGRectMake(0, 0, CGRectGetWidth(lb_title.frame) + CGRectGetWidth(indicatorView.frame)+5 , 44);
    titleBgView.center = CGPointMake((CGRectGetWidth(self.view.frame) - 100)/2, 22);
    
    [titleBgView addSubview:indicatorView];
    
    self.navigationItem.titleView = titleBgView;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RelationCell";
    RelationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[RelationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell contentWithRelationEntity:nil];
    cell.lb_nickname.text = [NSString stringWithFormat:@"星巴克%d",(long)indexPath.row];
    
    return cell;
}

- (void)titleInvoked:(id)sender
{
    [self showMenu];
}

- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"发起的交换"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"参与的交换"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem]];
    _menu.cornerRadius = 2;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}

@end
