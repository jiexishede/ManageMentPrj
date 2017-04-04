//
//  GuanJiaViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/5/26.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "GuanJiaViewController.h"
#import "QRViewController.h"
#import <MBProgressHUD.h>
#import "CustomButton.h"
#import "XialaMenuView.h"
#import "HomeViewController.h"
#import "BarRootViewController.h"

@interface GuanJiaViewController()
{
    UIButton *hub;
}
@property(strong,nonatomic) NSString *payno;
@property(strong,nonatomic) NSString *payresult;
@property(strong,nonatomic) NSString *currentUrl;
@property(strong,nonatomic) CustomButton *shopBtn;
@property(strong,nonatomic) XialaMenuView *xialaV;
@end

@implementation GuanJiaViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:self.titlestr forKey:TitleText];
    [parms setValue:@"circular_arrow_img" forKey:Right_FLAG];
    [parms setValue:@"backiror_img" forKey:Left_FLAG];
    [parms setValue:@"" forKey:RightImgFlag];
    [self inxtitle:parms style:@"1"];
    
    self.closebtn = [[CustomButton alloc]init];
    [UtilClass btnatrr:self.closebtn font:FontSystem_16 color:WhiteColor backcolor:ClearColor text:@"关闭"];
    [self.closebtn addTarget:self action:@selector(closepress:) forControlEvents:UIControlEventTouchUpInside];
    [self.titlev addSubview:self.closebtn];
    [self.closebtn sizeToFit];
    self.closebtn.center = CGPointMake(CGRectGetMaxX(self.leftbtn.frame)+10,20+22);
    
    if ([self.titlestr isEqualToString:@"酒水提取"]||[self.titlestr isEqualToString:@"酒水寄存"]) {
        self.titlelbl.hidden = YES;
        _shopBtn = [[CustomButton alloc]init];
        [self.titlev addSubview:_shopBtn];
        _shopBtn.imgv = [[UIImageView alloc]init];
        [_shopBtn addSubview:_shopBtn.imgv];
        _shopBtn.imgv.image = [UIImage imageNamed:@"arrdown_img"];
        [_shopBtn.imgv sizeToFit];
        _shopBtn.titleLbl = [[UILabel alloc]init];
        [UtilClass lblatrr:_shopBtn.titleLbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentLeft text:self.titlestr];
        [_shopBtn.titleLbl sizeToFit];
        _shopBtn.frame = CGRectMake((ViewSizeW-(_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width))/2,20,_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width, 44);
        _shopBtn.titleLbl.center = CGPointMake(5+_shopBtn.titleLbl.frame.size.width/2,22);
        [_shopBtn addSubview:_shopBtn.titleLbl];
        _shopBtn.imgv.center = CGPointMake(CGRectGetMaxX(_shopBtn.titleLbl.frame)+5+_shopBtn.imgv.frame.size.width/2,22);
        [_shopBtn addTarget:self action:@selector(clickpressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self loadWebV];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    app.isscroll = @"0";
}

-(void)loadWebV{
    if(self.allurlStr){
        self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.allurlStr]];
    }else{
        if (self.currentUrl&&![self.currentUrl isEqualToString:@""]) {
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]];
        }else{
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",app.MGURLString,self.urlStr]]];
        }
    }
    [self.webV loadRequest:self.webRequest];
     NSLog(@"currenturl is %@",[NSString stringWithFormat:@"%@",self.webRequest.URL.absoluteString]);
}


#pragma mark － 左右按钮
-(void)backclick:(id)sender{
    if([self.webV canGoBack]){
        [self.webV goBack];
    }else if([self.isScan isEqualToString:@"1"]){
        for (UIViewController *vc in app.NavVC.childViewControllers) {
            if ([vc isKindOfClass:[BarRootViewController class]]) {
                BarRootViewController *barVc = (BarRootViewController *)vc;
                barVc.selectedIndex = 0;
                [self.navigationController popToViewController:barVc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightclick:(id)sender{
    //刷新
    [self.webV reload];
}

-(void)closepress:(id)sender{
    if([self.isScan isEqualToString:@"1"]){
        for (UIViewController *vc in app.NavVC.childViewControllers) {
            if ([vc isKindOfClass:[BarRootViewController class]]) {
                BarRootViewController *barVc = (BarRootViewController *)vc;
                barVc.selectedIndex = 0;
                [self.navigationController popToViewController:barVc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickpressed:(CustomButton *)sender{
    hub = [[UIButton alloc]init];
    hub.backgroundColor = ClearColor;
    hub.frame = CGRectMake(0, 0, ViewSizeW, topheadh);
    [hub addTarget:self action:@selector(hudpress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hub];
    
    if (!_xialaV) {
        _xialaV = [[XialaMenuView alloc]init];
    }
    if ([self.titlelbl.text isEqualToString:@"酒水提取"]||[self.titlelbl.text isEqualToString:@"酒水提取明细"]) {
        [_xialaV setviewWith:@[@"酒水提取",@"酒水提取明细"] currentstr:self.shopBtn.titleLbl.text];
    }else{
        [_xialaV setviewWith:@[@"酒水寄存",@"酒水寄存明细",@"酒水存取统计"]currentstr:self.shopBtn.titleLbl.text];
    }
    [self.view addSubview:_xialaV];
    [_xialaV show];
    __weak typeof(self) weakself = self;
    __block typeof(self) blockself = self;
    _xialaV.clickBlock = ^(NSString *title,NSString *url){
        weakself.currentUrl = url;
        [weakself loadWebV];
        blockself->hub.frame = CGRectZero;
    };
    [self.view insertSubview:hub aboveSubview:self.titlev];
}

-(void)hudpress{
    hub.frame = CGRectZero;
    [_xialaV dissmiss];
}


#pragma mark - js
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    [super webxxxView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *urlString = [[request URL] absoluteString];
    self.currentUrl = urlString;
    if ([urlString hasPrefix:@"mgaction://"] ) {
        NSString *tempstr = [urlString substringFromIndex:11];
        if ([tempstr hasPrefix:@"callpay"]) {
            
        }else if([tempstr hasPrefix:@"scancode"]){
            QRViewController *page = [[QRViewController alloc]init];
            page.qrUrlBlock = ^(NSString *str){
//                [self breakwebjsMethod:str];
            };
            [self.navigationController pushViewController:page animated:YES];
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webxxxViewDidFinishLoad:webView];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_shopBtn){
        [UtilClass lblatrr:self.shopBtn.titleLbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentCenter text:title];
        [self.shopBtn.titleLbl sizeToFit];
        self.shopBtn.frame = CGRectMake((ViewSizeW-(_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width))/2,20,_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width, 44);
        self.shopBtn.imgv.center = CGPointMake(CGRectGetMaxX(_shopBtn.titleLbl.frame)+5+_shopBtn.imgv.frame.size.width/2,22);
    }
    if(self.titlestr){
        return;
    }
    [UtilClass lblatrr:self.titlelbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentCenter text:title];
}

//- (void)breakwebjsMethod:(NSString *)payresult{
//    NSString *resultstr = [NSString stringWithFormat:@"scanCode('%@')",payresult];
////    [self.webV stringByEvaluatingJavaScriptFromString:resultstr];
//}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self tishi:@"网络连接失败"];
}
@end
