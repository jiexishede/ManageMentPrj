//
//  QRViewController.h
//  wanwan
//
//  Created by cyj on 15/12/1.
//  Copyright © 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "MGXViewController.h"
typedef void(^QRUrlBlock)(NSString *url);
typedef void(^QRlBlock)(NSString *url,NSString *acid);
@interface QRViewController : MGXViewController

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;
@property (nonatomic, copy) QRlBlock qrlBlock;
@end
