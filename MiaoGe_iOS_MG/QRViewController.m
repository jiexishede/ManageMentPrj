//
//  QRViewController.m
//  wanwan
//
//  Created by cyj on 15/12/1.
//  Copyright © 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import "QRUtil.h"
#import "UIAlertView+Additions.h"
#import "XClientApi.h"
#import "ScanModel.h"
#import "GuanJiaViewController.h"

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIButton *canclebtn;
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) QRView *qrView;
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@"扫一扫" forKey:TitleText];
    [parms setValue:@"backiror_img" forKey:Left_FLAG];
    [parms setValue:@"" forKey:RightImgFlag];
    [self inxtitle:parms style:@"0"];
    
    [self configUI];
    [self updateLayout];
    [self setHUDshow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![_session isRunning]) {
        [self performSelector:@selector(defaultConfig) withObject:nil afterDelay:1.0f];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_preview removeFromSuperlayer];
    [_qrView removeFromSuperview];
    [_session stopRunning];
}

- (void)defaultConfig {
    [self hideHUD];
    [_qrView startanimation];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
        } title:[error.userInfo valueForKey:@"NSLocalizedDescription"] message:@"请到iPhone的“设置－隐私——相机“中允许访问相机" cancelButtonName:@"确定" otherButtonTitles:nil];
        return;
    }
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    AVCaptureConnection *outputConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    outputConnection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =[QRUtil screenBounds];
    [self.view.layer insertSublayer:_preview atIndex:0];
    _preview.connection.videoOrientation = [QRUtil videoOrientationFromCurrentDeviceOrientation];
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    [_session startRunning];
    
}
- (void)configUI {
    [self.view insertSubview:self.qrView belowSubview:self.titlev];
    self.view.backgroundColor = BlackColor;
    if(!_canclebtn){
        _canclebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [UtilClass btnatrr:_canclebtn font:FontSystem_17 color:WhiteColor backcolor:Color_Main text:@"取消"];
        _canclebtn.frame = CGRectMake(0, ViewSizeH - 50, ViewSizeW, 50);
        [_canclebtn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_canclebtn];
    }
}

- (void)updateLayout {
    _qrView.center = CGPointMake([QRUtil screenBounds].size.width / 2, [QRUtil screenBounds].size.height / 2);
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.qrView.transparentArea.width) / 2,
                                 (screenHeight - self.qrView.transparentArea.height) / 2,
                                 self.qrView.transparentArea.width,
                                 self.qrView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    if (![stringValue isEqualToString:@""]){
        if([stringValue hasPrefix:@"http"]){
            GuanJiaViewController *page = [[GuanJiaViewController alloc]init];
            page.isScan = @"1";
            page.allurlStr = stringValue;
            [self.navigationController pushViewController:page animated:YES];
        }else{
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:stringValue forKey:@"code"];
            [[XClientApi sharedClient]postPath:GetSCanInfo parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *s = [UtilClass GetString:[responseObject objectForKey:Status]];
                if ([s isEqualToString:@"1"]) {
                    NSDictionary *dic = [responseObject objectForKey:@"result"];
                    ScanModel *scanmodel = [[ScanModel alloc]initWithDictionary:dic error:nil];
                    GuanJiaViewController *page = [[GuanJiaViewController alloc]init];
                    
                    page.isScan = @"1";
                    if ([scanmodel.type isEqualToString:@"USER_STOCK"]) {
                        NSString *urlstr = [NSString stringWithFormat:@"%@/%@/code",@"admin/page/pickup",scanmodel.code];
                        page.urlStr = urlstr;
                    }else if([scanmodel.type isEqualToString:@"SALE_ORDER"] ){
                        NSString *urlstr = [NSString stringWithFormat:@"%@/%@/pay",@"admin/page/order",scanmodel.code];
                        page.urlStr = urlstr;
                    }else if([scanmodel.type isEqualToString:@"MCARD_PAY"]){
                        NSString *urlstr = [NSString stringWithFormat:@"%@/%@/pay",@"admin/page/card",scanmodel.code];
                        page.urlStr = urlstr;
                    }else if([scanmodel.type isEqualToString:@"USER_COUPON"]){
                        NSString *urlstr = [NSString stringWithFormat:@"%@/%@/info",@"admin/page/voucher",scanmodel.code];
                        page.urlStr = urlstr;
                    }
                    [self.navigationController pushViewController:page animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[responseObject objectForKey:MSG] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}

-(QRView *)qrView {
    if (!_qrView) {
        CGRect screenRect = [QRUtil screenBounds];
        _qrView = [[QRView alloc] initWithFrame:screenRect];
        _qrView.transparentArea = CGSizeMake(ViewSizeW - 100, ViewSizeW - 100);
        
        _qrView.backgroundColor = [UIColor clearColor];
    }
    return _qrView;
}

-(void)btnclicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
