//
//  XialaMenuView.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_sgp on 16/8/29.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "XialaMenuView.h"
#import "CustomButton.h"
@interface XialaMenuView(){
    NSInteger i;
}
@end
@implementation XialaMenuView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = WhiteColor;
        self.frame = CGRectMake(0, TopHeadHight, ViewSizeW, 0);
    }
    return self;
}

-(void)setviewWith:(NSArray *)arr currentstr:(NSString *)str{
    i = 0;
    for (NSString *s in arr){
        CustomButton *menubtn = [[CustomButton alloc]init];
        menubtn.frame = CGRectMake(0,i*45,ViewSizeW,45);
        [UtilClass btnatrr:menubtn font:BigFontSystem_20 color:BlackColor backcolor:WhiteColor text:s];
        [menubtn addTarget:self action:@selector(addd:) forControlEvents:UIControlEventTouchUpInside];
        menubtn.username = s;
        UIView *lblv = [[UIView alloc]init];
        lblv.backgroundColor = Color_Main2;
        lblv.frame = CGRectMake(0,44.5,ViewSizeW,0.5);
        [self addSubview:menubtn];
        [menubtn addSubview:lblv];
        
        if ([s isEqualToString:@"酒水寄存"]) {
            menubtn.userid = [NSString stringWithFormat:@"%@%@",ApiServer,@"admin/page/wine"];
        }else if([s isEqualToString:@"酒水寄存明细"]){
            menubtn.userid = [NSString stringWithFormat:@"%@%@",ApiServer,@"admin/page/wine/jcls"];
        }else if([s isEqualToString:@"酒水存取统计"]){
            menubtn.userid =  [NSString stringWithFormat:@"%@%@",ApiServer,@"admin/page/wine/cqtj"];
        }else if([s isEqualToString:@"酒水提取"]){
            menubtn.userid = [NSString stringWithFormat:@"%@%@",ApiServer,@"admin/page/wine/pickup"];
        }else if([s isEqualToString:@"酒水提取明细"]){
            menubtn.userid = [NSString stringWithFormat:@"%@%@",ApiServer,@"admin/page/wine/tqls"];
        }
        if ([str isEqualToString:s]) {
            [menubtn setTitleColor:Color_Main forState:UIControlStateNormal];
        }
        i++;
    }
}

- (void)show{
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = CGRectMake(0, TopHeadHight, ViewSizeW,0);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, TopHeadHight, ViewSizeW,i*45);
    }];
}

-(void)dissmiss{
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, TopHeadHight, ViewSizeW,0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)addd:(CustomButton *)sender{
    [self dissmiss];
    if (self.clickBlock) {
        self.clickBlock(sender.username,sender.userid);
    }
}

-(void)hudpress{
    [self dissmiss];
}
@end
