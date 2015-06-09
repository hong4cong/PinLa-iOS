//
//  HotspotHandler.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@class CoordinateEntity;

@interface HotspotHandler : BaseHandler

+ (void)getHotspotWithUserId:(NSString*)userId coordinate:(CoordinateEntity*)coordinate  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

+ (void)getHotspotListWithUserId:(NSString*)userId userIdList:(NSArray*)userIdList prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
