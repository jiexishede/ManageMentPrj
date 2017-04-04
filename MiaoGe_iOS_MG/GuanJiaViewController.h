//
//  GuanJiaViewController.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/5/26.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "WebBaseViewController.h"
#import "UtilClass.h"

@interface GuanJiaViewController : WebBaseViewController
@property(strong,nonatomic) NSString *urlStr;
@property(strong,nonatomic) NSString *allurlStr;
@property(strong,nonatomic) NSString *titlestr;
@property(strong,nonatomic) NSString *isScan;
@property(copy,nonatomic) void (^RefreshBlock) (void);
@end
