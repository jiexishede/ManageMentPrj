//
//  MenuModel.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/9/21.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MenuModel : JSONModel
@property(nonatomic,strong) NSString <Optional> *id;
@property(nonatomic,strong) NSString <Optional> *type;
@property(nonatomic,strong) NSString <Optional> *name;
@property(nonatomic,strong) NSString <Optional> *title;
@property(nonatomic,strong) NSString <Optional> *link;
@property(nonatomic,strong) NSString <Optional> *poster;
@property(nonatomic,strong) NSString <Optional> *posterPath;
@property(nonatomic,strong) NSString <Optional> *order;
@property(nonatomic,strong) NSString <Optional> *status;
@property(nonatomic,strong) NSString <Optional> *isNew;
@property(nonatomic,strong) NSString <Optional> *desc;
@end
