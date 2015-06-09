//
//  TradeHandler.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "TradeHandler.h"
#import "UserStorage.h"
#import "TradeEntity.h"
#import "PaticipantTradeEntity.h"

@implementation TradeHandler

//获取自己的交易列表
+ (void)getMyTradeInfoSellWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_GET_TRADEINFO_SELL];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray *arr_trade = [TradeEntity parseTradeArrayWithKeyValuesArray:[responseObject objectForKey:@"trade_list"]];
            success(arr_trade);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)getMyTradeInfoBuyWithUserId:(NSString*)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_GET_TRADEINFO_BUY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray *arr_paticipantList = [PaticipantTradeEntity parsePaticipantTradeArrayWithKeyValuesArray:[responseObject objectForKey:@"trade_list"]];
            success(arr_paticipantList);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}


//获取其他用户交易列表
+ (void)getOtherTradeInfoWithUserId:(NSString*)userId otherUserId:(NSString*)otherUserID prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_GET_OTHER_TRADEINFO];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"other_user_id":otherUserID,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray *arr_trade = [TradeEntity parseTradeArrayWithKeyValuesArray:[responseObject objectForKey:@"trade_list"]];
            success(arr_trade);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//获取详细交易信息
+ (void)getTradeDetailWithUserId:(NSString*)userId tradeId:(NSString*)tradeId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_GET_BUYINFO];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_id":tradeId};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray *arr_trade = [TradeEntity parseTradeArrayWithKeyValuesArray:[responseObject objectForKey:@"trade_buy_list"]];
            success(arr_trade);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}



//确认交易
+ (void)confirmTradeWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_SELL_CONFIRM];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_child_id":tradeChildId,
                          @"result":@"OK"};
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//机主买单交易取消
+ (void)cancelTradeBuyWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_UNBUY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_child_id":tradeChildId
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//机主卖单交易取消
+ (void)cancelTradeSellWithUserId:(NSString*)userId tradeId:(NSString*)tradeId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_UNSELL];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_id":tradeId
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}


//机主碎片买单
+ (void)tradeBuyWithUserId:(NSString*)userId tradeId:(NSString*)tradeId pieceList:(NSArray*)pieceList propList:(NSArray*)propList msg:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_BUY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_id":tradeId,
                          @"piece_list":pieceList,
                          @"prop_list":propList,
                          @"msg":msg,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//机主碎片卖单
+ (void)tradeSellWithUserId:(NSString*)userId pieceList:(NSArray*)pieceList propList:(NSArray*)propList msg:(NSString*)msg prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_SELL];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"piece_list":pieceList,
                          @"prop_list":propList,
                          @"msg":msg,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//机主碎片卖单确认，拒绝 //result : ok/cancel
+ (void)tradeSellConfirmWithUserId:(NSString*)userId tradeChildId:(NSString*)tradeChildId result:(NSString*)result prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_TRADE_SELL];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"trade_child_id":tradeChildId,
                          @"result":result,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

@end
