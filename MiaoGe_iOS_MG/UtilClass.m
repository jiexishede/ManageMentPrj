//
//  UtilClass.m
//  BaDian
//
//  Created by sgp on 14-5-16.
//  Copyright (c) 2014年 sgp. All rights reserved.
//

#import "UtilClass.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UtilClass

+(NSString*)GetString:(id)xobj{
    if (!xobj) {
        return @"";
    }
    
    if ([xobj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([xobj isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter stringFromNumber:xobj];
    }
    return xobj;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}


//设置lbl属性
+(void)lblatrr:(UILabel *)lbl font:(UIFont*)fon color:(UIColor*)color alignment:(NSInteger)NSTextAlignment text:(NSString*)text{
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignment;
    lbl.font = fon;
    lbl.textColor = color;
    lbl.text = text;
}

//设置but属性
+(void)btnatrr:(UIButton *)btn font:(UIFont*)fon color:(UIColor*)color backcolor:(UIColor*)bdcolor text:(NSString*)text{
    btn.backgroundColor = bdcolor;
    btn.titleLabel.font = fon;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
}

//判断是否空白字符串
+(BOOL)IsWhitespace:(NSString*)str{
    if (str == nil) {
        return YES;
    }
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([temp length]!=0) {
        return NO;
    }
    return YES;
}

+(NSString*)clearWhitespace:(NSString*)str{
    if (str == nil) {
        return @"";
    }
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!temp) {
        temp = @"";
    }
    
    return temp;
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}



/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NSString*)gettoken{
    AppDelegate *app  = [AppDelegate getAppDelegate];
    if (app.sed.infomodel.authToken && ![app.sed.infomodel.authToken isEqualToString:@""]) {
        return app.sed.infomodel.authToken;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [self GetString:[ud objectForKey:TOKENXX]];;
}

//判断是否登录
+(BOOL)islogin{
    NSString *pas = [[NSUserDefaults standardUserDefaults] valueForKey:ISLOGINED];
    if (pas == nil || [pas isEqualToString:@""] ) {
        //未登录
        return NO;
    }
    return YES;
}


@end
