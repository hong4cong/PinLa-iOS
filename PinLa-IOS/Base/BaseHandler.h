//
//  BaseHandler.h
//  zlydoc-iphone
//  BaseHandler : Every subclass handler should extends
//  Created by Ryan on 14-6-25.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTHttpClient.h"

/// NSError userInfo key that will contain response data
#define JSONResponseSerializerWithDataKey @"JSONResponseSerializerWithDataKey"

/**
 *  Handler处理完成后调用的Block
 */
typedef void (^CompleteBlock)();

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(NSInteger statusCode, id json);

//_____________________________________________________________________________
@interface BaseHandler : NSObject

/**
 *  获取请求URL
 *
 *  @param path
 *  @return 拼装好的URL
 */
+ (NSString *)requestUrlWithPath:(NSString *)path;
+ (NSString *)requestUrlWithHttpsPath:(NSString *)path;
+ (NSString *)requestNoVersionNumUrlWithHttpsPath:(NSString *)path;
/**
 *  异常错误处理
 *
 *  @param task
 *  @param error
 *  @param failed
 */
+ (void)handlerErrorWithTask:(NSURLSessionDataTask *)task error:(NSError *)error complete:(FailedBlock)failed;

//异常错误处理 new
+ (BOOL)handlerWithData:(id)responseObject failed:(FailedBlock)failed;
/**
 *  获取json的statusCode
 *
 *  @param task
 */
+ (NSInteger)statusCodeWithTask:(NSURLSessionDataTask *)task;

+ (NSDictionary *)objectsByRegulateJSON:(id)json;

@end
