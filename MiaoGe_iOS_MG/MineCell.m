//
//  MineCell.m
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import "MineCell.h"
#import "UtilClass.h"
@implementation MineCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        app = [AppDelegate getAppDelegate];
        ud  = [NSUserDefaults standardUserDefaults];
        self.backgroundColor = WhiteColor;
        self.contentView.backgroundColor = WhiteColor;
        _arrimgv = [[UIImageView alloc]init];
        _arrimgv.image = [UIImage imageNamed:@"rightarrow_img"];
        _headimgv = [[UIImageView alloc]init];
        _headimgv.image = [UIImage imageNamed:@"head_img"];
        
        _icimgv = [[UIImageView alloc]init];
        [self.contentView addSubview:_icimgv];
        _titlelbl = [[UILabel alloc]init];
        [UtilClass lblatrr:_titlelbl font:FontSystem_14 color:BlackColor alignment:NSTextAlignmentLeft text:@""];
        [self.contentView addSubview:_titlelbl];
        [self.contentView addSubview:_arrimgv];
        [self.contentView addSubview:_headimgv];
        _fgxlbl = [[UILabel alloc]init];
        _fgxlbl.backgroundColor = Color_Main1;
        [self.contentView addSubview:_fgxlbl];
        
        _phonebtn = [[CustomButton alloc]init];
        [_phonebtn addTarget:self action:@selector(callPress:) forControlEvents:UIControlEventTouchUpInside];
        [UtilClass btnatrr:_phonebtn font:FontSystem_14 color:Color_BlueS  backcolor:WhiteColor text:@"0571-87425396"];
        [self.contentView addSubview:_phonebtn];
        
        _fgx1lbl = [[UILabel alloc]init];
        _fgx1lbl.backgroundColor = Color_Main2;
        [self.contentView addSubview:_fgx1lbl];
        
        _namelbl = [[UILabel alloc]init];
        _acclbl = [[UILabel alloc]init];
        [UtilClass lblatrr:_namelbl font:FontSystem_15 color:Color_DeepGray alignment:NSTextAlignmentLeft text:@""];
        [UtilClass lblatrr:_acclbl font:FontSystem_15 color:Color_DeepGray alignment:NSTextAlignmentLeft text:@""];
        [self.contentView addSubview:_namelbl];
        [self.contentView addSubview:_acclbl];
    }
    return self;
}

-(void)setviewwitharr:(NSMutableArray *)arr withIndex:(NSIndexPath*)indexpath{
    _headimgv.hidden = YES;
    _fgxlbl.hidden = YES;
    _phonebtn.hidden = YES;
    _fgx1lbl.hidden = YES;
    _namelbl.hidden = YES;
    _acclbl.hidden = YES;
    
    [_arrimgv sizeToFit];
    if (indexpath.row == 0) {
        _headimgv.hidden = NO;
        _headimgv.layer.cornerRadius = 25;
        _headimgv.layer.masksToBounds = YES;
        _headimgv.frame = CGRectMake(15, 15, 50, 50);
        _fgxlbl.hidden =NO;
        _fgxlbl.frame = CGRectMake(0,80,ViewSizeW,10);
        _arrimgv.center = CGPointMake(ViewSizeW-10-_arrimgv.frame.size.width/2,40);
        
        //用户名账号
        _namelbl.hidden = NO;
        _acclbl.hidden = NO;
        _namelbl.text = [NSString stringWithFormat:@"姓名: %@",app.sed.infomodel.name];
        _acclbl.text = [NSString stringWithFormat:@"账号: %@",app.sed.infomodel.account];

        [_namelbl sizeToFit];
        [_acclbl sizeToFit];
        _namelbl.center = CGPointMake(CGRectGetMaxX(_headimgv.frame)+10+_namelbl.frame.size.width/2, CGRectGetMinY(_headimgv.frame)+5+_namelbl.frame.size.height/2);
        _acclbl.center = CGPointMake(CGRectGetMaxX(_headimgv.frame)+10+_acclbl.frame.size.width/2, CGRectGetMaxY(_namelbl.frame)+5+_acclbl.frame.size.height/2);
    }else if(indexpath.row==3){
        NSMutableDictionary *dic = arr[indexpath.row];
        NSString *title = [dic objectForKey:@"title"];
        NSString *imgstr = [dic objectForKey:@"img"];
        _icimgv.image = [UIImage imageNamed:imgstr];
        [_icimgv sizeToFit];
        _icimgv.center = CGPointMake(15+_icimgv.frame.size.width/2,35);
        
        _titlelbl.text = title;
        [_titlelbl sizeToFit];
        _titlelbl.center = CGPointMake(CGRectGetMaxX(_icimgv.frame)+10+_titlelbl.frame.size.width/2,35);
        _arrimgv.center = CGPointMake(ViewSizeW-10-_arrimgv.frame.size.width/2,35);
        _fgxlbl.hidden =NO;
        _fgxlbl.frame = CGRectMake(0,0,ViewSizeW,10);
        
    }else{

        NSMutableDictionary *dic = arr[indexpath.row];
        NSString *title = [dic objectForKey:@"title"];
        NSString *imgstr = [dic objectForKey:@"img"];
        _icimgv.image = [UIImage imageNamed:imgstr];
        [_icimgv sizeToFit];
        _icimgv.center = CGPointMake(15+_icimgv.frame.size.width/2,25);
        
        _titlelbl.text = title;
        [_titlelbl sizeToFit];
        _titlelbl.center = CGPointMake(CGRectGetMaxX(_icimgv.frame)+10+_titlelbl.frame.size.width/2,25);
        _arrimgv.center = CGPointMake(ViewSizeW-10-_arrimgv.frame.size.width/2,25);
        
        if (indexpath.row == 1) {
            _phonebtn.hidden = NO;
            [_phonebtn sizeToFit];
            _phonebtn.center = CGPointMake(CGRectGetMinX(_arrimgv.frame)-10-_phonebtn.frame.size.width/2,25);
        }
        _fgx1lbl.hidden = NO;
        _fgx1lbl.frame = CGRectMake(CGRectGetMaxX(_icimgv.frame),49.5,ViewSizeW-CGRectGetMaxX(_icimgv.frame),0.5);
    }
}

-(void)callPress:(CustomButton *)sender{
    if (_callBlock) {
        _callBlock(@"0571-87425396");
    }
}
@end
