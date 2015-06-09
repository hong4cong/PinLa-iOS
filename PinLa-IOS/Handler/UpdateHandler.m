//
//  UpdateHandler.m
//  ZLYDoc
//
//  Created by Ryan on 14-6-6.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "UpdateHandler.h"
#import "BaseEntity.h"
#import "RTHttpClient.h"
#import "APIConfig.h"
#import "VersionEntity.h"
#import "LoadingEntity.h"

@implementation UpdateHandler

+ (void)checkAppVersionWithPrepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed
{
    //当前版本号(Build Number)
    NSString *localVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *url = [self requestUrlWithPath:API_IOS_VERSION];
    //请求获取server端版本号
    [[RTHttpClient defaultClient] requestWithPath:url
                                           method:RTHttpRequestPost
                                       parameters:nil
                                          prepare:nil
    success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self handlerWithData:responseObject failed:failed]) {
            id versionInfo = [responseObject objectForKey:@"versionInfo"];
            //解析结果，对比服务端与版本号
            VersionEntity *updateInfoEntity = [VersionEntity parseVersionStatusJSON:versionInfo];
            if (updateInfoEntity) {
                NSString *remoteVersion = updateInfoEntity.version;
                if ([localVersion intValue] < [remoteVersion intValue]) {
                    success(updateInfoEntity);
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorWithTask:task error:error complete:nil];
    }];
}

+ (void)getLanunchPicWithType:(NSInteger)type Prepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *url = [self requestUrlWithPath:API_IOS_LANUNCH];
    NSDictionary *dic = @{@"type":[NSNumber numberWithInteger:type],
                          };
    //请求获取server端版本号
    [[RTHttpClient defaultClient] requestWithPath:url
                                           method:RTHttpRequestPost
                                       parameters:dic
                                          prepare:nil
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              if ([self handlerWithData:responseObject failed:failed]) {
                                                  NSArray* arr_data = [LoadingEntity parseObjectArrayWithKeyValuesArray:[responseObject objectForKey:@"loading"]];
                                                  
                                                      success(arr_data);
                                              }
                                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              [self handlerErrorWithTask:task error:error complete:failed];
                                          }];
}

@end
