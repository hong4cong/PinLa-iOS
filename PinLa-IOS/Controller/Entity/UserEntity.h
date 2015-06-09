//  用户实体
//  UserEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"
#import "CardEntity.h"
#import "DynamicEntity.h"
#import "CoordinateEntity.h"

@interface UserEntity : BaseEntity

@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *token;
@property (nonatomic, strong) NSString      *nick_name;
@property (nonatomic, strong) NSString      *user_icon;
@property (nonatomic, strong) NSString      *user_sign;
@property (nonatomic, strong) NSString      *account;
@property (nonatomic, assign) int           status;
@property (nonatomic, strong) CoordinateEntity       *coordinate;

@property (nonatomic, strong) NSArray       *card_list;
@property (nonatomic, strong) NSArray       *dynamic_list;

@property (nonatomic,assign)BOOL followers;


+ (UserEntity *)parseUserWithJson:(id)json;

+ (NSArray*)parseUserArrayWithKeyValuesArray:(id)json;

@end
