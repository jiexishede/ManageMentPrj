//
//  WebBaseViewController.h
//  wanwan
//
//  Created by zhoupingshuang on 15/11/23.
//  Copyright © 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "MGXViewController.h"
#import "NJKWebViewProgress.h"
#import "MJRefresh.h"

@interface WebBaseViewController : MGXViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property(strong,nonatomic)UIWebView *webV;
@property(strong,nonatomic)NSURLRequest *webRequest;

-(void)setcookie;
-(void)setbaseLbl;
-(void)setProgress;

- (void)webxxxViewDidFinishLoad:(UIWebView *)webView;
- (void)webxxxView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webxxxView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType;

@end
