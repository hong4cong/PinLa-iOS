//
//  HotspotHandler.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "HotspotHandler.h"
#import "CoordinateEntity.h"
#import "UserStorage.h"
#import "PolyUserEntity.h"
#import "HotspotPolyEntity.h"
#import "UserEntity.h"

@implementation HotspotHandler

+ (void)getHotspotWithUserId:(NSString*)userId coordinate:(CoordinateEntity*)coordinate  prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_HOTSPOT_GET_HOTSPOT];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"coordinate":coordinate.keyValues,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        HotspotPolyEntity* entity = [HotspotPolyEntity parseHotspotPolyUserWithJson:responseObject];
        success(entity);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

+ (void)getHotspotListWithUserId:(NSString*)userId userIdList:(NSArray*)userIdList prepare:(PrepareBlock)prepare success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *str_url = [self requestUrlWithPath:API_HOTSPOT_GET_HOTSPOT_LIST];
    NSDictionary *dic = @{@"user_id":[UserStorage userId],
                          @"user_id_list":userIdList,
                          };
    [[RTHttpClient defaultClient]requestWithPath:str_url method:RTHttpRequestPost parameters:dic prepare:prepare success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            NSArray* arr_user = [responseObject objectForKey:@"user_list"];
            NSArray* arr_entity = [UserEntity parseUserArrayWithKeyValuesArray:arr_user];
            success(arr_entity);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:failed];
    }];
}

@end
