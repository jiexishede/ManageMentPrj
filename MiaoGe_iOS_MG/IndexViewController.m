//
//  IndexViewController.m
//  MiaoGe_iOS
//
//  Created by miaoge_iOS on 16/7/15.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "IndexViewController.h"
#import "BarRootViewController.h"
#import "UserLoginViewController.h"
@interface IndexViewController (){
    UIWindow *imagvWindow;
    UIImageView *imgv;
}
@property(nonatomic,strong) UserLoginViewController *loginPage;
@property(nonatomic,strong) BarRootViewController *barPage;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(imagvWindow == nil){
        imagvWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        imagvWindow.backgroundColor = [UIColor clearColor];
        imagvWindow.userInteractionEnabled = NO;
        imagvWindow.windowLevel = UIWindowLevelStatusBar + 1;
        imagvWindow.hidden = NO;
        UIViewController *emptyView = [[UIViewController alloc]init];
        imagvWindow.rootViewController = emptyView;
    }
    [self inxtitle:nil style:@"0"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize size = app.window.frame.size;
    NSString *imageFilepath;
    if (size.width == 320.0f && size.height == 480.0f) { //4s
        imageFilepath = @"4s";
    }else if (size.width == 320.0f && size.height == 568.0f){ //5s
        imageFilepath = @"5s";
    }else if (size.width == 375.0f && size.height == 667.0f) { //6
        imageFilepath = @"6";
    }else if (size.width == 414.0f && size.height == 736.0f){ //6+
        imageFilepath = @"6p";
    }else if (size.width == 768.0f && size.height == 1024.0f){
        imageFilepath = @"ipad_launch";
    }else {
        imageFilepath = @"ipad_b_launch";
    }
    
    imgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgv.image = [UIImage imageNamed:imageFilepath];
    [imagvWindow addSubview:imgv];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pushindex];
}

-(void)pushindex{
    if([UtilClass islogin]){
        self.barPage = [[BarRootViewController alloc]init];
        [self.navigationController pushViewController:self.barPage animated:YES];
    }else{
        self.loginPage = [[UserLoginViewController alloc]init];
        [self.navigationController pushViewController:self.loginPage animated:YES];
    }
}

-(void)setjpushId{
    if (self.loginPage) {
        self.loginPage.jpushId = [NSString stringWithFormat:@"%@",[defaults objectForKey:JPUSHID]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rmvhud{
    imgv.alpha = 1.f;
    [UIView animateWithDuration:0.5f delay:0.2f options:UIViewAnimationOptionTransitionNone animations:^{
        imgv.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        imgv.alpha = 0.f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imgv.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [imgv setImage:nil];
            imgv = nil;
            [imagvWindow removeFromSuperview];
            imagvWindow = nil;
        }];
    }];
}
@end
