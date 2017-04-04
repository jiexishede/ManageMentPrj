//
//  BDVersion.m
//  BaDian
//
//  Created by sgp on 14-9-3.
//  Copyright (c) 2014年 sgp. All rights reserved.
//

#import "MGVersion.h"
#import "XClientApi.h"
#import "UIAlertView+Additions.h"

@interface MGVersion()
{
    NSString *desc;
    NSString *version;
    NSString *foucesion;
    NSString *releaseNote;
    NSString *updateUrl;
}
@end

static MGVersion *sharedInstance = nil;

@implementation MGVersion

+ (MGVersion *)sharedInstance
{
	if (sharedInstance == nil)
    {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _isForceUpdate = NO;
    }
    return self;
}

- (void)checkAppVersion:(BOOL)showMessage base:(MGXViewController*)cont{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VERSIONTYPE forKey:@"type"];
    //type 1-安卓 2-Ios
    [[XClientApi sharedClient]postPath:NETURL_VERSIONCHECK parameters:params success:^(AFHTTPRequestOperation *operation, id json) {
        NSString *result = [UtilClass GetString:[json valueForKey:Status]];
        if([result isEqualToString:@"1"]){
            NSDictionary *info = [json valueForKey:@"result"];
            if(info){
                desc = [NSString stringWithFormat:@"%@",[info objectForKey:@"desc"]];
                version = [NSString stringWithFormat:@"%@",[info objectForKey:@"latestVersion"]];  //最新版本
                foucesion = [NSString stringWithFormat:@"%@",[info objectForKey:@"requiredMinVersion"]];  //最新强制更新版本
                updateUrl = [NSString stringWithFormat:@"%@",[info objectForKey:@"downloadUrl"]];
        
                if([VERSION compare:foucesion] != NSOrderedDescending){
                    _isForceUpdate = YES;
                }else if([VERSION compare:version] != NSOrderedDescending ){
                    _isUpdate = YES;
                }else{
                    _isForceUpdate = NO;
                    _isForceUpdate = NO;
                }
                
                if(_isForceUpdate) {
                    [self updtfshow:[NSMutableArray arrayWithObjects:@"立即更新", nil]];
                }else if(_isUpdate){
                    [self updtfshow:[NSMutableArray arrayWithObjects:@"忽略此版本",@"立即更新", nil]];
                }
            }
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)updtfshow:(NSMutableArray*)btnarr{
    NSString *titls = [NSString stringWithFormat:@"有新版本V%@需要更新",version];
    NSString *updesc = [NSString stringWithFormat:@""];
    if ( desc && ![desc isEqualToString:@""] && ![desc isEqualToString:@"(null)"] ) {
        updesc = [NSString stringWithFormat:@"本次更新内容: %@",desc];
    }
 
    if(_isForceUpdate){
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                if (IOS10) {
                    NSDictionary *dict = nil;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl] options:dict completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }
            }
        }title:titls message:updesc cancelButtonName:nil otherButtonTitles:@"立即更新",nil];
        
    }else if(_isUpdate){
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                if (IOS10) {
                    NSDictionary *dict = nil;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl] options:dict completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }
            }
        } title:titls message:updesc cancelButtonName:@"忽略此版本" otherButtonTitles:@"立即更新",nil];
    }
}

@end
