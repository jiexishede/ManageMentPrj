//
//  MiaoCeHuaViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/12/6.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "MiaoCeHuaViewController.h"

@interface MiaoCeHuaViewController ()

@end

@implementation MiaoCeHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:self.titlestr forKey:TitleText];
    [parms setValue:@"circular_arrow_img" forKey:Right_FLAG];
    [parms setValue:@"backiror_img" forKey:Left_FLAG];
    [parms setValue:@"" forKey:RightImgFlag];
    [self inxtitle:parms style:@"1"];
    
    self.closebtn = [[CustomButton alloc]init];
    self.closebtn.hidden = YES;
    self.leftbtn.hidden = YES;
    [UtilClass btnatrr:self.closebtn font:FontSystem_16 color:WhiteColor backcolor:ClearColor text:@"关闭"];
    [self.closebtn addTarget:self action:@selector(closepress:) forControlEvents:UIControlEventTouchUpInside];
    [self.titlev addSubview:self.closebtn];
    [self.closebtn sizeToFit];
    self.closebtn.center = CGPointMake(CGRectGetMaxX(self.leftbtn.frame)+10,20+22);
    
    //修改frame
    self.webV.frame = CGRectMake(0,topheadh-20,ViewSizeW,ViewSizeH-topheadh+20-49);
    
    [self loadWebV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closepress:(id)sender{
    self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlstr]]];
    [self.webV loadRequest:self.webRequest];
}

#pragma mark － 左右按钮
-(void)backclick:(id)sender{
    if([self.webV canGoBack]){
        [self.webV goBack];
    }
}

-(void)rightclick:(id)sender{
    //刷新
    [self.webV reload];
}

-(void)loadWebV{
    if (self.currentUrl&&![self.currentUrl isEqualToString:@""]) {
        self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]];
    }else{
        self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlstr]]];
    }
    [self.webV loadRequest:self.webRequest];
    NSLog(@"currenturl is %@",[NSString stringWithFormat:@"%@",self.webRequest.URL.absoluteString]);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webxxxViewDidFinishLoad:webView];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [UtilClass lblatrr:self.titlelbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentCenter text:title];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    [super webxxxView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *urlString = [[request URL] absoluteString];
    self.currentUrl = urlString;
    if ([urlString isEqualToString:self.urlstr]){
        self.closebtn.hidden = YES;
        self.leftbtn.hidden = YES;
    }else{
        self.closebtn.hidden = NO;
        self.leftbtn.hidden = NO;
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self tishi:@"网络连接失败"];
}

@end
