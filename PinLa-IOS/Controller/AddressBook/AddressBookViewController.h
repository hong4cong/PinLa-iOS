//
//  AddressBookViewController.h
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressBookViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray  *arr_addressBookTemp;
@property (nonatomic,strong)NSMutableArray  *arr_phone;
@property (nonatomic,strong)NSMutableArray  *arr_addressBook;
@property (nonatomic,strong)UITableView     *tb_addressBook;
@end
