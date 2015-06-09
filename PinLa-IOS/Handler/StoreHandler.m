//
//  StoreHandler.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/5/24.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "StoreHandler.h"
#import "ProductEntity.h"

@implementation StoreHandler

+ (void)getGoodsListWithPrepare:(PrepareBlock)prepare Success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *url = [self requestUrlWithPath:API_STORE_GOODS_LSIT];
    //请求获取server端版本号
    [[RTHttpClient defaultClient] requestWithPath:url
                                           method:RTHttpRequestPost
                                       parameters:nil
                                          prepare:nil
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              if ([self handlerWithData:responseObject failed:failed]) {
                                                  NSArray *arr = [ProductEntity parseObjectArrayWithKeyValuesArray:[responseObject objectForKey:@"goods"]];
                                                  success(arr);
                                              }
                                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              [self handlerErrorWithTask:task error:error complete:failed];
                                          }];
}

@end
