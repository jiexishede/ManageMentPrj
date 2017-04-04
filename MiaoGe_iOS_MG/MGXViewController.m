//
//  MGXViewController.m
//  sgp
//
//  Created by sgp on 16/3/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "MGXViewController.h"
#import "MJRefresh.h"
#import "UserLoginViewController.h"
#import "UIAlertView+Additions.h"
#import <UIKit/UICollectionView.h>
#import "XClientApi.h"
#import "UIAlertView+Additions.h"

@implementation MGXViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.view.backgroundColor = Color_Main1;
    app = [AppDelegate getAppDelegate];
    if (!app.sed) {
        app.sed = [[Seedm alloc]init];
    }
    defaults = [NSUserDefaults standardUserDefaults];
    viewhight = ViewSizeH;
    topheadh = TopHeadHight;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 0, ViewSizeW, ViewSizeH);
    app.isscroll = @"1";
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [HUD removeFromSuperview];
    HUD = nil;
    HUD.delegate=nil;
}


-(void)inxtitle:(NSMutableDictionary *)parms style:(NSString *)stylestr{  //stylestr 0:为正常 1:限制
    if (!parms) {
        return;
    }
    
    CGSize size;
    UIFont *fon = FontSystem_16;
    CGFloat offset = 0;
    
    self.titlev = [[UIView alloc]init];
    self.titlev.backgroundColor = Color_Main;
    [self.view addSubview:self.titlev];
    
    self.titlelbl = [[UILabel alloc]init];
    self.titlelbl.backgroundColor = [UIColor clearColor];
    [self.titlev addSubview:self.titlelbl];
    if ([parms valueForKey:TitleText]) {
        [UtilClass lblatrr:self.titlelbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentCenter text:self.titlelbl.text = [parms valueForKey:TitleText]];
    }
    
    self.leftbtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    self.leftbtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.leftbtn];
    if ([parms valueForKey:Left_FLAG]){
        if ([parms valueForKey:NoLeftImgFlag]) {
            [UtilClass btnatrr:self.leftbtn font:fon color:[UIColor whiteColor] backcolor:[UIColor clearColor] text:[parms valueForKey:Left_FLAG]];
        }else{
            [self.leftbtn setImage:[UIImage imageNamed:[parms valueForKey:Left_FLAG]] forState:UIControlStateNormal];
        }
    }
    
    [self.leftbtn addTarget:self action:@selector(backclick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightbtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    self.rightbtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rightbtn];
    if ([parms valueForKey:Right_FLAG]) {
        if ([parms valueForKey:RightImgFlag]) {//图片
            [self.rightbtn setImage:[UIImage imageNamed:[parms valueForKey:Right_FLAG]] forState:UIControlStateNormal];
        }else{
            [UtilClass btnatrr:self.rightbtn font:fon color:[UIColor whiteColor] backcolor:[UIColor clearColor] text:[parms valueForKey:Right_FLAG]];
        }
    }
    
    [self.rightbtn addTarget:self action:@selector(rightclick:) forControlEvents:UIControlEventTouchUpInside];
    self.titlev.frame = CGRectMake(0, 0, ViewSizeW, topheadh);
    
    //////////left
    if ([parms valueForKey:Left_FLAG]) {
        if ([parms valueForKey:NoLeftImgFlag]) {
            size = LBL_TEXTSIZE([parms valueForKey:Left_FLAG], fon);
            size.width = size.width>44 ? size.width:44;
            offset = 0;
        }else{
            size.width = 44;
            offset = 0;
        }
        self.leftbtn.frame = CGRectMake(offset, 20, size.width, 44);
    }
    
    /////////right
    if ([parms valueForKey:Right_FLAG]) {
        if (![parms valueForKey:RightImgFlag]) {
            size = LBL_TEXTSIZE([parms valueForKey:Right_FLAG], fon);
            size.width = size.width>44 ? size.width:44;
            offset = 0;
        }else{
            size.width = 44;
            offset = 0;
        }
        self.rightbtn.frame = CGRectMake(ViewSizeW-size.width-offset, 20, size.width, 44);
    }
    
    if([stylestr isEqualToString:@"1"]){
        self.titlelbl.frame = CGRectMake(self.leftbtn.frame.size.width+15+10,20,ViewSizeW-2*(self.leftbtn.frame.size.width+15+5),topheadh-20);
    }
    
    if ([stylestr isEqualToString:@"0"]) {
        self.titlelbl.frame = CGRectMake(self.leftbtn.frame.origin.x+self.leftbtn.frame.size.width+5,20, ViewSizeW-2*(self.leftbtn.frame.origin.x+self.leftbtn.frame.size.width+5),topheadh-20);
    }
}

