//
//  BarRootViewController.m
//  BaDian
//
//  Created by sgp on 15/4/2.
//  Copyright (c) 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "BarRootViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "IndexViewController.h"
#import "MiaoDaXueViewController.h"
#import "MiaoCeHuaViewController.h"

@interface BarRootViewController (){
    NSUserDefaults *defaults;
    NSArray *backgroud;
    NSArray *heightBackground;
    NSArray *buttonarr;
    NSArray *titlearr;
    NSInteger tabindex ;
    AppDelegate *app;
}
@property(nonatomic,strong)UIView *tabBarView;
@property(nonatomic,strong)UIImageView *hongdview; //消息提示
@end
@implementation BarRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = [AppDelegate getAppDelegate];
    [app.HUD hide:YES];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_Main1;
    self.delegate = self;
    tabindex = 0;
    //tabBarItem中的按钮
    backgroud = @[@"bar_img0",@"bar_img1",@"bar_img2",@"bar_img3"];
    //tabBarItem中高亮时候的按钮
    heightBackground = @[@"bar_img0_press",@"bar_img1_press",@"bar_img2_press",@"bar_img3_press"];
    //title
    titlearr = @[@"首页",@"喵客大学",@"聚宝策划",@"我的"];
    
    HomeViewController *busc = [[HomeViewController alloc]init];
    UITabBarItem *item0 = [[UITabBarItem alloc]initWithTitle:titlearr[0] image:[UIImage imageNamed:backgroud[0]] selectedImage:[UIImage imageNamed:heightBackground[0]]];
    item0.selectedImage = [[UIImage imageNamed:heightBackground[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    busc.tabBarItem = item0;
    
    MiaoDaXueViewController *mkjb = [[MiaoDaXueViewController alloc]init];
    mkjb.urlstr = MkjbApi;
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:titlearr[1] image:[UIImage imageNamed:backgroud[1]] selectedImage:[UIImage imageNamed:heightBackground[1]]];
    item1.selectedImage = [[UIImage imageNamed:heightBackground[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mkjb.tabBarItem = item1;
    
    MiaoCeHuaViewController *cehua = [[MiaoCeHuaViewController alloc]init];
    cehua.urlstr = MkchApi;
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:titlearr[2] image:[UIImage imageNamed:backgroud[2]] selectedImage:[UIImage imageNamed:heightBackground[2]]];
    item2.selectedImage = [[UIImage imageNamed:heightBackground[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cehua.tabBarItem = item2;
    
    MineViewController *myc = [[MineViewController alloc]init];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:titlearr[3] image:[UIImage imageNamed:backgroud[3]] selectedImage:[UIImage imageNamed:heightBackground[3]]];
    item3.selectedImage = [[UIImage imageNamed:heightBackground[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myc.tabBarItem = item3;
 
    self.viewControllers = @[busc,mkjb,cehua,myc];
    [[UITabBar appearance] setTintColor:Color_Main];
    [[UITabBar appearance] setBackgroundImage:[UtilClass createImageWithColor:WhiteColor]];//设置背景
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBar.frame = CGRectMake(0, ViewSizeH-49, ViewSizeW, 49);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"点击了");
    if ([viewController isKindOfClass:[HomeViewController class]]){

    }else if ([viewController isKindOfClass:[MineViewController class]]){
        tabindex = 3;
    }else if ([viewController isKindOfClass:[MiaoDaXueViewController class]]){
        tabindex = 3;
    }
    else if ([viewController isKindOfClass:[MiaoCeHuaViewController class]]){
        tabindex = 3;
    }
}
@end
