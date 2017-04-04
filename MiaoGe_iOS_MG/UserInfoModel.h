//
//  UserInfoModel.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/23.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoModel : JSONModel
@property(nonatomic,strong) NSString <Optional>*id;
@property(nonatomic,strong) NSString <Optional>*account;
@property(nonatomic,strong) NSString <Optional>*password;
@property(nonatomic,strong) NSString <Optional>*shopId;
@property(nonatomic,strong) NSString <Optional>*shopName;
@property(nonatomic,strong) NSString <Optional>*name;
@property(nonatomic,strong) NSString <Optional>*role;
@property(nonatomic,strong) NSString <Optional>*pushId;
@property(nonatomic,strong) NSString <Optional>*createTime;
@property(nonatomic,strong) NSString <Optional>*updateTime;
@property(nonatomic,strong) NSString <Optional>*authToken;
@property(nonatomic,strong) NSString <Optional>*status;
@end
