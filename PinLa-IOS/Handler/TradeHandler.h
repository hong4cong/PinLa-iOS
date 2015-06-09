//
//  TradeHandler.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "BaseHandler.h"

@interface TradeHandler : BaseHandler

//获取自己卖出的交易列表
+ (void)getMyTradeInfoSellWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取自己参与的交易列表
+ (void)getMyTradeInfoBuyWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取其他用户交易列表
+ (void)getOtherTradeInfoWithUserId:(NSString*)userId otherUserId:(NSString*)otherUserID prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取自己卖出的交易列表
//+ (void)getMyTradeInfoWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取自己参与的交易列表
//+ (void)getTradeBuyInfoWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取详细交易信息
+ (void)getTradeDetailWithUserId:(NSString*)userId tradeId:(NSString*)tradeId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//机主碎片卖单
+ (void)tradeSellWithUserId:(NSString*)userId pieceList:(NSArray*)pieceList propList:(NSArray*)propList msg:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//机主碎片买单
+ (void)tradeBuyWithUserId:(NSString*)userId tradeId:(NSString*)tradeId pieceList:(NSArray*)pieceList propList:(NSArray*)propList msg:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//机主碎片卖单确认，拒绝
+ (void)tradeSellConfirmWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId result:(NSString*)result prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//确认交易
+ (void)confirmTradeWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//机主买单交易取消
+ (void)cancelTradeBuyWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

//机主卖单交易取消
+ (void)cancelTradeSellWithUserId:(NSString*)userId tradeId:(NSString*)tradeId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
