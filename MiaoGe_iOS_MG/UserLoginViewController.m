//
//  UserLoginViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/23.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "UserLoginViewController.h"
#import "XClientApi.h"
#import "BarRootViewController.h"
#import "UserInfoModel.h"
#import "IndexViewController.h"

@interface UserLoginViewController () <UITextFieldDelegate,UIScrollViewDelegate>
{
    CGRect keyboardRect;
    double animationDuration;
    CGFloat lastY; //
}
@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,strong) UITextField *nameTf;
@property(nonatomic,strong) UITextField *pwdTf;
@property(nonatomic,strong) UIImageView *accimgv;
@property(nonatomic,strong) UIImageView *pwdimgv;
@property(nonatomic,strong) CustomButton *loginbtn;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    app = [AppDelegate getAppDelegate];
    [app.HUD hide:YES];
    [self buildv];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHiden:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *countrollarr = self.navigationController.viewControllers;
    if ([countrollarr[0] isKindOfClass:[IndexViewController class]]) {
        IndexViewController *myd = countrollarr[0];
        [myd rmvhud];
    }
    app.isscroll = @"0";
}

-(void)buildv{
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,ViewSizeW,viewhight)];
    [self.view addSubview:_scrollview];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.backgroundColor = WhiteColor;
    _scrollview.contentSize = CGSizeMake(0,viewhight);
    _scrollview.delegate = self;
    
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.image = [UIImage imageNamed:@"login_background"];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollview addSubview:imgv];
    imgv.frame = CGRectMake(0,-20,ViewSizeH,viewhight+20);
    
    UILabel *authlbl = [[UILabel alloc]init];
    [UtilClass lblatrr:authlbl font:FontSystem_10 color:WhiteColor alignment:NSTextAlignmentCenter text:@"2016 ©喵歌科技"];
    [authlbl sizeToFit];
    authlbl.center =CGPointMake(ViewSizeW/2,self.scrollview.frame.size.height-40-authlbl.frame.size.height/2);
    [self.scrollview addSubview:authlbl];
    
    UIImageView *iconimgv = [[UIImageView alloc]init];
    iconimgv.image = [UIImage imageNamed:@"logo_img"];
    [iconimgv sizeToFit];
    iconimgv.center = CGPointMake(ViewSizeW/2,topheadh+20+iconimgv.frame.size.height/2);
    [_scrollview addSubview:iconimgv];
    
    UILabel *namelbl = [[UILabel alloc]init];
    [UtilClass lblatrr:namelbl font:[UIFont boldSystemFontOfSize:24.f] color:WhiteColor alignment:NSTextAlignmentCenter text:@"喵管家"];
    [namelbl sizeToFit];
    namelbl.center = CGPointMake(ViewSizeW/2,CGRectGetMaxY(iconimgv.frame)+15+namelbl.frame.size.height/2);
    [_scrollview addSubview:namelbl];
    
    _accimgv = [[UIImageView alloc]init];
    _accimgv.image = [UIImage imageNamed:@"pwdpes_img"];
    [_accimgv sizeToFit];
    _accimgv.center = CGPointMake(20+_accimgv.frame.size.width/2,ViewSizeH/2-topheadh+20);
    [_scrollview addSubview:_accimgv];
    
    _nameTf = [[UITextField alloc]init];
    _nameTf.textColor = WhiteColor;
    _nameTf.frame = CGRectMake(CGRectGetMaxX(_accimgv.frame)+20,_accimgv.center.y-22,ViewSizeW-CGRectGetMaxX(_accimgv.frame)-10-20,44);
    _nameTf.delegate = self;
    _nameTf.clearButtonMode =UITextFieldViewModeWhileEditing;
    _nameTf.keyboardType = UIKeyboardTypeDefault;
    _nameTf.returnKeyType = UIReturnKeyDone;
    _nameTf.placeholder = @"输入用户名";
    [_scrollview addSubview:_nameTf];
    
    if ([defaults objectForKey:ACCOUNT]) {
        _nameTf.text = [defaults objectForKey:ACCOUNT];
    }
    
    UILabel *linv = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_accimgv.frame)+10,ViewSizeW-20,1)];
    [_scrollview addSubview:linv];
    linv.backgroundColor = WhiteColor;
    
    _pwdimgv = [[UIImageView alloc]init];
    _pwdimgv.image = [UIImage imageNamed:@"pwdimg_img"];
    [_pwdimgv sizeToFit];
    _pwdimgv.center = CGPointMake(20+_pwdimgv.frame.size.width/2,ViewSizeH/2-topheadh+20+44+10);
    [_scrollview addSubview:_pwdimgv];
    
    _pwdTf = [[UITextField alloc]init];
    _pwdTf.secureTextEntry = YES;
    _pwdTf.textColor = WhiteColor;
    _pwdTf.frame = CGRectMake(CGRectGetMaxX(_pwdimgv.frame)+20,_pwdimgv.center.y-22,ViewSizeW-20-CGRectGetMaxX(_pwdimgv.frame)-10,44);
    _pwdTf.delegate = self;
    _pwdTf.clearButtonMode =UITextFieldViewModeWhileEditing;
    _pwdTf.keyboardType = UIKeyboardTypeDefault;
    _pwdTf.returnKeyType = UIReturnKeyDone;
    _pwdTf.placeholder = @"输入密码";
    [_scrollview addSubview:_pwdTf];
    
    UILabel *linv1 = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_pwdimgv.frame)+10,ViewSizeW-20,1)];
    [_scrollview addSubview:linv1];
    linv1.backgroundColor = WhiteColor;
    
    _loginbtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_loginbtn addTarget:self action:@selector(loginPress:) forControlEvents:UIControlEventTouchUpInside];
    _loginbtn.layer.cornerRadius = 4.f;
    _loginbtn.layer.masksToBounds = YES;
    [UtilClass btnatrr:_loginbtn font:FontSystem_18 color:WhiteColor backcolor:RGBA(0, 193, 156, 1) text:@"登 录"];
    _loginbtn.frame = CGRectMake(15,CGRectGetMaxY(_pwdTf.frame)+30,ViewSizeW-30,44);
    [_scrollview addSubview:_loginbtn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_nameTf isFirstResponder]) {
        [_nameTf resignFirstResponder];
    }
    if ([_pwdTf isFirstResponder]) {
        [_pwdTf resignFirstResponder];
    }
    return YES;
}

