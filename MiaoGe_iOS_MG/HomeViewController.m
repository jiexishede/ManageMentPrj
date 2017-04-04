//
//  HomeViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/23.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "QRViewController.h"
#import "GuanJiaViewController.h"
#import "XClientApi.h"
#import "IndexViewController.h"
#import "XClientApi.h"
#import "UserInfoModel.h"
#import "MenuModel.h"
#import "UIImageView+WebCache.h"
#import "YuYinModel.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView *scrollview;
@property (strong,nonatomic) UILabel *namelbl;
@property(strong,nonatomic) UIView *topv;
@property(strong,nonatomic) CustomButton *scanbtn;
@property(strong,nonatomic) CustomButton *xybtn;
@property(strong,nonatomic) UIView *menuv;
@property(strong,nonatomic) UIView *reportV;
@property(strong,nonatomic)  NSMutableArray *menu1Arr;
@property(strong,nonatomic)  NSMutableArray *reportArr;
@property(strong,nonatomic)  NSMutableArray *menu2Arr;
@property(strong,nonatomic)  NSMutableArray *btnArr;
@property(strong,nonatomic)  GuanJiaViewController *webpage;
@property (strong,nonatomic) UIImageView *hdview;
@property (strong,nonatomic) UILabel *hdlbl;
@property(nonatomic,strong)NSMutableArray *yuyinArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menu1Arr = [[NSMutableArray alloc]init];
    _menu2Arr = [[NSMutableArray alloc]init];
    _reportArr = [[NSMutableArray alloc]init];
    _btnArr = [[NSMutableArray alloc]init];
    [self bulidScanv];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMenuList];
    //为零则清空未读条数
    if (app.sed.msgcount <= 0) {
        if (_hdview && _hdlbl){
            [_hdview removeFromSuperview];
            [_hdlbl removeFromSuperview];
        }
    }else {
        [self setHongdian];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSArray *countrollarr = self.navigationController.viewControllers;
    if ([countrollarr[0] isKindOfClass:[IndexViewController class]]) {
        IndexViewController *myd = countrollarr[0];
        [myd rmvhud];
    }
}

