//
//  NameButton.h
//  BaDian
//
//  Created by zhoupingshuang on 15/4/2.
//  Copyright (c) 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface NameButton : UIButton

@property(strong,nonatomic)NSDictionary *dic;
@property(assign,nonatomic)long daodiantime;
@property(strong,nonatomic)NSString *userid;
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *userpic;
@property(strong,nonatomic)NSString *optionstr;
@property(strong,nonatomic)NSIndexPath *indexpath;
@property(strong,nonatomic)NSMutableArray *arrimg;
@property(nonatomic)NSInteger indexcount; //总共几张
@property(strong,nonatomic)NSURL *imgurl;
@property(strong,nonatomic)NSString *url;
@property(strong,nonatomic)NSString *videourl;
@property(strong,nonatomic)NSArray *temarr;
@property(strong,nonatomic)UIImageView *imgv;
@property(strong,nonatomic)UIImageView *imgv1;
@property(strong,nonatomic)UILabel *lbl;
@property(strong,nonatomic)CustomButton *dltbtn;
@property(strong,nonatomic)NSString *imgflag;//1、一般图,2、addimg

//解决scrollview滑动与根控制器手势冲突
@property(strong,nonatomic)NSString *scrollflag; //非nil

@property(nonatomic)NSInteger index; //第几个
@property(strong,nonatomic)NSString *flag; //0-删除 1-添加 nil-正常
@property(strong,nonatomic)UILabel *namelbl;


//是否被选中
@property(nonatomic,assign)BOOL isSelectedt;
@property(nonatomic)float coinF;

@property(strong,nonatomic)NSString *causeStr; //拒绝原因

//活动报名状态
@property(strong,nonatomic)NSString *substate;

//选择类型标签（酒吧,ktv...）
@property(strong,nonatomic)NSString *zidyFlag; //不为nil，则是自定义


//
@property(strong,nonatomic)UILabel *toplbl;
@property(strong,nonatomic)UILabel *btmlbl;

@end