-(void)loginPress:(CustomButton *)sender{
    [self.scrollview endEditing:YES];
    if ([UtilClass IsWhitespace:self.nameTf.text]) {//手机号码
        [self tishi:@"用户名不能为空"];
        return;
    }
    if ([UtilClass IsWhitespace:self.pwdTf.text]) { //密码
        [self tishi:@"密码不能为空"];
        return;
    }
    
    [self setHUDshow];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setObject:self.nameTf.text forKey:@"name"];
    NSString *spwd = [UtilClass md5:self.pwdTf.text];
    [parms setObject:spwd forKey:@"pass"];
    [parms setObject:[NSString stringWithFormat:@"%@",[defaults objectForKey:JPUSHID]] forKey:@"pushId"];
    
    [[XClientApi sharedClient]postPath:LoginApi parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSString *status = [UtilClass GetString:[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            app.sed.infomodel = [[UserInfoModel alloc]initWithDictionary:dic error:nil];
            [defaults setObject:app.sed.infomodel.authToken forKey:TOKENXX];
            [defaults setObject:app.sed.infomodel.account forKey:ACCOUNT];
            [defaults setObject:app.sed.infomodel.name forKey:NAME];
            [defaults setObject:app.sed.infomodel.password forKey:PASSWORD];
            [defaults setObject:app.sed.infomodel.shopId forKey:SHOPID];
            [defaults setObject:app.sed.infomodel.shopName forKey:SHOPNAME];
            
            [defaults setObject:@"logined" forKey:ISLOGINED];
            [defaults synchronize];
            
            BarRootViewController *bar = [[BarRootViewController alloc]init];
            [self.navigationController pushViewController:bar animated:YES];
        }else{
            [self tishi:[responseObject objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma keyboard
- (void)keyboardWillShow:(NSNotification *)notification{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:animationDuration];
    UITextField *temp ;
    if([_nameTf isFirstResponder]){
        temp = _nameTf;
    }else if ([_pwdTf isFirstResponder]){
        temp = _pwdTf;
    }
    //自适应代码
    lastY = temp.frame.origin.y +topheadh ;
    if(lastY > ViewSizeH - topheadh -  kbSize.height){
        CGFloat dx = lastY - ViewSizeH + topheadh + kbSize.height;
        //自适应代码
        [_scrollview setFrame:CGRectMake(_scrollview.frame.origin.x
                                         , -dx, _scrollview.frame.size.width, _scrollview.frame.size.height)];
    }else{
        _scrollview.frame = CGRectMake(0, 0, ViewSizeW, ViewSizeH);
    }
    [UIView commitAnimations];
}

-(void)keyboardWillHiden:(NSNotification *)notification{
    [_scrollview setFrame:CGRectMake(0,0,_scrollview.frame.size.width,_scrollview.frame.size.height)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.scrollview endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _nameTf) {
        
    }
}
@end
