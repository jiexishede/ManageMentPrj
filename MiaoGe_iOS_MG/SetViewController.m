//
//  SetViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "SetViewController.h"
#import "UserLoginViewController.h"
#import "ChangePwdViewController.h"
#import "XClientApi.h"
#import "UIAlertView+Additions.h"

@interface SetViewController ()
@property(nonatomic,strong) UIScrollView *scrolv;
@property(nonatomic,strong) CustomButton *changebtn;
@property(nonatomic,strong) CustomButton *exitbtn;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@"设置" forKey:TitleText];
    [parms setValue:@"backiror_img" forKey:Left_FLAG];
    [self inxtitle:parms style:@"0"];
    [self buildv];
}

-(void)buildv{
    _changebtn = [[CustomButton alloc]init];
    _changebtn.frame = CGRectMake(0,10,ViewSizeW,44);
    _changebtn.backgroundColor = WhiteColor;
    _changebtn.titleLbl = [[UILabel alloc]init];
    [UtilClass lblatrr:_changebtn.titleLbl font:FontSystem_15 color:BlackColor alignment:NSTextAlignmentLeft text:@"修改密码"];
    [_changebtn.titleLbl sizeToFit];
    _changebtn.titleLbl.center = CGPointMake(10+_changebtn.titleLbl.frame.size.width/2,22);
    [_changebtn addSubview:_changebtn.titleLbl];
    
    _changebtn.imgv = [[UIImageView alloc]init];
    _changebtn.imgv.image = [UIImage imageNamed:@"rightarrow_img"];
    [_changebtn.imgv sizeToFit];
    _changebtn.imgv.center = CGPointMake(ViewSizeW-10-_changebtn.imgv.frame.size.width/2,22);
    [_changebtn addSubview:_changebtn.imgv];
    [_changebtn addTarget:self action:@selector(changepress:) forControlEvents:UIControlEventTouchUpInside];
    
    _exitbtn = [[CustomButton alloc]init];
    [UtilClass btnatrr:_exitbtn font:FontSystem_15 color:Color_Red_Caution backcolor:WhiteColor text:@"退出登录"];
    _exitbtn.frame = CGRectMake(0,10+44+10,ViewSizeW,44);
    [_exitbtn addTarget:self action:@selector(exitpress:) forControlEvents:UIControlEventTouchUpInside];

    _scrolv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,topheadh,ViewSizeW, viewhight-topheadh)];
    _scrolv.backgroundColor = Color_Main1;
    _scrolv.showsVerticalScrollIndicator = NO;
    _scrolv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrolv];
    _scrolv.contentSize = CGSizeMake(0,viewhight-topheadh+1);
    [_scrolv addSubview:_exitbtn];
    [_scrolv addSubview:_changebtn];
}

-(void)exitpress:(CustomButton *)sender{
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex ==1) {
            [self setHUDshow];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [[XClientApi sharedClient]postPath:LoginOutApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self hideHUD];
                NSString *s = [UtilClass GetString:[responseObject objectForKey:Status]];
                if ([s isEqualToString:@"1"]) {
                    //清除相关信息
                    [defaults setObject:@"" forKey:TOKENXX];
                    [defaults setObject:@"" forKey:PASSWORD];
                    [defaults setObject:@"" forKey:SHOPID];
                    [defaults setObject:@"" forKey:ISLOGINED];
       
                    [defaults synchronize];
                    
                    if(app.sed.infomodel){
                        app.sed.infomodel = nil;
                    }
                    [self tishi:@"你已成功退出登录"];
                    UserLoginViewController *page = [[UserLoginViewController alloc]init];
                    [self.navigationController pushViewController:page animated:YES];
                }else{
                    [self tishi:[responseObject objectForKey:MSG]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHUD];
            }];
        }
    } title:nil message:@"确定要退出登录么？" cancelButtonName:@"取消" otherButtonTitles:@"确定",nil];
}

-(void)changepress:(CustomButton *)sender{
    ChangePwdViewController *page = [[ChangePwdViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
