//
//  AppDelegate.h
//  CityJinFu
//
//  Created by xxlc on 16/8/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"
#import "GeTuiSdk.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate ,WXApiDelegate,WBHttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigation;//导航栏
@property (nonatomic,retain) NSArray *tabBarArray;
@property (nonatomic, strong) LeveyTabBarController *leveyTabBarController;

//推送
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (nonatomic, strong) UIView *backView; //背景

- (void)qieHuan;//引导页到主页
- (void)judgeProtectSafe;//指纹密码操作
- (void)hideFinerViewAction;

- (void)hideGestureViewAction;

@end

