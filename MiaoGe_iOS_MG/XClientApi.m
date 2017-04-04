//
//  XClientApi.m
//  XiuDian
//
//  Created by shugangpeng on 14-3-11.
//  Copyright (c) 2014年 shugangpeng. All rights reserved.
//

#import "XClientApi.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "UtilClass.h"
#import <CommonCrypto/CommonDigest.h>

static XClientApi *_sharedClient = nil;

@implementation XClientApi
//调用服务器http
+(XClientApi *)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XClientApi alloc] initWithBaseURL:[NSURL URLWithString:[AppDelegate getAppDelegate].MGURLString]];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"errcode" ofType:@"plist"];
        _sharedClient.errcodeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    });
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return _sharedClient;
}

+(XClientApi *)sharedClient1{
    static  XClientApi *_sharedClient1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient1 = [[XClientApi alloc] initWithBaseURL:[NSURL URLWithString:[AppDelegate getAppDelegate].MGURLString]];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"errcode" ofType:@"plist"];
        _sharedClient1.errcodeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    });
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return _sharedClient1;
}

- (NSString*)errorMsgForCode:(NSString*)code{
    NSString *errorMsg = [_errcodeDict valueForKey:code];
    if(!errorMsg){
        errorMsg = [NSString stringWithFormat:@"未定义错误:%@",code];
    }
    return errorMsg;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

+(void)seturl:(NSURL *)url{
    _sharedClient = [[XClientApi alloc] initWithBaseURL:[NSURL URLWithString:[AppDelegate getAppDelegate].MGURLString]];
}

-(BOOL)isNeedSessionKey:(NSString*)path{
    return NO;
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(![self isNeedSessionKey:path]){
        parameters =  [self appendSignParameters:parameters];
    }
	[super postPath:path parameters:parameters success:success failure:failure];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    if(![self isNeedSessionKey:path]){
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        if(app.sendm.sessionKey != nil && ![app.sendm.sessionKey isEqualToString:@""] ){
//            NSString *sign = [NSString stringWithFormat:@"%@",app.sendm.sessionKey];
//            path = sign;
//        }else{
//            path = [NSString stringWithFormat:@"%@",path];
//        }
    }
    return [super multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:block];
}


-(NSMutableDictionary*)appendSignParameters:(NSDictionary*)parameters{
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([UtilClass islogin]) {
        [newParameters setObject:[UtilClass gettoken] forKey:@"authToken"];
    }
    [newParameters setObject:[NSString stringWithFormat:@"%@",VERSION] forKey:@"version"];
    [newParameters setObject:@"iOS" forKey:@"deviceOs"];
    return newParameters;
}
@end
