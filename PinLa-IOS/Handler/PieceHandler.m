 //
//  PieceHandler.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "PieceHandler.h"
#import "CoordinateEntity.h"
#import "UserStorage.h"
#import "PieceEntity.h"
#import "CardEntity.h"
#import "PieceNumberingEntity.h"

@implementation PieceHandler

//扫描周边可拾取碎片
+ (void)getPieceWithUserId:(NSString*)userId coordinate:(CoordinateEntity*)coordinate  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_PIECE_GET_PIECE];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"coordinate":coordinate.keyValues,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            id data = [responseObject objectForKey:@"scan_piece_list"];
            NSArray* arr = [PieceEntity parsePieceArrayWithKeyValuesArray:data];
            success(arr);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//拾取请求
+ (void)pickupPieceWithUserId:(NSString*)userId pieceList:(NSArray*)pieceList prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_PIECE_GET_PICKUP];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"scan_piece_list":pieceList,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//合成道具
+ (void)makePropWithUserId:(NSString*)userId propFatherId:(NSString*)propFatherId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_PROP_MAKE_PROP];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"prop_father_id":propFatherId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//道具换券
+ (void)makeCardWithUserId:(NSString*)userId propId:(NSString*)propId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_PROP_MAKE_CARD];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"prop_id":propId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if([self handlerWithData:responseObject failed:failed]){
            NSString* str = [responseObject objectForKey:@"pic"];
            success(str);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//摧毁碎片
+ (void)destroyPieceWithPieceId:(NSArray *)arr_pieceId userId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_PIECE_DESTROY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"piece_list":arr_pieceId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if([self handlerWithData:responseObject failed:failed]){
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//摧毁道具
+ (void)destroyPropWithPropId:(NSArray*)arr_propId userId:(NSString *)userId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_PROP_DESTROY];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"prop_list":arr_propId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if([self handlerWithData:responseObject failed:failed]){
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

//碎片详情
+ (void)getPieceDetailWithUserId:(NSString*) userId propFatherId:(NSString*)propFatherId prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *str_url = [self requestUrlWithPath:API_PIECE_DETAIL];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"prop_father_id":propFatherId,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if([self handlerWithData:responseObject failed:failed]){
            PieceNumberingEntity* entity = [PieceNumberingEntity parseObjectWithKeyValues:[responseObject objectForKey:@"piece_info"]];
            success(entity);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}
@end
