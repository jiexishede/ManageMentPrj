//
//  ChangePwdViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UIAlertView+Additions.h"
#import "XClientApi.h"
#import "UserLoginViewController.h"
#import "RegexKitLite.h"

@interface ChangePwdViewController () <UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrolv;
@property(nonatomic,strong) UITextField *pwdtf;
@property(nonatomic,strong) UITextField *pwdtf1;
@property(nonatomic,strong) UITextField *pwdtf2;
@property(nonatomic,strong) CustomButton *submitBtn;
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@"修改密码" forKey:TitleText];
    [parms setValue:@"backiror_img" forKey:Left_FLAG];
    [self inxtitle:parms style:@"0"];
    [self buildv];
}

- (void)buildv{
    _scrolv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,topheadh,ViewSizeW, viewhight-topheadh)];
    _scrolv.backgroundColor = WhiteColor;
    _scrolv.delegate = self;
    _scrolv.showsVerticalScrollIndicator = NO;
    _scrolv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrolv];
    _scrolv.contentSize = CGSizeMake(0,viewhight-topheadh+1);
    
    _pwdtf = [[UITextField alloc]init];
    _pwdtf.frame = CGRectMake(10,10,ViewSizeW-20,40);
    _pwdtf.delegate = self;
    _pwdtf.clearButtonMode =UITextFieldViewModeWhileEditing;
    _pwdtf.keyboardType = UIKeyboardTypeDefault;
    _pwdtf.returnKeyType = UIReturnKeyDone;
    _pwdtf.placeholder = @"  输入旧密码";
    _pwdtf.secureTextEntry = YES;
    [_scrolv addSubview:_pwdtf];
    
    _pwdtf1 = [[UITextField alloc]init];
    _pwdtf1.frame = CGRectMake(10,10+40+10,ViewSizeW-20,40);
    _pwdtf1.delegate = self;
    _pwdtf1.clearButtonMode =UITextFieldViewModeWhileEditing;
    _pwdtf1.keyboardType = UIKeyboardTypeDefault;
    _pwdtf1.returnKeyType = UIReturnKeyDone;
    _pwdtf1.placeholder = @"  输入新密码";
    _pwdtf1.secureTextEntry = YES;
    [_scrolv addSubview:_pwdtf1];
    
    _pwdtf2 = [[UITextField alloc]init];
    _pwdtf2.frame = CGRectMake(10,10+40+10+40+10,ViewSizeW-20,40);
    _pwdtf2.delegate = self;
    _pwdtf2.clearButtonMode =UITextFieldViewModeWhileEditing;
    _pwdtf2.keyboardType = UIKeyboardTypeDefault;
    _pwdtf2.returnKeyType = UIReturnKeyDone;
    _pwdtf2.placeholder = @"  确认新密码";
    _pwdtf2.secureTextEntry = YES;
    [_scrolv addSubview:_pwdtf2];
    
    UILabel *fgx1 = [[UILabel alloc]init];
    fgx1.backgroundColor = Color_Main2;
    
    UILabel *fgx2 = [[UILabel alloc]init];
    fgx2.backgroundColor = Color_Main2;
    
    UILabel *fgx3 = [[UILabel alloc]init];
    fgx3.backgroundColor = Color_Main2;
    
    fgx1.frame = CGRectMake(10,CGRectGetMaxY(_pwdtf.frame)+5,ViewSizeW-20,1);
    fgx2.frame = CGRectMake(10,CGRectGetMaxY(_pwdtf1.frame)+5,ViewSizeW-20,1);
    fgx3.frame = CGRectMake(10,CGRectGetMaxY(_pwdtf2.frame)+5,ViewSizeW-20,1);
    
    [_scrolv addSubview:fgx1];
    [_scrolv addSubview:fgx2];
    [_scrolv addSubview:fgx3];
    
    _submitBtn = [[CustomButton alloc]init];
    [_scrolv addSubview:_submitBtn];
    _submitBtn.layer.cornerRadius = 4.f;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.frame= CGRectMake(10,CGRectGetMaxY(_pwdtf2.frame)+50,ViewSizeW-20,44);
    [_submitBtn addTarget:self action:@selector(submitpress:) forControlEvents:UIControlEventTouchUpInside];
    [UtilClass btnatrr:_submitBtn font:FontSystem_15 color:WhiteColor backcolor:RGBA(0, 193, 156, 1) text:@"确认修改"];
}

-(void)submitpress:(CustomButton *)sender{
    if ([UtilClass IsWhitespace:self.pwdtf.text]) {//手机号码
        [self tishi:@"密码不能为空" ];
        return;
    }
    if ([UtilClass IsWhitespace:self.pwdtf1.text]) { //密码
        [self tishi:@"密码不能为空" ];
        return;
    }
    
    if ([UtilClass IsWhitespace:self.pwdtf2.text]) { //密码
        [self tishi:@"密码不能为空" ];
        return;
    }
    
    if(![self.pwdtf2.text isEqualToString:self.pwdtf1.text]){
        [self tishi:@"两次密码输入不一致" ];
        return;
    }
    
    NSString *temp1 = self.pwdtf1.text;
    NSString *temp2 = self.pwdtf2.text;
    NSString  *regex = @"^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$).{6,20}$";
    if (![temp1 isMatchedByRegex:regex]) {
        [self tishi:@"密码需要由数字、字母、特殊字符中两种及两种以上的组合,请修改"];
        return;
    }
    if (![temp2 isMatchedByRegex:regex]) {
        [self tishi:@"密码需要由数字、字母、特殊字符中两种及两种以上的组合,请修改"];
        return;
    }
    if(self.pwdtf.text.length<=6 || self.pwdtf1.text.length <=6 || self.pwdtf2.text.length <=6 ){
        [self tishi:@"密码长度最少7位" ];
        return;
    }
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self setHUDshow];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setValue:[UtilClass md5:_pwdtf.text]  forKey:@"oldPassword"];
            [params setValue:[UtilClass md5:_pwdtf1.text]  forKey:@"newPassword"];
            [params setValue:[UtilClass md5:_pwdtf2.text]  forKey:@"rePassword"];
            [[XClientApi sharedClient]postPath:ChangePwd parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self hideHUD];
                NSString *s = [UtilClass GetString:[responseObject objectForKey:@"status"]];
                if ([s isEqualToString:@"1"]) {
                    [self tishi:@"修改成功,请重新登录"];
                    UserLoginViewController *page = [[UserLoginViewController alloc]init];
                    [self.navigationController pushViewController:page animated:YES];
                }else{
                    [self tishi:[responseObject objectForKey:MSG]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                [self hideHUD];
            }];
        }
    } title:nil message:@"确定要修改密码么" cancelButtonName:@"取消" otherButtonTitles:@"确定",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.scrolv endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.scrolv endEditing:YES];
    return YES;
}
@end
