//
//  AppDelegate.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/5/25.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//
#import "AppDelegate.h"
#import "IndexViewController.h"
#import "JPUSHService.h"
#import "UIAlertView+Additions.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import "HomeViewController.h"
#import "BarRootViewController.h"
#import "XClientApi.h"
#import "YuYinModel.h"
#import <Bugly/Bugly.h>
#import "MGVersion.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <AVAudioPlayerDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    //Bugly初始化
    [Bugly startWithAppId:BUGLYKEY];
    
    //设置浏览器代理
    NSString *newAgent = [NSString stringWithFormat:@"MeowGuard/%@",VERSION];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    IndexViewController *indexvc = [[IndexViewController alloc]init];
    self.NavVC = [[MGPanNavigationController alloc]initWithRootViewController:indexvc];
    self.window.rootViewController = self.NavVC;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.window makeKeyAndVisible];
    [self getappurl:ApiServer];
    
    //设置极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY
                          channel:JPUSHTYPE
                 apsForProduction:YES
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"jpushid is %@",registrationID);
            if (!_sed) {
                _sed = [[Seedm alloc]init];
            }
            _sed.jpushid = registrationID;
            //保存到用户偏好
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:registrationID forKey:JPUSHID];
            [ud synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //自定义消息接收通知中心
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    /*
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    /*
     * 推送处理2
     */
    if(launchOptions){
        NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        //app处于非唤起态
        if(remoteNotificationUserInfo){
            breakflag = YES;
            if (!_sed) {
                _sed = [[Seedm alloc]init];
                self.sed.msgcount = @"0";
            }
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            NSDictionary *aps = [remoteNotificationUserInfo objectForKey:@"aps"];
            
            if([aps objectForKey:@"sound"]){
                self.sed.msgcount = [NSString stringWithFormat:@"%d",[self.sed.msgcount intValue]+1];
            }
        }
    }
    
    //版本检测
    [[MGVersion sharedInstance] checkAppVersion:YES base:nil];
    
    return YES;
}