-(void)backclick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightclick:(id)sender{
    
}

-(void)tips:(NSString *)text withcolore:(NSString *)colore{//提示信息
    if(self.tishiLbl){
        return;
    }
    self.tishiLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [UtilClass lblatrr:self.tishiLbl font:FontSystem_15 color:WhiteColor alignment:NSTextAlignmentLeft text:text];
    self.tishiLbl.backgroundColor = [UIColor clearColor];
    self.tishiLbl.numberOfLines = 0;
    CGSize size = [self.tishiLbl sizeThatFits:CGSizeMake(ViewSizeW-40, 100)];
    self.tishiLbl.frame = CGRectMake(0, 0, size.width, size.height);
    self.tishiLbl.center =  CGPointMake(ViewSizeW/2, topheadh-10 - size.height/2);
    
    [self.tishiview removeFromSuperview];
    self.tishiview = nil;
    self.tishiview = [[UIView alloc]initWithFrame:CGRectMake(0, -topheadh/2, ViewSizeW, topheadh)];
    //self.tishiview.layer.cornerRadius = 4.0f;
    if(colore){
        self.tishiview.backgroundColor = [UtilClass colorWithHexString:colore];
    }else{
        self.tishiview.backgroundColor = RGBA(0, 193, 156, 1);
    }
    
    [self.tishiview addSubview:self.tishiLbl];
    [UIView animateWithDuration:0.5 animations:^{
        self.tishiview.center = CGPointMake(ViewSizeW/2, topheadh/2);
    }];
    
    [app.window addSubview:self.tishiview];
    [self performSelector:@selector(rmoveTips) withObject:nil afterDelay:1.5];
}

-(void)rmoveTips{
    [UIView animateWithDuration:0.3 animations:^{
        self.tishiview.center = CGPointMake(ViewSizeW/2, -topheadh/2);
    } completion:^(BOOL finished) {
        self.tishiLbl.text = @"";
        [self.tishiLbl removeFromSuperview];
        self.tishiLbl = nil;
        
        [self.tishiview removeFromSuperview];
        self.tishiview = nil;
    }];
}

-(void)tishi:(NSString *)text{
    if (self.tishiLbl) {
        return;
    }
    
    if (!text || [text isEqualToString:@""]){
        text = @"系统忙，请稍后再试";
    }
    
    self.tishiLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [UtilClass lblatrr:self.tishiLbl font:FontSystem_15 color:WhiteColor alignment:NSTextAlignmentLeft text:text];
    self.tishiLbl.backgroundColor = [UIColor clearColor];
    self.tishiLbl.numberOfLines = 0;
    CGSize size = [self.tishiLbl sizeThatFits:CGSizeMake(ViewSizeW-40, 100)];
    self.tishiLbl.frame = CGRectMake(10, 10, size.width, size.height);
    
    [self.tishiview removeFromSuperview];
    self.tishiview = nil;
    self.tishiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+20, size.height+20)];
    self.tishiview.layer.cornerRadius = 4.0f;
    self.tishiview.backgroundColor = [UtilClass colorWithHexString:@"000000" alpha:0.7];
    [self.tishiview addSubview:self.tishiLbl];
    self.tishiview.center = CGPointMake(ViewSizeW/2, ViewSizeH/2);
    
    [app.window addSubview:self.tishiview];
    
    [self performSelector:@selector(rmoveTishi) withObject:nil afterDelay:1.5];
}

