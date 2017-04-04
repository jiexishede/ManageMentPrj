//
//  FebBackViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/12/9.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "FebBackViewController.h"

@interface FebBackViewController ()

@end

@implementation FebBackViewController

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
    [UtilClass btnatrr:self.closebtn font:FontSystem_16 color:WhiteColor backcolor:ClearColor text:@"关闭"];
    [self.closebtn addTarget:self action:@selector(closepress:) forControlEvents:UIControlEventTouchUpInside];
    [self.titlev addSubview:self.closebtn];
    [self.closebtn sizeToFit];
    self.closebtn.center = CGPointMake(CGRectGetMaxX(self.leftbtn.frame)+10,20+22);
 
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
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
    
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    float rw = viewSize.width / contentSize.width;
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    [super webxxxView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *urlString = [[request URL] absoluteString];
    if ([[UtilClass GetString:_currentUrl] isEqualToString:@""]||[[UtilClass GetString:_currentUrl] isEqualToString:self.urlstr]) {
        self.closebtn.hidden = YES;
    }else{
        self.closebtn.hidden = NO;
    }
    self.currentUrl = urlString;
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self tishi:@"网络连接失败"];
}
@end
