//
//  CoordinateEntity.h
//  PinLa-IOS
//
//  Created by SeanLiu on 15/4/11.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseEntity.h"

@interface CoordinateEntity : NSObject

@property (nonatomic, assign) CGFloat   lat;            //纬度	Float
@property (nonatomic, assign) CGFloat   lng;            //经度	Float
@property (nonatomic, strong) NSString  *city_code;     //城市码	STRING

@end
