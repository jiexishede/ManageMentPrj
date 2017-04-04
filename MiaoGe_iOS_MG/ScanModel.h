//
//  ScanModel.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/25.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScanModel : JSONModel
@property(nonatomic,strong) NSString <Optional> *code;
@property(nonatomic,strong) NSString <Optional> *createTime;
@property(nonatomic,strong) NSString <Optional> *id;
@property(nonatomic,strong) NSString <Optional> *status;
@property(nonatomic,strong) NSString <Optional> *target;
@property(nonatomic,strong) NSString <Optional> *type;
@property(nonatomic,strong) NSString <Optional> *updateTime;
@end