-(void)tishi:(NSString *)text delay:(CGFloat)time{
    if (self.tishiLbl) {
        return;
    }
    
    if (!text || [text isEqualToString:@""]){
        text = @"系统忙，请稍后再试";
    }
    
    self.tishiLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [UtilClass lblatrr:self.tishiLbl font:FontSystem_14 color:WhiteColor alignment:NSTextAlignmentLeft text:text];
    self.tishiLbl.backgroundColor = [UIColor clearColor];
    self.tishiLbl.numberOfLines = 0;
    
    CGSize size = [self.tishiLbl sizeThatFits:CGSizeMake(ViewSizeW-40, 100)];
    
    self.tishiLbl.frame = CGRectMake(10, 10, size.width, size.height);
    
    [self.tishiview removeFromSuperview];
    self.tishiview = nil;
    self.tishiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+20, size.height+20)];
    self.tishiview.layer.cornerRadius = 4.0f;
    self.tishiview.backgroundColor = [UtilClass colorWithHexString:@"000000" alpha:0.65];
    [self.tishiview addSubview:self.tishiLbl];
    self.tishiview.center = CGPointMake(ViewSizeW/2, ViewSizeH/2);
    
    [app.window addSubview:self.tishiview];
    
    [self performSelector:@selector(rmoveTishi) withObject:nil afterDelay:time];
}

-(void)rmoveTishi{
    self.tishiLbl.text = @"";
    [self.tishiLbl removeFromSuperview];
    self.tishiLbl = nil;
    
    [self.tishiview removeFromSuperview];
    self.tishiview = nil;
}

//无数据显示
-(void)nodataSet:(CGFloat)centery msg:(NSString*)msg v:(UIView*)v {
    self.NothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.NothingView.userInteractionEnabled = NO;
    self.NothingView.backgroundColor = [UIColor clearColor];
    if (v) {
        [v addSubview:self.NothingView];
    }else{
        [self.view addSubview:self.NothingView];
    }
    
    UIImage *imgt = [UIImage imageNamed:@"nothing_img"];
    UIImageView *imgv = [[UIImageView alloc]initWithImage:imgt];
    imgv.center = CGPointMake(ViewSizeW/2, imgv.frame.size.height/2);
    [self.NothingView addSubview:imgv];
    
    UILabel *lbl = [[UILabel alloc]init];
    [UtilClass lblatrr:lbl font:FontSystem_14 color:Color_Gray alignment:NSTextAlignmentCenter text:msg];
    CGSize size = LBL_TEXTSIZE(lbl.text, lbl.font);
    lbl.frame = CGRectMake(0, 0, size.width, size.height);
    lbl.center = CGPointMake(ViewSizeW/2, imgv.frame.origin.y+imgv.frame.size.height+10+size.height/2);
    [self.NothingView addSubview:lbl];
    
    self.NothingView.frame = CGRectMake(0, 0, ViewSizeW, lbl.frame.origin.y+lbl.frame.size.height);
    self.NothingView.center = CGPointMake(ViewSizeW/2, centery);
}

-(void)nodataSet:(CGFloat)centery msg:(NSString*)msg v:(UIView*)v isphoto:(BOOL)flag{
    self.NothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.NothingView.userInteractionEnabled = NO;
    self.NothingView.backgroundColor = [UIColor clearColor];
    if (v) {
        [v addSubview:self.NothingView];
    }else{
        [self.view addSubview:self.NothingView];
    }
    
    UILabel *lbl = [[UILabel alloc]init];
    [UtilClass lblatrr:lbl font:FontSystem_14 color:[UtilClass colorWithHexString:@"a4a4a4"] alignment:NSTextAlignmentCenter text:msg];
    CGSize size = LBL_TEXTSIZE(lbl.text, lbl.font);
    lbl.frame = CGRectMake(0, 0, size.width, size.height);
    lbl.center = CGPointMake(ViewSizeW/2,10+size.height/2);
    [self.NothingView addSubview:lbl];
    
    self.NothingView.frame = CGRectMake(0,0,ViewSizeW,lbl.frame.origin.y+lbl.frame.size.height);
    self.NothingView.center = CGPointMake(ViewSizeW/2, centery);
}

