//
//  XialaMenuView.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/8/29.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XialaMenuView : UIView
-(void)setviewWith:(NSArray *)arr currentstr:(NSString *)str;
-(void)show;
-(void)dissmiss;
@property(copy,nonatomic) void (^clickBlock) (NSString *,NSString *);
@end
