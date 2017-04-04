//
//  Seedm.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/7/4.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface Seedm : NSObject
@property(strong,nonatomic) NSString *jpushid;
@property(strong,nonatomic) NSString *jpushtype;
@property(strong,nonatomic) NSString *jpushtone;
@property(strong,nonatomic) UserInfoModel *infomodel;
@property(strong,nonatomic) NSString *msgcount;
@end