-(void)removeNothingv{
    
    if (!self.NothingView) {
        return;
    }
    
    for (UIView *v in self.NothingView.subviews) {
        [v removeFromSuperview];
    }
    
    [self.NothingView removeFromSuperview];
    self.NothingView = nil;
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh:(id)freshView{
    [self sethead:freshView];
    [self setfoot:freshView];
}

//上拉刷新
- (void)setupRefreshUP:(id)freshView{
    [self setfoot:freshView];
}

//修改透明度
-(void)setalpe:(CGFloat)a fresh:(id)freshView{
    UIScrollView *pfresh;
    if ([freshView isKindOfClass:[UIScrollView class]]) {
        pfresh = (UIScrollView*)freshView;
    }else if ([freshView isKindOfClass:[UITableView class]]){
        pfresh = (UITableView*)freshView;
    }else if ([freshView isKindOfClass:[UICollectionView class]]){
        pfresh = (UICollectionView*)freshView;
    }
    
    if (!pfresh) {
        return;
    }
    
//    [pfresh.gifHeader setImgsAlpha:a];
}

-(void)sethead:(id)freshView{
    
    UIScrollView *pfresh;
    if ([freshView isKindOfClass:[UIScrollView class]]) {
        pfresh = (UIScrollView*)freshView;
    }else if ([freshView isKindOfClass:[UITableView class]]){
        pfresh = (UITableView*)freshView;
    }else if ([freshView isKindOfClass:[UICollectionView class]]){
        pfresh = (UICollectionView*)freshView;
    }
    
    if (!pfresh) {
        return;
    }
    
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [pfresh addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 隐藏时间
    pfresh.header.updatedTimeHidden = YES;
    
    // 隐藏状态
    pfresh.header.stateHidden = YES;
    
    //背景颜色
    //    pfresh.header.backgroundColor = WhiteColor;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"layer_%zd", i]];
        if (image) {
            [idleImages addObject:image];
        }
    }
    [pfresh.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"layer_%zd", i]];
        if (image) {
            [refreshingImages addObject:image];
        }
    }
    [pfresh.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
}


-(void)setfoot:(id)freshView{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [freshView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

-(void)loadNewData{
    
}

-(void)loadMoreData{
    
}

#pragma 判断是否登录
-(BOOL)loginis{
    if (![UtilClass islogin]) {
        //未登录
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex){
            if(buttonIndex == 1){
                UserLoginViewController*page = [[UserLoginViewController alloc]init];
                [self.navigationController pushViewController:page animated:YES];
            }
        } title:nil message:@"登录后就能使用此功能~" cancelButtonName:@"取消" otherButtonTitles:@"立即登录",nil];
        return NO;
    }
    return YES;
}

-(void)xToClientblock:(void(^)(void))errorBlock succesBlock:(void (^)(NSString *resCode, NSString *idtstr, id resid))susblock url:(NSString *)url parms:(NSMutableDictionary *)parms{
   
}



-(void)showloadIv{
    if(!_loadIv){
        _loadIv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewSizeW, ViewSizeH)];
        _loadIv.backgroundColor = [UtilClass colorWithHexString:@"000000" alpha:0.6];
        _loadIv.userInteractionEnabled = YES;
        [self.view addSubview:_loadIv];
        //    [self.view bringSubviewToFront:_loadIv];
        UIImageView *customview =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sky_load3_img"]];
        customview.center = CGPointMake(ViewSizeW/2, ViewSizeH/2);
        NSArray *magesArray = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"sky_load1_img"],
                               [UIImage imageNamed:@"sky_load2_img"],
                               [UIImage imageNamed:@"sky_load3_img"],
                               [UIImage imageNamed:@"sky_load4_img"],
                               nil];
        
        customview.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
        customview.animationDuration = 0.8;//设置动画时间
        customview.animationRepeatCount = 0;//设置动画次数 0 表示无限
        [customview startAnimating];//开始播放动画
        [_loadIv addSubview:customview];
    }
}

-(void)setHUDshow{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
}

-(void)hideHUD{
    [HUD hide:YES];
}

@end
