//
//  HotspotPolyEntity.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/5.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface HotspotPolyEntity : BaseEntity

@property (nonatomic,strong) NSArray        *user_list;
@property (nonatomic,strong) NSArray        *hotspot_list;

+ (HotspotPolyEntity *)parseHotspotPolyUserWithJson:(id)json;

@end