//自定义消息接收
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    if (userInfo != nil)
    {
        //处理你的信息
        if ([userInfo objectForKey:@"extras"]) {
            NSDictionary *extras = [userInfo objectForKey:@"extras"];
            NSString *type = [extras objectForKey:@"type"];
            if (!self.sed) {
                self.sed = [[Seedm alloc]init];
            }
            self.sed.jpushtype = type;
            if(self.sed.jpushtype){
                for (UIViewController *vc in self.NavVC.childViewControllers) {
                    if ([vc isKindOfClass:[BarRootViewController class]]) {
                        BarRootViewController *barVc = (BarRootViewController *)vc;
                        for (UIViewController *vc1 in barVc.childViewControllers) {
                            if ([vc1 isKindOfClass:[HomeViewController class]]) {
                                HomeViewController *page = (HomeViewController *)vc1;
                                [page setHongdian];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)getappurl:(NSString *)apiserver{
    self.MGURLString = apiserver;
}


-(void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
    //当用户退出app，清空token，登录状态
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:@"" forKey:TOKENXX];
//    [ud setObject:@"" forKey:ISLOGINED];
//    [ud synchronize];
}

+(AppDelegate *)getAppDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler{
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (!self.sed) {
        self.sed = [[Seedm alloc]init];
        self.sed.msgcount = @"0";
    }
    self.sed.msgcount = [NSString stringWithFormat:@"%d",[self.sed.msgcount intValue]+1];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if(aps && [aps objectForKey:@"sound"]){
        self.sed.jpushtone = [aps objectForKey:@"sound"];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSString *filePath = [cachesDir stringByAppendingPathComponent:self.sed.jpushtone];
        
        NSString *string = [NSString stringWithFormat:@""];
        if ([fm fileExistsAtPath:filePath]) {
            string = filePath;
        }else{
            string = [[NSBundle mainBundle] pathForResource:self.sed.jpushtone ofType:nil];
        }
        
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:string];
        //初始化音频类 并且添加播放文件
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        //设置代理
        _avAudioPlayer.delegate = self;
        _avAudioPlayer.volume = 1.0;
        _avAudioPlayer.numberOfLoops = 0;
        //播放
        [_avAudioPlayer play];
    }
    
    if(self.sed.jpushtype){
        for (UIViewController *vc in self.NavVC.childViewControllers) {
            if ([vc isKindOfClass:[BarRootViewController class]]) {
                BarRootViewController *barVc = (BarRootViewController *)vc;
                for (UIViewController *vc1 in barVc.childViewControllers) {
                    if ([vc1 isKindOfClass:[HomeViewController class]]) {
                        HomeViewController *page = (HomeViewController *)vc1;
                        NSLog(@"type is%@",self.sed.jpushtype);
                        [page setHongdian];
                    }
                }
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if (!self.sed) {
        self.sed = [[Seedm alloc]init];
        self.sed.msgcount= @"";
    }
    
    self.sed.msgcount = [NSString stringWithFormat:@"%d",[self.sed.msgcount intValue]+1];
    
    if (breakflag) {
        return;
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (!self.sed) {
        self.sed = [[Seedm alloc]init];
    }
    
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if([aps objectForKey:@"sound"]){
        self.sed.jpushtone = [aps objectForKey:@"sound"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSString *filePath = [cachesDir stringByAppendingPathComponent:self.sed.jpushtone];
        
        NSString *string = [NSString stringWithFormat:@""];
        if ([fm fileExistsAtPath:filePath]) {
            string = filePath;
        }else{
            string = [[NSBundle mainBundle] pathForResource:self.sed.jpushtone ofType:nil];
        }
        
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:string];
        //初始化音频类 并且添加播放文件
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        //设置代理
        _avAudioPlayer.delegate = self;
        _avAudioPlayer.volume = 1.0;
        _avAudioPlayer.numberOfLoops = 0;
        //播放
        [_avAudioPlayer play];
    }

    if (self.sed.jpushtype) {
        for (UIViewController *vc in self.NavVC.childViewControllers) {
            if ([vc isKindOfClass:[BarRootViewController class]]) {
                BarRootViewController *barVc = (BarRootViewController *)vc;
                for (UIViewController *vc1 in barVc.childViewControllers) {
                    if ([vc1 isKindOfClass:[HomeViewController class]]) {
                        HomeViewController *page = (HomeViewController *)vc1;
                        [page setHongdian];
                    }
                }
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSDictionary * userInfo = notification.request.content.userInfo;
    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (!self.sed) {
            self.sed = [[Seedm alloc]init];
            self.sed.msgcount = @"0";
        }
        self.sed.msgcount = [NSString stringWithFormat:@"%d",[self.sed.msgcount intValue]+1];
        
        if(self.sed.jpushtype){
            for (UIViewController *vc in self.NavVC.childViewControllers) {
                if ([vc isKindOfClass:[BarRootViewController class]]) {
                    BarRootViewController *barVc = (BarRootViewController *)vc;
                    for (UIViewController *vc1 in barVc.childViewControllers) {
                        if ([vc1 isKindOfClass:[HomeViewController class]]) {
                            HomeViewController *page = (HomeViewController *)vc1;
                            [page setHongdian];
                        }
                    }
                }
            }
        }
    }else{
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知");
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (!self.sed) {
            self.sed = [[Seedm alloc]init];
            self.sed.msgcount = @"0";
        }
        
        self.sed.msgcount = [NSString stringWithFormat:@"%d",[self.sed.msgcount intValue]+1];
        
        if(self.sed.jpushtype){
            for (UIViewController *vc in self.NavVC.childViewControllers) {
                if ([vc isKindOfClass:[BarRootViewController class]]) {
                    BarRootViewController *barVc = (BarRootViewController *)vc;
                    for (UIViewController *vc1 in barVc.childViewControllers) {
                        if ([vc1 isKindOfClass:[HomeViewController class]]) {
                            HomeViewController *page = (HomeViewController *)vc1;
                            [page setHongdian];
                        }
                    }
                }
            }
        }
    }else{
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知");
    }
    completionHandler();  // 系统要求执行这个方法
}

#endif

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"end");
    [_avAudioPlayer pause];
}

// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
    [_avAudioPlayer pause];
}

// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"中断错误！");
    [_avAudioPlayer pause];
}
@end
