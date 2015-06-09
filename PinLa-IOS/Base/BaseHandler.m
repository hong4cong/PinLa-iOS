//
//  BaseHandler.m
//  zlydoc-iphone
//
//  Created by Ryan on 14-6-25.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "BaseHandler.h"
#import "APIConfig.h"
#import "UserDefaultsUtils.h"
#import "BaseEntity.h"
#import "AppUtils.h"

@implementation BaseHandler

+ (NSString *)requestUrlWithPath:(NSString *)path
{
    NSString *serverHost = SERVER_HOST;
    NSString *serverPath = [[[SERVER_PROTOCOL stringByAppendingString:[serverHost stringByAppendingString:API_VERSION]] stringByAppendingString:path] stringByAppendingString:@".php"];
    return serverPath;
}

+ (NSString *)requestUrlWithHttpsPath:(NSString *)path
{
    NSString *serverHost = SERVER_HOST;
    NSString *serverPath = [[[SERVER_PROTOCOL stringByAppendingString:[serverHost stringByAppendingString:API_VERSION]] stringByAppendingString:path] stringByAppendingString:@".php"];
    return serverPath;
}

+ (NSString *)requestNoVersionNumUrlWithHttpsPath:(NSString *)path
{
    NSString *serverHost = SERVER_HOST;
    return [SERVER_PROTOCOL stringByAppendingString:[serverHost stringByAppendingString:path]];
}

+ (void)handlerErrorWithTask:(NSURLSessionDataTask *)task error:(NSError *)error complete:(FailedBlock)failed
{
    id json = error.userInfo[JSONResponseSerializerWithDataKey];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData && failed) {
        failed(404,nil);
        return;
    }
    
    if (!failed) {
        return;
    }
    
    NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (failed) {
        if([NSJSONSerialization isValidJSONObject:dic_json])
        {
            BaseEntity *result = [BaseEntity parseObjectWithKeyValues:dic_json];
            failed(result.result,result.msg);
        }else{
            failed(404,nil);
        }
    }
}

+ (BOOL)handlerWithData:(id)responseObject failed:(FailedBlock)failed
{
    NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
    NSString* msg = [responseObject objectForKey:@"msg"];
    if (result == 1) {
        return true;
    }else{
        failed(result,msg);
        return false;
    }
}

+ (NSInteger)statusCodeWithTask:(NSURLSessionDataTask *)task
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = response.statusCode;
    return statusCode;
}

+ (NSDictionary *)objectsByRegulateJSON:(id)json
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    //格式化打印输出至控制台
    NSString *responseJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"%@",responseJSON);
    
    id jsonAfterRegulate = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    BOOL jsonIsAvailable = [NSJSONSerialization isValidJSONObject:jsonAfterRegulate];
    return [NSDictionary dictionaryWithObjectsAndKeys:jsonAfterRegulate,JSON_AFTER_REGULATE,[NSNumber numberWithBool:jsonIsAvailable],ISAVAILABLE, nil];
}

@end