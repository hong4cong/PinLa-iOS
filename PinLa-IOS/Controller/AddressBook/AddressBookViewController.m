//
//  AddressBookViewController.m
//  PinLa-IOS
//
//  Created by lixiao on 15/4/9.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBook.h"
#import "AddressBookCell.h"
#import "AccountHandler.h"
#import "UserStorage.h"
#import "UserEntity.h"
#import "AddRelationViewController.h"
@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加通讯录好友";
    // Do any additional setup after loading the view.
}

- (void)onCreate{
    
    self.arr_addressBookTemp = [NSMutableArray array];
    self.arr_addressBook = [NSMutableArray array];
    self.arr_phone = [NSMutableArray array];
    
    self.tb_addressBook = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tb_addressBook.delegate = self;
    self.tb_addressBook.dataSource = self;
    self.tb_addressBook.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tb_addressBook];
    
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue ]>=6.0) {
        
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        
    }
    else
    {
        
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    for(NSInteger i = 0; i<nPeople; i++)
        
    {
        
        //创建一个addressBook shuxing类
        
        AddressBook *addressBook = [[AddressBook alloc]init];
        
        //获取个人
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        //获取个人名字
        
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonAddressProperty);
        
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            
            nameString = (__bridge NSString *)abFullName;
            
        } else {
            
            if ((__bridge id)abLastName != nil)
                
            {
                
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                
            }
            
        }
        
        addressBook.name = nameString;
        
        ABPropertyID multiProperties[] = {
            
            kABPersonPhoneProperty,
            
            kABPersonEmailProperty
            
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            
            ABPropertyID property = multiProperties[j];
            
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            
            NSInteger valuesCount = 0;
            
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            
            if (valuesCount == 0) {
                
                CFRelease(valuesRef);
                
                continue;
                
            }
            
            //获取电话号码和email
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                
                switch (j) {
                        
                    case 0: {// Phone number
                        
                        addressBook.tel = (__bridge NSString*)value;
                        
                        break;
                        
                    }
                        
                    case 1: {// Email
                        
                        addressBook.email = (__bridge NSString*)value;
                        
                        break;
                        
                    }
                        
                }
                
                CFRelease(value);
                
            }
            
            CFRelease(valuesRef);
            
        }
        
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        
        [self.arr_addressBookTemp addObject:addressBook];
    }
    for (AddressBook *book in self.arr_addressBookTemp) {
        if (book.tel) {
            [self.arr_phone addObject:book.tel];
        }
    }
    [self loadData];
}

- (void)loadData{
    [AccountHandler UpdateAddressWithUserId:[UserStorage userId] phone_list:self.arr_phone prepare:^{
        [SVProgressHUD showWithStatus:@"正在获取通讯录"];
    } success:^(id obj) {
        [SVProgressHUD dismiss];
        [self.arr_addressBook addObjectsFromArray:(NSArray *)obj];
        NSMutableArray *arr_phone = [[NSMutableArray alloc]init];
        for (UserEntity *userEntity in self.arr_addressBook) {
            [arr_phone addObject:userEntity.account];
        }
        for (int i = 0; i < self.arr_addressBookTemp.count; i++) {
            AddressBook *book = [self.arr_addressBookTemp objectAtIndex:i];
            if (![arr_phone containsObject:book.tel]) {
                UserEntity *userEntity = [[UserEntity alloc]init];
                userEntity.nick_name = book.name;
                userEntity.status = 3;
                [self.arr_addressBook addObject:userEntity];
            }
        }
        
        [self.tb_addressBook reloadData];
    } failed:^(NSInteger statusCode, id json) {
        if (json) {
            [SVProgressHUD showWithStatus:(NSString *)json];
        }else{
            [SVProgressHUD showWithStatus:@"获取通讯录失败"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arr_addressBook count];
    
}

//cell内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ContactCell";
    
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    UserEntity *userEntity = [self.arr_addressBook objectAtIndex:indexPath.row];
    [cell contentAddressBookWithUserEntity:userEntity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UserEntity *userEntity = [self.arr_addressBook objectAtIndex:indexPath.row];
    if (userEntity.status == 0) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[AddRelationViewController class]]) {
                AddRelationViewController *vc_addRelation = (AddRelationViewController *)vc;
                [vc_addRelation setContentWithUserEntity:userEntity];
                [self.navigationController popToViewController:vc_addRelation animated:YES];
            }
        }
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
