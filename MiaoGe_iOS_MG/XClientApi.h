//
//  XClientApi.h
//  XiuDian
//
//  Created by shuganpeng on 14-3-11.
//  Copyright (c) 2014年 shuganpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
@interface XClientApi : AFHTTPClient
@property (nonatomic, strong) NSMutableDictionary *errcodeDict;

+ (XClientApi *)sharedClient;
+(XClientApi *)sharedClient1;
/* 获取错误编码对应的错误信息 */

+(void)seturl:(NSURL *)url;
- (NSString*)errorMsgForCode:(NSString*)code;
//-(NSMutableDictionary*)appendSignParameters:(NSDictionary*)parameters;
@end
