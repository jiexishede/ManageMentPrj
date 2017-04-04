//
//  UtilClass.h
//  BaDian
//
//  Created by sgp on 14-5-16.
//  Copyright (c) 2014年 sgp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UtilClass : NSObject

+(NSString*)GetString:(id)xobj;

+(void)lblatrr:(UILabel *)lbl font:(UIFont*)fon color:(UIColor*)color alignment:(NSInteger)NSTextAlignment text:(NSString*)text;
+(void)btnatrr:(UIButton *)btn font:(UIFont*)fon color:(UIColor*)color backcolor:(UIColor*)bdcolor text:(NSString*)text;

+(BOOL)IsWhitespace:(NSString*)str;

+ (NSString *) md5:(NSString *) input;


+(NSString*)clearWhitespace:(NSString*)str;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+(BOOL)islogin;
//获取token
+(NSString *)gettoken;

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

@end
