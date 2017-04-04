//
//  BDVersion.h
//  BaDian
//
//  Created by sgp on 14-9-3.
//  Copyright (c) 2014年 sgp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGXViewController.h"

@interface MGVersion : NSObject
//是否有可用的强制更新
@property (nonatomic ,assign)BOOL isForceUpdate;
@property (nonatomic ,assign)BOOL isUpdate;

// get the shared instance of BDVersion
+ (MGVersion *)sharedInstance;

// method to check if there is a new version available
- (void) checkAppVersion:(BOOL)showMessage base:(MGXViewController*)cont;

@end
