//
//  WebBaseViewController.m
//  wanwan
//
//  Created by zhoupingshuang on 15/11/23.
//  Copyright © 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "WebBaseViewController.h"
#import "NJKWebViewProgressView.h"
#import "MJRefresh.h"

@interface WebBaseViewController (){
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UILabel *hostlbl;
}
@property(copy,nonatomic)NSString* zhifflag; //1-成功
@property(nonatomic,assign)BOOL isdologin; //是否调用登录接口
@end

@implementation WebBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _zhifflag = @"";
    _isdologin = NO;
    self.webV = [[UIWebView alloc]initWithFrame:CGRectMake(0,topheadh-20,ViewSizeW,ViewSizeH-topheadh+20)];    
    [self.view addSubview:self.webV];
    [self setProgress];
    [self setcookie];
}

-(void)setcookie{
    if ([UtilClass islogin]) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"authToken" forKey:NSHTTPCookieName];
        [cookieProperties setObject:[UtilClass gettoken] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:DoMain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"1" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc]initWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setbaseLbl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.titlev) {
        [self.titlev addSubview:_progressView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webxxxViewDidFinishLoad:(UIWebView *)webView{
    [self hideHUD];
    //清理缓存
    [[NSURLCache sharedURLCache]removeCachedResponseForRequest:self.webRequest];
    [self.webV.scrollView.header endRefreshing];
}

- (void)webxxxView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
    //清理缓存
    [[NSURLCache sharedURLCache]removeCachedResponseForRequest:self.webRequest];
    [self.webV.scrollView.header endRefreshing];
}

- (void)webxxxView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
}

-(void)setbaseLbl{
    if (!self.webRequest.URL.host) {
        return;
    }
    self.webV.backgroundColor = Color_Main1;
    if (!hostlbl) {
        hostlbl = [[UILabel alloc]init];
    }
    hostlbl.backgroundColor = [UIColor clearColor];
    hostlbl.textAlignment = NSTextAlignmentCenter;
    hostlbl.font = FontSystem_12;
    hostlbl.textColor = [UtilClass colorWithHexString:@"cccccc"];
    hostlbl.text = [NSString stringWithFormat:@"网页由%@提供",self.webRequest.URL.host];
    [hostlbl sizeToFit];
    hostlbl.center = CGPointMake(ViewSizeW*0.5, 25+hostlbl.frame.size.height/2);
    [self.webV insertSubview:hostlbl belowSubview:self.webV.scrollView];
    self.webV.scrollView.opaque = NO;
}

-(void)setProgress{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
    }
    
    self.webV.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = CGRectMake(0, 0, ViewSizeW, 64);
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progressBarView.backgroundColor = WhiteColor;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)dealloc
{
    if(self.webV){
        [self.webV stopLoading];
        self.webV.delegate = nil;
    }
}

-(void)loadNewData{
    [self.webV loadRequest:self.webRequest];
}

@end
