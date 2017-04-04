//
//  MineViewController.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/23.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//
#import "MineViewController.h"
#import "MineCell.h"
#import "SetViewController.h"
#import "GuanJiaViewController.h"
#import "FebBackViewController.h"
#import "XClientApi.h"

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)UIWebView *callWebview;
@property(strong,nonatomic) CustomButton *shopBtn;
@end
@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = @[@{@"title":@"我的",@"img":@"head_img"},@{@"title":@"商户服务热线",@"img":@"hotcall_img"},@{@"title":@"意见反馈",@"img":@"febback_img"},@{@"title":@"设置",@"img":@"set_img"}].mutableCopy;
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@"" forKey:TitleText];
    [parms setValue:@"" forKey:RightImgFlag];
    [self inxtitle:parms style:@"0"];
    [self getdata];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)buildv{
    if (!self.tableview) {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,topheadh,ViewSizeW,viewhight-topheadh)];
    }
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.tableview.backgroundColor = Color_Main1;
    self.tableview.contentInset = UIEdgeInsetsMake(0,0,49,0);
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsHorizontalScrollIndicator = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_shopBtn) {
        _shopBtn = [[CustomButton alloc]init];
    }
    [self.titlev addSubview:_shopBtn];
    
    NSString *shopNameShort = [UtilClass GetString:[defaults  objectForKey:SHOPNAME]];
    if ([shopNameShort isEqualToString:@""]) {
        if (app.sed.infomodel) {
            shopNameShort = app.sed.infomodel.shopName;
        }
    }
    
    if (!_shopBtn.titleLbl) {
        _shopBtn.titleLbl = [[UILabel alloc]init];
    }
    [UtilClass lblatrr:_shopBtn.titleLbl font:BigFontSystem_20 color:WhiteColor alignment:NSTextAlignmentLeft text:shopNameShort];
    [_shopBtn.titleLbl sizeToFit];
    
    _shopBtn.frame = CGRectMake((ViewSizeW-(_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width))/2,20,_shopBtn.titleLbl.frame.size.width+10+_shopBtn.imgv.frame.size.width, 44);
    _shopBtn.titleLbl.center = CGPointMake(5+_shopBtn.titleLbl.frame.size.width/2,22);
    [_shopBtn addSubview:_shopBtn.titleLbl];
}

-(void)getdata{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [[XClientApi sharedClient]postPath:UserInfoApi parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *s = [UtilClass GetString:[responseObject objectForKey:Status]];
        if ([s isEqualToString:@"1"]) {
            NSDictionary *dic = [responseObject objectForKey:RESULT];
            if(app.sed.infomodel){
                app.sed.infomodel = nil;
            }
            app.sed.infomodel = [[UserInfoModel alloc]initWithDictionary:dic error:nil];
            [self buildv];
        }else{
            [self tishi:[responseObject objectForKey:MSG]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setviewwitharr:_arr withIndex:indexPath];
    
    cell.callBlock = ^(NSString *phonenum){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phonenum];
        if (!self.callWebview) {
            self.callWebview = [[UIWebView alloc] init];
            self.callWebview.scrollView.scrollsToTop = NO;
            [self.view addSubview:self.callWebview];
        }
        [self.callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    };
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 90;
    }else if (indexPath.row == 3){
        return 60;
    }else{
        return 50;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *lbl = [[UILabel alloc]init];
    [UtilClass lblatrr:lbl font:FontSystem_14 color:Color_DeepGray alignment:NSTextAlignmentCenter text:[NSString stringWithFormat:@"当前版本号: v%@",VERSION]];
    lbl.frame = CGRectMake(0,0, ViewSizeW,40);
    return lbl;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        GuanJiaViewController *page = [[GuanJiaViewController alloc]init];
        page.urlStr =  MineApi;
        [self.navigationController pushViewController:page animated:YES];
    }else if(indexPath.row == 1){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-87425396"];
        if (!self.callWebview) {
            self.callWebview = [[UIWebView alloc] init];
            self.callWebview.scrollView.scrollsToTop = NO;
            [self.view addSubview:self.callWebview];
        }
        [self.callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    }else if(indexPath.row == 2){
        FebBackViewController *page = [[FebBackViewController alloc]init];
        page.urlstr =  HzsqApi;
        [self.navigationController pushViewController:page animated:YES];
    }else if(indexPath.row == 3) {
        SetViewController *page = [[SetViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
}

-(void)rightclick:(id)sender{
    
}
@end
