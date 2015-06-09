//
//  RTHttpClient.m
//  ZLYDoc
//
//  Created by Ryan on 14-4-10.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "RTHttpClient.h"
#import "RTJSONResponseSerializerWithData.h"
#import <AFNetworking/AFSecurityPolicy.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <Reachability/Reachability.h>
#import <netinet/in.h>
//#import <AdSupport/AdSupport.h>
#import "UserStorage.h"

//#import "LoginStorage.h"

@interface RTHttpClient()

@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property (readwrite, nonatomic, strong) NSMutableDictionary *parametersHeader;

@end

@implementation RTHttpClient

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        _parametersHeader = [NSMutableDictionary dictionary];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"zlycare" ofType:@"cer"];
//        NSData *certData = [NSData dataWithContentsOfFile:path];
//        DLog(@"----------------------------------%@",certData);
//        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//        [securityPolicy setAllowInvalidCertificates:NO];
//        [securityPolicy setPinnedCertificates:@[certData]];
//        [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        [securityPolicy setAllowInvalidCertificates:YES];
        //[securityPolicy setSSLPinningMode:AFSSLPinningModeNone];
        
        self.manager.securityPolicy = securityPolicy;
        
//        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //响应结果序列化类型
        self.manager.responseSerializer = [RTJSONResponseSerializerWithData serializer];
    }
    return self;
}

+ (RTHttpClient *)defaultClient
{
    static RTHttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                prepare:(PrepareBlock)prepare
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self requestWithPath:url method:method parameters:parameters constructingBodyWithBlock:nil prepare:prepare success:success failure:failure];
}

- (void)  requestWithPath:(NSString *)url
               parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  prepare:(PrepareBlock)prepare
                  success:(void (^)(NSURLSessionDataTask *, id))success
                  failure:(void (^)(NSURLSessionDataTask *, NSError *))failure

{
    [self requestWithPath:url method:RTHttpRequestPostFile parameters:parameters constructingBodyWithBlock:block prepare:prepare success:success failure:failure];
}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                prepare:(PrepareBlock)prepare
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //请求的URL
    DLog(@"Request path:%@",url);
//    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *version = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* phoneModel = [[UIDevice currentDevice] model];
    
    [_parametersHeader setObject:@"appstore" forKey:@"channel"];
    [_parametersHeader setObject:idfv forKey:@"device_mark"];
    [_parametersHeader setObject:version forKey:@"app_version"];
    [_parametersHeader setObject:phoneModel forKey:@"device_model"];
    
    if ([UserStorage token]) {
        [_parametersHeader setObject:[UserStorage token] forKey:@"token"];
    }
    
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        [_parametersHeader addEntriesFromDictionary:parameters];
    }
    
    //预处理
    if (prepare) {
        prepare();
    }
    
    if ([self isConnectionAvailable]) {
        switch (method) {
            case RTHttpRequestGet:
            {
                [self.manager GET:url parameters:_parametersHeader success:success failure:failure];
            }
                break;
            case RTHttpRequestPost:
            {
                [self.manager POST:url parameters:_parametersHeader success:success failure:failure];
            }
                break;
            case RTHttpRequestPostFile:
            {
                [self.manager POST:url parameters:_parametersHeader constructingBodyWithBlock:block success:success failure:failure];
            }
                break;
            case RTHttpRequestDelete:
            {
                [self.manager DELETE:url parameters:_parametersHeader success:success failure:failure];
            }
                break;
            case RTHttpRequestPut:
            {
                [self.manager PUT:url parameters:_parametersHeader success:success failure:failure];
            }
                break;
            default:
                break;
        }
    }else{
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
}

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([self isConnectionAvailable]) {
        [self.manager HEAD:url parameters:parameters success:success failure:failure];
    }else{
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
}

//看看网络是不是给力
- (BOOL)isConnectionAvailable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        DLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)cancelRequest
{
    [_manager.operationQueue cancelAllOperations];
}

@end
