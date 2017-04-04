//
//  MGXViewController.h
//  sgp
//
//  Created by sgp on 16/3/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomButton.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UtilClass.h"

@interface MGXViewController : UIViewController<MBProgressHUDDelegate>
{
    CGFloat viewhight; //屏幕高度
    CGFloat topheadh; //Top高度
    AppDelegate *app;
    NSUserDefaults *defaults;
    MBProgressHUD *HUD;
}

@property(strong,nonatomic)UIView *titlev;
@property(strong,nonatomic)UILabel *titlelbl;
@property(strong,nonatomic)CustomButton *leftbtn; //左按钮
@property(strong,nonatomic)CustomButton *rightbtn;//右按钮
@property(strong,nonatomic)CustomButton *closebtn;//右按钮
@property(strong,nonatomic)UIView *NothingView;
@property(strong,nonatomic)UILabel *tishiLbl;//提示
@property(strong,nonatomic)UIView *tishiview;
@property(strong,nonatomic)UILabel *loadLbl;
@property(strong,nonatomic)UIImageView *loadImgv; //加载动画
@property(strong,nonatomic)UIView *loadIv; //等待加载动画

-(void)inxtitle:(NSMutableDictionary *)parms style:(NSString *)stylestr;

-(void)backclick:(id)sender;

-(void)rightclick:(id)sender;

-(void)xToClientblock:(void(^)(void))errorBlock succesBlock:(void (^)(NSString *resCode, NSString *idtstr, id resid))susblock url:(NSString *)url parms:(NSMutableDictionary *)parms;

-(void)tishi:(NSString *)text; //提示信息

-(void)tishi:(NSString *)text delay:(CGFloat)time; //自定义延时

-(void)tips:(NSString *)text withcolore:(NSString *)colore; //提示信息

-(void)removeNothingv;

-(void)nodataSet:(CGFloat)centery msg:(NSString*)msg v:(UIView*)v;

-(void)nodataSet:(CGFloat)centery msg:(NSString*)msg v:(UIView*)v isphoto:(BOOL)flag;
//刷新
- (void)setupRefresh:(id)freshView;

- (void)setupRefreshUP:(id)freshView;

-(void)setfoot:(id)freshView;

-(void)sethead:(id)freshView;

-(void)loadNewData;

-(void)loadMoreData;

//判断登录
-(BOOL)loginis;


//加载动画
//-(void)loadImgvstart;

-(void)showloadIv;

//结束加载动画
//-(void)endloadImgv;

//
-(void)setHUDshow;
//
-(void)hideHUD;

//
-(void)setalpe:(CGFloat)a fresh:(id)freshView;


@end