-(void)getMenuList{
    //检查是否开启推送
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请在设置->通知->喵管家开启语音推送" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [[XClientApi sharedClient]postPath:HomeMenuApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *s = [UtilClass GetString:[responseObject objectForKey:Status]];
        if ([s isEqualToString:@"1"]) {
            if (_menu1Arr.count>0) {
                [_menu1Arr removeAllObjects];
            }
            if (_menu2Arr.count>0) {
                [_menu2Arr removeAllObjects];
            }
            if (_reportArr.count > 0) {
                [_reportArr removeAllObjects];
            }
            int tempIndex1 = 0,tempIndex2= 0;
            for (NSDictionary *dic in [responseObject objectForKey:RESULT]){
                MenuModel *menuModel = [[MenuModel alloc]initWithDictionary:dic error:nil];
                if ([menuModel.type isEqualToString:@"GUARD_ANALYSIS"]) {
                    [_reportArr addObject:menuModel];
                }else if([menuModel.type isEqualToString:@"GUARD_REPORT"]){
                    [_menu2Arr addObject:menuModel];
                    menuModel.order =[NSString stringWithFormat:@"%d",tempIndex2];
                }else if([menuModel.type isEqualToString:@"GUARD_SERVICE"]){
                    [_menu1Arr addObject:menuModel];
                    menuModel.order =[NSString stringWithFormat:@"%d",tempIndex1];
                }
                tempIndex1++;
                tempIndex2++;
            }
            [self buildMenuV];
        }else{
            [self tishi:[responseObject objectForKey:MSG]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)bulidScanv{
    _scrollview  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,ViewSizeW,viewhight)];
    _scrollview.backgroundColor = Color_Main1;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = YES;
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    
    _topv = [[UIView alloc]initWithFrame:CGRectMake(0, -20, ViewSizeW,170+34)];
    [_scrollview addSubview:_topv];
    _topv.backgroundColor = Color_Main;
    
    UILabel *lin1 = [[UILabel alloc]init];
    lin1.backgroundColor = Color_Main1;
    [self.scrollview addSubview:lin1];
    lin1.frame = CGRectMake(0,150+24, ViewSizeW,10);
    
    _namelbl = [[UILabel alloc]init];
    [UtilClass lblatrr:_namelbl font:BigFontSystem_18 color:WhiteColor alignment:NSTextAlignmentCenter text:[UtilClass GetString:[defaults objectForKey:SHOPNAME]]];
    [_topv addSubview:_namelbl];
    [_namelbl sizeToFit];
    _namelbl.center = CGPointMake(ViewSizeW/2,20+10+_namelbl.frame.size.height/2);
    
    _scanbtn = [[CustomButton alloc]init];
    [_scanbtn addTarget:self action:@selector(scanpress:) forControlEvents:UIControlEventTouchUpInside];
    [_scanbtn setImage:[UIImage imageNamed:@"home_icon_barcode"] forState:UIControlStateNormal];
    [_scanbtn sizeToFit];
    _scanbtn.center = CGPointMake(ViewSizeW/4,100+10);
    
    UILabel *sclbl = [[UILabel alloc]init];
    [UtilClass lblatrr:sclbl font:FontSystem_14 color:WhiteColor alignment:NSTextAlignmentCenter text:@"扫二维码"];
    [sclbl sizeToFit];
    sclbl.center = CGPointMake(ViewSizeW/4,CGRectGetMaxY(_scanbtn.frame)+sclbl.frame.size.height/2+10);
    [_topv addSubview:sclbl];
    
    _xybtn = [[CustomButton alloc]init];
    [_xybtn addTarget:self action:@selector(xypress:) forControlEvents:UIControlEventTouchUpInside];
    [_xybtn setImage:[UIImage imageNamed:@"home_xiangying_img"] forState:UIControlStateNormal];
    [_xybtn sizeToFit];
    _xybtn.center = CGPointMake(ViewSizeW*3/4,100+10);
    
    UILabel *xylbl = [[UILabel alloc]init];
    [UtilClass lblatrr:xylbl font:FontSystem_14 color:WhiteColor alignment:NSTextAlignmentCenter text:@"服务响应"];
    [xylbl sizeToFit];
    xylbl.center = CGPointMake(ViewSizeW*3/4,CGRectGetMaxY(_xybtn.frame)+xylbl.frame.size.height/2+10);
    [_topv addSubview:xylbl];
    [_topv addSubview:_xybtn];
    [_topv addSubview:_scanbtn];
}

