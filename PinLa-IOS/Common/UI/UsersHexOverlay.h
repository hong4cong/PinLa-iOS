//
//  UsersHexOverlay.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/30.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HexagonOverlay.h"
#import "PolyUserEntity.h"

@interface UsersHexOverlay : HexagonOverlay
@property(nonatomic,strong)NSString* text;
@property(nonatomic,strong)PolyUserEntity* entity;
@end
