//  碎片实体
//  PieceEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface PieceEntity : BaseEntity

@property (nonatomic, strong) NSString      *piece_id;          //碎片编号
@property (nonatomic, strong) NSString      *prop_father_id;    //碎片对应道具的父id
@property (nonatomic, strong) NSString      *piece_branch;      //碎片子编号1-6
@property (nonatomic, strong) NSString      *piece_title;       //碎片名
@property (nonatomic, strong) NSString      *piece_detail;      //碎片信息
@property (nonatomic, assign) NSInteger      piece_type;        //碎片类型
@property (nonatomic, strong) NSString      *piece_attr;        //碎片属性
@property (nonatomic, strong) NSString      *piece_validity;    //碎片有效期
@property (nonatomic, strong) NSString      *piece_icon;
@property (nonatomic, assign) BOOL           piece_lock;        //碎片是否锁定
@property (nonatomic, assign) NSInteger      piece_status;      //碎片状态
@property (nonatomic, assign) NSInteger      piece_quality;

+ (PieceEntity *)parsePieceWithJson:(id)json;

+ (NSArray*)parsePieceArrayWithKeyValuesArray:(id)json;

@end
