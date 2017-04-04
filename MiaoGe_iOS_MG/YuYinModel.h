//
//  YuYinModel.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/10/19.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YuYinModel : JSONModel
@property(nonatomic,strong) NSString <Optional>*id;
@property(nonatomic,strong) NSString <Optional>*type;
@property(nonatomic,strong) NSString <Optional>*url;
@property(nonatomic,strong) NSString <Optional>*deviceOs;
@property(nonatomic,strong) NSString <Optional>*newestToneVersion;
@end
