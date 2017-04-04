//
//  UIAlertView+Additions.m
//  BaDian
//
//  Created by zhoupingshuang on 15/3/26.
//  Copyright (c) 2015年 zhoupingshuang. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <objc/runtime.h>

static void *UIAlertViewKey = @"UIAlertViewKey";

@implementation UIAlertView (Additions)
//ios>=8.0
+ (void)newAlertWithVcName:(UIViewController *)Vc cancelBlock:(CancelBlock)cancelBlock submitBlcok:(SumbitBlock)submitBlock backBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock Title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitlesArray:(NSMutableArray *)otherButtonTitlesArray{
    if (IOS8) {
        [UIAlertView alertWithVcTitle:title message:message cancelButtonName:cancelButtonName cancelBlock:cancelBlock otherButtonTitlesAndBlocksArray:otherButtonTitlesArray VcName:Vc];

    }else{
        [UIAlertView alertWithCallBackBlocktttt:alertViewCallBackBlock title:title message:message cancelButtonName:cancelButtonName otherButtonTitles:otherButtonTitlesArray];
    }
}

#pragma mark - 以后要删除本段代码
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonName otherButtonTitles: otherButtonTitles, nil];
    NSString *other = nil;
    
    va_list args;
    if (otherButtonTitles) {
        va_start(args, otherButtonTitles);
        while ((other = va_arg(args, NSString*))) {
            [alert addButtonWithTitle:other];
        }
        va_end(args);
    }
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}

+ (void)alertWithCallBackBlocktttt:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSMutableArray *)otherButtonTitlesArray {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonName otherButtonTitles:otherButtonTitlesArray[0][@"title"], nil];
    
    NSInteger count = otherButtonTitlesArray.count;
    
    if (count>=2) {
        for (int i=1;i<count;i++) {
           [alert addButtonWithTitle:otherButtonTitlesArray[i][@"title"]];
            
        }
    }
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}


+(void)alertWithVcTitle:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName  cancelBlock:(CancelBlock)cancelBlock otherButtonTitlesAndBlocksArray:(NSMutableArray *)otherButtonTitlesAndBlocksArray  VcName:(UIViewController *)Vc{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonName  style:UIAlertActionStyleCancel handler:cancelBlock];
    for (NSDictionary *titlesblocks in otherButtonTitlesAndBlocksArray) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:titlesblocks[@"title"] style:UIAlertActionStyleDefault handler:titlesblocks[@"block"]];
        [alertVc addAction:okAction];
    }
    
    [alertVc addAction:cancelAction];
    [Vc presentViewController:alertVc animated:YES completion:nil];
}

- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alertViewCallBackBlock) {
        self.alertViewCallBackBlock(buttonIndex);
    }
}

@end
