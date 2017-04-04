//
//  UIAlertView+Additions.h
//  BaDian
//
//  Created by zhoupingshuang on 15/3/26.
//  Copyright (c) 2015年 zhoupingshuang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);
typedef void(^SumbitBlock)(UIAlertAction *alertAction);
typedef void(^CancelBlock)(UIAlertAction *alertAction);

@interface UIAlertView (Additions) <UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

//ios>=8?
+ (void)newAlertWithVcName:(UIViewController *)Vc cancelBlock:(CancelBlock)cancelBlock submitBlcok:(SumbitBlock)submitBlock backBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock Title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitlesArray:(NSMutableArray *)otherButtonTitlesArray ;

//过时方法，以后删除
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...;

//ios<8
+ (void)alertWithCallBackBlocktttt:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSMutableArray *)otherButtonTitlesArray;

//ios>=8
+(void)alertWithVcTitle:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName  cancelBlock:(CancelBlock)cancelBlock otherButtonTitlesAndBlocksArray:(NSMutableArray *)otherButtonTitlesAndBlocksArray  VcName:(UIViewController *)Vc;

@end
