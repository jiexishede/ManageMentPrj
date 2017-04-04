//
//  CustomButton.h
//  BaDian
//
//  Created by zhoupingshuang on 15/4/1.
//  Copyright (c) 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuModel.h"
@interface CustomButton : UIButton

@property(assign,nonatomic)NSInteger miaobisum;
@property(strong,nonatomic)NSDictionary *pinglundit;
@property(strong,nonatomic)UIImageView *imgvtt;
@property(copy,nonatomic)NSString *resonStr; //退款原因
@property(strong,nonatomic) MenuModel *menuModel;
@property(strong,nonatomic)UILabel *titleLbl;
@property(strong,nonatomic)UILabel *descbl;
@property(strong,nonatomic)UIImageView *imgv;
@property(strong,nonatomic)UIImageView *imgv1;
@property(strong,nonatomic)UIImageView *imgv2;

@property(strong,nonatomic)UIButton *imgBtn;
@property(strong,nonatomic)UIView *buyv;
@property(strong,nonatomic)UILabel *priceCountLbl;
@property(strong,nonatomic)UILabel *noCountPriceLbl;
@property(strong,nonatomic)UILabel *xianLbl;
@property(strong,nonatomic)NSString *remmSearchStr;
@property(strong,nonatomic)NSString *giftid;
@property(strong,nonatomic)NSArray *imgarr;
//目的地经纬度
@property(strong,nonatomic)NSString *locationjingd;
@property(strong,nonatomic)NSString *locationweid;

@property(strong,nonatomic)NSIndexPath *indexpath;
//
@property(strong,nonatomic)UIButton *selectbtn;

//是否选择
@property(nonatomic,assign)BOOL isSelectedt;

//
@property(strong,nonatomic)NSString *statetype;//1：未消费 2：已消费， 3：所有订单

@property(strong,nonatomic)NSString *cityid;
@property(strong,nonatomic)NSString *cityname;

@property(strong,nonatomic)NSString *userid;
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *userpic;
@property(strong,nonatomic)NSString *dynId;

//商户id
@property(strong,nonatomic)NSString *mid;

//商品id
@property(strong,nonatomic)NSString *pid;

@property(nonatomic)NSString * price;
@property(nonatomic)NSInteger restamount;
@property(nonatomic)NSInteger index;


@property(nonatomic,assign)BOOL isSelectAll;

//点击响应范围
@property(nonatomic,assign)CGSize ResponseSize;
@property(nonatomic,assign)BOOL isDefautSize;

@property(strong,nonatomic)UILabel *lbl;

@property(nonatomic)NSInteger pindex;


//当前色
@property(strong,nonatomic)UIColor *dqcolor;
//点击色
@property(strong,nonatomic)UIColor *touchcolor;

-(id)initWithFrame:(CGRect)frame img:(UIImage*)img imgsize:(CGSize)size lbl:(UILabel*)lbl disdance:(CGFloat)dis;

-(void)setFrameImgvLbl:(CGRect)frame dis:(CGFloat)dis;

-(void)setFrameImgvLbl:(CGRect)frame dis:(CGFloat)dis img:(UIImage*)img imgsize:(CGSize)imgsize text:(NSString*)ltext font:(UIFont*)lfont color:(UIColor*)lcolor;

//加阴影
-(void)setshadow;

//加点击效果
-(void)setshadow:(UIColor *)color touchcolor:(UIColor *)touchcolor;
@end