-(void)buildMenuV{
    
    CGFloat lastReport = 0.f;
    CGFloat wd = ViewSizeW/3,lasty = 0;
    int i=0,line1=0,row1=0,j=0,line2=0,row2=0,total=0,temprow=0;
    NSString *tempStr = [NSString stringWithFormat:@""];
    
    NSString *deviceType = @"1"; //默认是iphone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        deviceType = @"2";
        wd = ViewSizeW/4;
    }
    
    if([deviceType isEqualToString:@"1"]){
        
        if(_reportArr.count>0){
            lastReport += 10;
            int tpIndex = 0;
            if (_reportV) {
                [_reportV removeFromSuperview];
                _reportV = nil;
            }
            _reportV = [[UIView alloc]init];
            _reportV.backgroundColor = WhiteColor;
            [_scrollview addSubview:_reportV];
            
            UILabel *xianLbl = [[UILabel alloc]init];
            xianLbl.backgroundColor = Color_Main1;
            xianLbl.frame = CGRectMake(0,0, ViewSizeW, 10);
            [_reportV addSubview:xianLbl];
            
            for (MenuModel *menuModel in _reportArr) {
                CustomButton *reportBtn = [[CustomButton alloc]init];
                reportBtn.backgroundColor = WhiteColor;
                reportBtn.frame = CGRectMake(0,tpIndex*44+10,ViewSizeW,44);
                [_reportV addSubview:reportBtn];
                
                reportBtn.menuModel = menuModel;
                [reportBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *imgv = [[UIImageView  alloc]init];
                [reportBtn addSubview:imgv];
                [imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                
                reportBtn.titleLbl = [[UILabel  alloc]init];
                [UtilClass lblatrr:reportBtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [reportBtn addSubview:reportBtn.titleLbl];
                
                reportBtn.imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                reportBtn.imgv.frame = CGRectMake(0,0,30,30);
                [reportBtn addSubview:reportBtn.imgv];
                
                reportBtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightarrow_img"]];
                [reportBtn addSubview:reportBtn.imgv1];
                [reportBtn.imgv1 sizeToFit];
                reportBtn.imgv1.center = CGPointMake(ViewSizeW-10-reportBtn.imgv1.frame.size.width/2,22);
                
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    imgv.hidden = NO;
                    imgv.frame = CGRectMake(30+10,4,35,35);
                }else{
                    imgv.hidden = YES;
                    imgv.frame = CGRectMake(10+10,4,35,35);
                }
                
                [reportBtn.titleLbl sizeToFit];
                reportBtn.titleLbl.center = CGPointMake(CGRectGetMaxX(imgv.frame)+10+reportBtn.titleLbl.frame.size.width/2,22);
                
                reportBtn.descbl = [[UILabel alloc]init];
                [UtilClass lblatrr:reportBtn.descbl font:FontSystem_13 color:Color_Gray alignment:NSTextAlignmentRight text:menuModel.desc];
                [reportBtn.descbl sizeToFit];
                reportBtn.descbl.center = CGPointMake(CGRectGetMinX(reportBtn.imgv1.frame)-10-reportBtn.descbl.frame.size.width/2,22);
                [reportBtn addSubview:reportBtn.descbl];
                
                reportBtn.lbl = [[UILabel alloc]init];
                reportBtn.lbl.backgroundColor = Color_Main2;
                [reportBtn addSubview:reportBtn.lbl];
                reportBtn.lbl.frame = CGRectMake(0,43.5, ViewSizeW, 0.5);
                
                tpIndex++;
                lastReport += tpIndex*44;
            }
            _reportV.frame = CGRectMake(0, 150+24, ViewSizeW,lastReport);
        }
        
        if (_btnArr.count>0) {
            [_btnArr removeAllObjects];
        }
        
        if (_menu1Arr.count > 0){
            
            if (_menuv) {
                [_menuv removeFromSuperview];
                _menuv = nil;
            }
            _menuv = [[UIView alloc]init];
            _menuv.backgroundColor = WhiteColor;
            [_scrollview addSubview:_menuv];
            
            for (MenuModel *menuModel in _menu1Arr) {
                CustomButton *menubtn = [[CustomButton alloc]init];
                menubtn.menuModel = menuModel;
                menubtn.tag = 100+i;
                [menubtn addTarget:self action:@selector(menuPress:) forControlEvents:UIControlEventTouchUpInside];
                [_menuv addSubview:menubtn];
                
                menubtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                menubtn.imgv1.frame = CGRectMake(0,0,30,30);
                [menubtn addSubview:menubtn.imgv1];
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    menubtn.imgv1.hidden = NO;
                }else{
                    menubtn.imgv1.hidden = YES;
                }
                
                menubtn.imgv = [[UIImageView alloc]init];
                [menubtn addSubview:menubtn.imgv];
                [menubtn.imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                [menubtn.imgv sizeToFit];
                
                menubtn.titleLbl = [[UILabel alloc]init];
                [UtilClass lblatrr:menubtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [menubtn.titleLbl sizeToFit];
                [menubtn addSubview:menubtn.titleLbl];
                
                line1 = i%3;  //列
                row1 = i/3;    //行
                lasty = row1*wd*2/3;
                
                menubtn.frame = CGRectMake(line1*wd,lasty,wd,wd*2/3);
                menubtn.titleLbl.center = CGPointMake(wd/2,wd*2/3-10-menubtn.titleLbl.frame.size.height/2);
                [menubtn.imgv sizeToFit];
                menubtn.imgv.frame = CGRectMake((wd-(wd*2/3-10-10-menubtn.titleLbl.frame.size.height))/2,10,(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height),(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height));
                menubtn.imgv.contentMode = UIViewContentModeScaleAspectFit;
                tempStr = menuModel.type;
                i++;
                
                [_btnArr addObject:menubtn];
            }
            
            if (i%3) {
                lasty = ((i/3)+1)*wd*2/3;
                total += ((i/3)+1)*3;
            }else{
                lasty = (i/3)*wd*2/3;
                total += (i/3)*3;
            }
            
            //分割线
            UILabel *seline  = [[UILabel alloc]init];
            seline.backgroundColor = Color_Main2;
            [self.menuv addSubview:seline];
            seline.frame = CGRectMake(0,lasty,ViewSizeW, 10);
            lasty += 10;
        }
        
        if (_menu2Arr.count > 0){
            if (!_menuv) {
                _menuv = [[UIView alloc]init];
                _menuv.backgroundColor = WhiteColor;
                [_scrollview addSubview:_menuv];
            }
            
            for (MenuModel *menuModel in _menu2Arr) {
                CustomButton *menubtn = [[CustomButton alloc]init];
                menubtn.menuModel = menuModel;
                [menubtn addTarget:self action:@selector(menuPress:) forControlEvents:UIControlEventTouchUpInside];
                [_menuv addSubview:menubtn];
                
                menubtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                menubtn.imgv1.frame = CGRectMake(0,0,30,30);
                [menubtn addSubview:menubtn.imgv1];
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    menubtn.imgv1.hidden = NO;
                }else{
                    menubtn.imgv1.hidden = YES;
                }
                
                menubtn.imgv = [[UIImageView alloc]init];
                [menubtn addSubview:menubtn.imgv];
                [menubtn.imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                [menubtn.imgv sizeToFit];
                
                menubtn.titleLbl = [[UILabel alloc]init];
                [UtilClass lblatrr:menubtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [menubtn.titleLbl sizeToFit];
                [menubtn addSubview:menubtn.titleLbl];
                
                line2 = j%3;  //列
                row2 = j/3;    //行
                lasty += row2*wd*2/3;
                
                menubtn.frame = CGRectMake(line2*wd,lasty,wd,wd*2/3);
                menubtn.titleLbl.center = CGPointMake(wd/2,wd*2/3-10-menubtn.titleLbl.frame.size.height/2);
                [menubtn.imgv sizeToFit];
                menubtn.imgv.frame = CGRectMake((wd-(wd*2/3-10-10-menubtn.titleLbl.frame.size.height))/2,10,(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height),(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height));
                menubtn.imgv.contentMode = UIViewContentModeScaleAspectFit;
                tempStr = menuModel.type;
                j++;
                [_btnArr addObject:menubtn];
            }
            
            if (j%3) {
                total += ((j/3)+1)*3;
            }else{
                total += (j/3)*3;
            }
        }
        
        for(int ix=0;ix<total;ix++){
            line1 = ix%3;  //列
            temprow = ix/3;    //行
            if (ix%3){
                UILabel *sxlbl = [[UILabel alloc]init]; //竖线
                sxlbl.backgroundColor =  Color_Main2;
                sxlbl.frame = CGRectMake(wd*line1,0,1,wd*2/3*(total/3)+10);
                [_menuv addSubview:sxlbl];
                UILabel *hxlbl = [[UILabel alloc]init];  //横线
                hxlbl.backgroundColor = Color_Main2;
                if (row1<temprow) {
                    hxlbl.frame = CGRectMake(0,wd*2/3*temprow+10,ViewSizeW,1);
                }else{
                    hxlbl.frame = CGRectMake(0,wd*2/3*temprow,ViewSizeW,1);
                }
                [_menuv addSubview:hxlbl];
            }
        }
        
        _menuv.frame = CGRectMake(0,150+24+lastReport+10,ViewSizeW,lasty+wd*2/3);
        _scrollview.contentSize = CGSizeMake(0,lasty+wd*2/3+(150+24+lastReport+10)+49);
    }
    
    else{
        
        if(_reportArr.count>0){
            lastReport += 10;
            int tpIndex = 0;
            if (_reportV) {
                [_reportV removeFromSuperview];
                _reportV = nil;
            }
            _reportV = [[UIView alloc]init];
            _reportV.backgroundColor = WhiteColor;
            [_scrollview addSubview:_reportV];
            
            UILabel *xianLbl = [[UILabel alloc]init];
            xianLbl.backgroundColor = Color_Main1;
            xianLbl.frame = CGRectMake(0,0, ViewSizeW, 10);
            [_reportV addSubview:xianLbl];
            
            for (MenuModel *menuModel in _reportArr) {
                CustomButton *reportBtn = [[CustomButton alloc]init];
                reportBtn.backgroundColor = WhiteColor;
                reportBtn.frame = CGRectMake(0,tpIndex*64+10,ViewSizeW,64);
                [_reportV addSubview:reportBtn];
                
                reportBtn.menuModel = menuModel;
                [reportBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *imgv = [[UIImageView  alloc]init];
                [reportBtn addSubview:imgv];
                [imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                
                reportBtn.titleLbl = [[UILabel  alloc]init];
                [UtilClass lblatrr:reportBtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [reportBtn addSubview:reportBtn.titleLbl];
                
                reportBtn.imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                reportBtn.imgv.frame = CGRectMake(0,0,30,30);
                [reportBtn addSubview:reportBtn.imgv];
                
                reportBtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightarrow_img"]];
                [reportBtn addSubview:reportBtn.imgv1];
                [reportBtn.imgv1 sizeToFit];
                reportBtn.imgv1.center = CGPointMake(ViewSizeW-10-reportBtn.imgv1.frame.size.width/2,32);
                
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    imgv.hidden = NO;
                    imgv.frame = CGRectMake(30+10,5,55,55);
                }else{
                    imgv.hidden = YES;
                    imgv.frame = CGRectMake(10+10,5,55,55);
                }
                
                [reportBtn.titleLbl sizeToFit];
                reportBtn.titleLbl.center = CGPointMake(CGRectGetMaxX(imgv.frame)+10+reportBtn.titleLbl.frame.size.width/2,32);
                
                reportBtn.descbl = [[UILabel alloc]init];
                [UtilClass lblatrr:reportBtn.descbl font:FontSystem_13 color:Color_Gray alignment:NSTextAlignmentRight text:menuModel.desc];
                [reportBtn.descbl sizeToFit];
                reportBtn.descbl.center = CGPointMake(CGRectGetMinX(reportBtn.imgv1.frame)-10-reportBtn.descbl.frame.size.width/2,32);
                [reportBtn addSubview:reportBtn.descbl];
                
                reportBtn.lbl = [[UILabel alloc]init];
                reportBtn.lbl.backgroundColor = Color_Main2;
                [reportBtn addSubview:reportBtn.lbl];
                reportBtn.lbl.frame = CGRectMake(0,63.5, ViewSizeW, 0.5);
                
                tpIndex++;
                lastReport += tpIndex*64;
                
            }
            _reportV.frame = CGRectMake(0, 150+24, ViewSizeW,lastReport);
        }
        
        if (_btnArr.count>0) {
            [_btnArr removeAllObjects];
        }
        
        if (_menu1Arr.count > 0){
            if (_menuv) {
                [_menuv removeFromSuperview];
                _menuv = nil;
            }
            _menuv = [[UIView alloc]init];
            _menuv.backgroundColor = WhiteColor;
            [_scrollview addSubview:_menuv];
            
            for (MenuModel *menuModel in _menu1Arr) {
                CustomButton *menubtn = [[CustomButton alloc]init];
                menubtn.menuModel = menuModel;
                menubtn.tag = 100+i;
                [menubtn addTarget:self action:@selector(menuPress:) forControlEvents:UIControlEventTouchUpInside];
                [_menuv addSubview:menubtn];
                
                menubtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                menubtn.imgv1.frame = CGRectMake(0,0,30,30);
                [menubtn addSubview:menubtn.imgv1];
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    menubtn.imgv1.hidden = NO;
                }else{
                    menubtn.imgv1.hidden = YES;
                }
                
                menubtn.imgv = [[UIImageView alloc]init];
                [menubtn addSubview:menubtn.imgv];
                [menubtn.imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                [menubtn.imgv sizeToFit];
                
                menubtn.titleLbl = [[UILabel alloc]init];
                [UtilClass lblatrr:menubtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [menubtn.titleLbl sizeToFit];
                [menubtn addSubview:menubtn.titleLbl];
                
                line1 = i%4;  //列
                row1 = i/4;    //行
                lasty = row1*wd*2/3;
                
                menubtn.frame = CGRectMake(line1*wd,lasty,wd,wd*2/3);
                menubtn.titleLbl.center = CGPointMake(wd/2,wd*2/3-10-menubtn.titleLbl.frame.size.height/2);
                [menubtn.imgv sizeToFit];
                menubtn.imgv.frame = CGRectMake((wd-(wd*2/3-10-10-menubtn.titleLbl.frame.size.height))/2,10,(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height),(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height));
                menubtn.imgv.contentMode = UIViewContentModeScaleAspectFit;
                tempStr = menuModel.type;
                i++;
                
                [_btnArr addObject:menubtn];
            }
            
            if (i%4) {
                lasty = ((i/4)+1)*wd*2/3;
                total += ((i/4)+1)*4;
            }else{
                lasty = (i/4)*wd*2/3;
                total += (i/4)*4;
            }
            
            //分割线
            UILabel *seline  = [[UILabel alloc]init];
            seline.backgroundColor = Color_Main2;
            [self.menuv addSubview:seline];
            seline.frame = CGRectMake(0,lasty,ViewSizeW, 10);
            lasty += 10;
            
        }
        
        if (_menu2Arr.count > 0) {
            if (!_menuv) {
                _menuv = [[UIView alloc]init];
                _menuv.backgroundColor = WhiteColor;
                [_scrollview addSubview:_menuv];
            }
            
            for (MenuModel *menuModel in _menu2Arr) {
                CustomButton *menubtn = [[CustomButton alloc]init];
                menubtn.menuModel = menuModel;
                [menubtn addTarget:self action:@selector(menuPress:) forControlEvents:UIControlEventTouchUpInside];
                [_menuv addSubview:menubtn];
                
                menubtn.imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_icon_new"]];
                menubtn.imgv1.frame = CGRectMake(0,0,30,30);
                [menubtn addSubview:menubtn.imgv1];
                if ([menuModel.isNew isEqualToString:@"1"]) {
                    menubtn.imgv1.hidden = NO;
                }else{
                    menubtn.imgv1.hidden = YES;
                }
                
                menubtn.imgv = [[UIImageView alloc]init];
                [menubtn addSubview:menubtn.imgv];
                [menubtn.imgv sd_setImageWithURL:[NSURL URLWithString:menuModel.posterPath] placeholderImage:nil];
                [menubtn.imgv sizeToFit];
                
                menubtn.titleLbl = [[UILabel alloc]init];
                [UtilClass lblatrr:menubtn.titleLbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentCenter text:menuModel.title];
                [menubtn.titleLbl sizeToFit];
                [menubtn addSubview:menubtn.titleLbl];
                
                line2 = j%4;  //列
                row2 = j/4;    //行
                lasty += row2*wd*2/3;
                
                menubtn.frame = CGRectMake(line2*wd,lasty,wd,wd*2/3);
                menubtn.titleLbl.center = CGPointMake(wd/2,wd*2/3-10-menubtn.titleLbl.frame.size.height/2);
                [menubtn.imgv sizeToFit];
                menubtn.imgv.frame = CGRectMake((wd-(wd*2/3-10-10-menubtn.titleLbl.frame.size.height))/2,10,(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height),(wd*2/3-10-5-10-menubtn.titleLbl.frame.size.height));
                menubtn.imgv.contentMode = UIViewContentModeScaleAspectFit;
                tempStr = menuModel.type;
                j++;
                [_btnArr addObject:menubtn];
            }
            
            if (j%4) {
                total += ((j/4)+1)*4;
            }else{
                total += (j/4)*4;
            }
            
        }
        
        for(int ix=0;ix<total;ix++){
            line1 = ix%4;  //列
            temprow = ix/4;    //行
            if (ix%4){
                UILabel *sxlbl = [[UILabel alloc]init]; //竖线
                sxlbl.backgroundColor =  Color_Main2;
                sxlbl.frame = CGRectMake(wd*line1,0,1,wd*2/3*(total/4)+10);
                [_menuv addSubview:sxlbl];
                
                UILabel *hxlbl = [[UILabel alloc]init];  //横线
                hxlbl.backgroundColor = Color_Main2;
                if (row1<temprow) {
                    hxlbl.frame = CGRectMake(0,wd*2/3*temprow+10,ViewSizeW,1);
                }else{
                    hxlbl.frame = CGRectMake(0,wd*2/3*temprow,ViewSizeW,1);
                }
                [_menuv addSubview:hxlbl];
            }
        }
        
        _menuv.frame = CGRectMake(0,150+24+lastReport+10,ViewSizeW,lasty+wd*2/3);
        _scrollview.contentSize = CGSizeMake(0,lasty+wd*2/3+(150+24+lastReport+10)+49);
    }
    
    [self setHongdian];
}

-(void)reportClick:(CustomButton *)sender{
    if (![sender.menuModel.status isEqualToString:@"ACTIVE"]){
        [self tishi:@"敬请期待"];
        return;
    }
    self.webpage = [[GuanJiaViewController alloc]init];
    self.webpage.urlStr = sender.menuModel.link;
    self.webpage.titlestr = sender.menuModel.title;
    [self.navigationController pushViewController:self.webpage animated:YES];
}

-(void)menuPress:(CustomButton *)sender{
    //清空未读条数
    if (app.sed.msgcount>0) {
        app.sed.msgcount = 0;
    }
    if (![sender.menuModel.status isEqualToString:@"ACTIVE"]){
        [self tishi:@"敬请期待"];
        return;
    }
    self.webpage = [[GuanJiaViewController alloc]init];
    self.webpage.urlStr = sender.menuModel.link;
    self.webpage.titlestr = sender.menuModel.title;
    [self.navigationController pushViewController:self.webpage animated:YES];
}

-(void)xypress:(CustomButton *)sender{
    self.webpage = [[GuanJiaViewController alloc]init];
    self.webpage.urlStr = ServicesCallApi;
    self.webpage.titlestr = @"服务响应";
    [self.navigationController pushViewController:self.webpage animated:YES];
}

-(void)scanpress:(CustomButton *)sender{
    QRViewController *page = [[QRViewController alloc]init];
    page.qrUrlBlock = ^(NSString *urlstr){
        self.webpage = [[GuanJiaViewController alloc]init];
        self.webpage.urlStr = urlstr;
        [self.navigationController pushViewController:self.webpage animated:YES];
    };
    [self.navigationController pushViewController:page animated:YES];
}


-(void)setHongdian{
    if(app.sed.jpushtype && ![app.sed.jpushtype isEqualToString:@""]){
        if ([app.sed.msgcount integerValue] == 0) {
            return;
        }
        for (CustomButton *btn in _btnArr) {
            if ([app.sed.jpushtype isEqualToString: btn.menuModel.name ]){
                if (!_hdview) {
                    _hdview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comm_red_dot"]];
                }
                [_hdview sizeToFit];
                _hdview.center = CGPointMake(ViewSizeW/3-30-_hdview.frame.size.width/2,15+_hdview.frame.size.height/2);
                if (!_hdlbl) {
                    _hdlbl = [[UILabel alloc]init];
                }
                
                [UtilClass lblatrr:_hdlbl font:FontSystem_12 color:WhiteColor alignment:NSTextAlignmentCenter text:app.sed.msgcount];
                [_hdlbl sizeToFit];
                _hdlbl.center = _hdview.center;
                [btn addSubview:_hdview];
                [btn addSubview:_hdlbl];
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
