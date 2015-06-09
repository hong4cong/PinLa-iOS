//
//  PieceHandler.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@class CoordinateEntity;

@interface PieceHandler : BaseHandler

//扫描周边可拾取碎片
+ (void)getPieceWithUserId:(NSString*)userId coordinate:(CoordinateEntity*)coordinate  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//拾取请求
+ (void)pickupPieceWithUserId:(NSString*)userId pieceList:(NSArray*)pieceList prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//合成道具
+ (void)makePropWithUserId:(NSString*)userId propFatherId:(NSString*)propFatherId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//道具换券
+ (void)makeCardWithUserId:(NSString*)userId propId:(NSString*)propId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//摧毁碎片
+ (void)destroyPieceWithPieceId:(NSArray*)arr_pieceId userId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//摧毁道具
+ (void)destroyPropWithPropId:(NSArray*)arr_propId userId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//碎片详情
+ (void)getPieceDetailWithUserId:(NSString*) userId propFatherId:(NSString*)propFatherId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
