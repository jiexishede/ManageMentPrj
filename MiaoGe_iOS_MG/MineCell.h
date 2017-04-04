//
//  MineCell.h
//  MiaoGe_iOS_MG
//
//  Created by miaoge_iOS on 16/8/24.
//  Copyright © 2016年 ZheJiang MiaoGe Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "AppDelegate.h"

@interface MineCell : UITableViewCell
{
    AppDelegate *app;
    NSUserDefaults *ud;
}
@property(nonatomic,strong) UIImageView *headimgv;
@property(nonatomic,strong) UIImageView *arrimgv;
@property(nonatomic,strong) UIImageView *icimgv;
@property(nonatomic,strong) UILabel *fgxlbl;
@property(nonatomic,strong) UILabel *fgx1lbl;
@property(nonatomic,strong) UILabel *titlelbl;
@property(nonatomic,strong) UILabel *namelbl;
@property(nonatomic,strong) UILabel *acclbl;
@property(nonatomic,strong) CustomButton *phonebtn;

@property(nonatomic,copy) void (^callBlock) (NSString *);
-(void)setviewwitharr:(NSMutableArray *)arr withIndex:(NSIndexPath*)indexpath;
@end
