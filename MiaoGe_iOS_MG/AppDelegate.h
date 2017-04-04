//
//  AppDelegate.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/5/25.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "MGPanNavigationController.h"
#import "Seedm.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL breakflag;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *isscroll;
@property (strong, nonatomic) MGPanNavigationController *NavVC;
@property (strong, nonatomic) Seedm *sed;
@property(strong,nonatomic) NSString *MGURLString;
@property(strong,nonatomic) MBProgressHUD *HUD;
+(AppDelegate *)getAppDelegate;
-(void)getappurl:(NSString *)apiserver;

@end

